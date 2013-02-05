//
//  C4Image.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-09.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Image.h"
#import "C4Layer.h"

@interface C4Image () {
    unsigned char *rawData;
    NSUInteger bytesPerPixel;
    NSUInteger bytesPerRow;
    NSUInteger currentAnimatedImage;
    dispatch_queue_t filterQueue;
    BOOL isFiltered;
}

@property (readwrite, strong, nonatomic) CIContext *filterContext;
@property (readwrite, strong, nonatomic) UIImage *originalImage;
@property (readwrite, strong, nonatomic) CIImage *visibleImage;
@property (readwrite, nonatomic) CGImageRef contents;
@property (readwrite, strong, nonatomic) C4Layer *imageLayer;
@property (readwrite, strong, atomic) NSTimer *animatedImageTimer;
@end

@implementation C4Image

+(C4Image *)imageNamed:(NSString *)name {
    return [[C4Image alloc] initWithImageName:name];
}

+(C4Image *)imageWithImage:(C4Image *)image {
    return [[C4Image alloc] initWithImage:image];
}

-(id)initWithRawData:(unsigned char*)data width:(NSInteger)width height:(NSInteger)height {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, 4*width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGImageRef image = CGBitmapContextCreateImage(context);

    return [self initWithCGImage:image];
}

-(id)initWithCGImage:(CGImageRef)image {
    return [self initWithUIImage:[UIImage imageWithCGImage:image]];
}

-(id)initWithImageName:(NSString *)name {
    name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [self initWithUIImage:[UIImage imageNamed:name]];
}

-(id)initWithImage:(C4Image *)image {
    return [self initWithUIImage:image.UIImage];
}

-(id)initWithUIImage:(UIImage *)image {
    self = [super init];
    if(self != nil) {
        _originalImage = image;
        [self setProperties];
        self.contents = _originalImage.CGImage;
        _constrainsProportions = YES;
        _filteredImage = self.contents;
    }
    return self;
}

-(void)setProperties {
    _originalSize = _originalImage.size;
    _originalRatio = _originalSize.width / _originalSize.height;
    _visibleImage = nil;
    
    CGRect scaledFrame = CGRectZero;
    scaledFrame.origin = self.frame.origin;
    scaledFrame.size = _originalSize;
    self.frame = scaledFrame;
}

-(void)showOriginalImage {
    self.contents = _originalImage.CGImage;
}

-(void)showFilteredImage {
    self.contents = _filteredImage;
}

-(UIImage *)UIImage {
    return [UIImage imageWithCGImage:self.contents];
}

-(CIImage *)CIImage {
    return [CIImage imageWithCGImage:self.contents];
}

-(CGImageRef)CGImage {
    return self.contents;
}

-(CGImageRef)contents {
    return (__bridge CGImageRef)self.imageLayer.contents;
}
-(void)setContents:(CGImageRef)image {
    if(self.animationDuration == 0.0f) self.imageLayer.contents = (__bridge id)image;
    else [self performSelector:@selector(_setContents:) withObject:(__bridge id)image afterDelay:self.animationDelay];
}

-(void)_setContents:(id)image {
    [self.imageLayer animateContents:(__bridge CGImageRef)image];
}

-(void)setImage:(C4Image *)image {
    _originalImage = image.UIImage;
    [self setProperties];
    [self setContents:_originalImage.CGImage];
}

-(C4Layer *)imageLayer {
    return (C4Layer *)self.layer;
}

+(Class)layerClass {
    return [C4Layer class];
}

-(CIImage *)visibleImage {
    if(isFiltered == NO) {
        return _originalImage.CIImage;
    }
    return _visibleImage;
}

#pragma mark Filters

-(void)additionComposite:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIAdditionCompositing"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)colorBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIColorBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)colorBurn:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIColorBurnBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)colorControlSaturation:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIColorControls"];
        [filter setValue:@(saturation) forKey:@"inputSaturation"];
        [filter setValue:@(brightness) forKey:@"inputBrightness"];
        [filter setValue:@(contrast) forKey:@"inputContrast"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)colorDodge:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIColorDodgeBlendMode"];
        CIImage* output = [filter outputImage];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)colorInvert {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIColorInvert"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)colorMatrix:(UIColor *)color bias:(CGFloat)bias {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIColorMatrix"];

        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        
        [filter setValue:[CIVector vectorWithX:red Y:0 Z:0 W:0] forKey:@"inputRVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:green Z:0 W:0] forKey:@"inputGVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:blue W:0] forKey:@"inputBVector"];
        [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:alpha] forKey:@"inputAVector"];
        [filter setValue:[CIVector vectorWithX:bias Y:bias Z:bias W:bias] forKey:@"inputBiasVector"];
        
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)colorMonochrome:(UIColor *)color inputIntensity:(CGFloat)intensity {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIColorMonochrome"];
        [filter setValue:color.CIColor forKey:@"inputColor"];
        [filter setValue:@(intensity) forKey:@"inputIntensity"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)darkenBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIDarkenBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)differenceBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIDifferenceBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)exclusionBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIExclusionBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)exposureAdjust:(CGFloat)adjustment {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIExposureAdjust"];
        [filter setValue:@(adjustment) forKey:@"inputEV"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)falseColor:(UIColor *)color1 color2:(UIColor *)color2 {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIFalseColor"];
        [filter setValue:color1 forKey:@"inputColor0"];
        [filter setValue:color2 forKey:@"inputColor1"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)gammaAdjustment:(CGFloat)adjustment {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIGammaAdjust"];
        [filter setValue:@(adjustment) forKey:@"inputPower"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)hardLightBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIHardLightBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)highlightShadowAdjust:(CGFloat)highlightAmount shadowAmount:(CGFloat)shadowAmount {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIHighlightShadowAdjust"];
        [filter setValue:@(highlightAmount) forKey:@"inputHighlightAmount"];
        [filter setValue:@(shadowAmount) forKey:@"inputShadowAmount"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)hueAdjust:(CGFloat)angle {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIHueAdjust"];
        [filter setValue:@(angle) forKey:@"inputAngle"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)hueBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIHueBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)lightenBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CILightenBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)luminosityBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CILuminosityBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)maximumComposite:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIMaximumCompositing"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)minimumComposite:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIMinimumCompositing"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)multiplyBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIMultiplyBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)multiplyComposite:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIMultiplyCompositing"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)overlayBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIOverlayBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)saturationBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CISaturationBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)screenBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIScreenBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)sepiaTone:(CGFloat)intensity {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CISepiaTone"];
        [filter setValue:@(intensity) forKey:@"inputIntensity"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)softLightBlend:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CISoftLightBlendMode"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)sourceAtopComposite:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CISourceAtopCompositing"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)sourceInComposite:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CISourceInCompositing"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)sourceOutComposite:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CISourceOutCompositing"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)sourceOverComposite:(C4Image *)backgroundImage {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CISourceOverCompositing"];
        [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)straighten:(CGFloat)angle {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIStraightenFilter"];
        [filter setValue:@(angle) forKey:@"inputAngle"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)tempartureAndTint:(CGSize)neutral target:(CGSize)targetNeutral {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CITemperatureAndTint"];
        [filter setValue:[CIVector vectorWithX:neutral.width Y:neutral.height] forKey:@"inputNeutral"];
        [filter setValue:[CIVector vectorWithX:targetNeutral.width Y:targetNeutral.height] forKey:@"inputTargetNeutral"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)toneCurve:(CGPoint *)pointArray {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIToneCurve"];
        [filter setValue:[CIVector vectorWithCGPoint:pointArray[0]] forKey:@"inputPoint0"];
        [filter setValue:[CIVector vectorWithCGPoint:pointArray[1]] forKey:@"inputPoint1"];
        [filter setValue:[CIVector vectorWithCGPoint:pointArray[2]] forKey:@"inputPoint2"];
        [filter setValue:[CIVector vectorWithCGPoint:pointArray[3]] forKey:@"inputPoint3"];
        [filter setValue:[CIVector vectorWithCGPoint:pointArray[4]] forKey:@"inputPoint4"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)vibranceAdjust:(CGFloat)amount {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIVibrance"];
        [filter setValue:@(amount) forKey:@"inputAmount"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(void)whitePointAdjust:(UIColor *)color {
    dispatch_async([self filterQueue], ^{
        CIFilter *filter = [self prepareFilterWithName:@"CIWhitePointAdjust"];
        [filter setValue:color.CIColor forKey:@"inputColor"];
        CIImage* output = [filter outputImage];
        [self setContentsWithFilterOutput:output filterName:filter.name];
    });
}

-(CIFilter *)prepareFilterWithName:(NSString *)filterName {
    CIFilter *filter = [CIFilter filterWithName:filterName];
    [filter setDefaults];
    [filter setValue:self.CIImage forKey:@"inputImage"];
    return filter;
}

-(void)setContentsWithFilterOutput:(CIImage *)output filterName:(NSString *)filterName {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setContents:[self.filterContext createCGImage:output fromRect:self.bounds]];
        _filteredImage = self.contents;
        [self postNotification:[filterName stringByAppendingString:@"Complete"]];
    });
}

-(void)loadPixelData {
    const char *queueName = [@"pixelDataQueue" UTF8String];
    dispatch_queue_t pixelDataQueue = dispatch_queue_create(queueName,  DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(pixelDataQueue, ^{
        NSUInteger width = CGImageGetWidth(self.CGImage);
        NSUInteger height = CGImageGetHeight(self.CGImage);
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        
        bytesPerPixel = 4;
        bytesPerRow = bytesPerPixel * width;
        free(rawData);
        rawData = malloc(height * bytesPerRow);
        
        NSUInteger bitsPerComponent = 8;
        CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGColorSpaceRelease(colorSpace);
        CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
        CGContextRelease(context);
        _pixelDataLoaded = YES;
        [self postNotification:@"pixelDataWasLoaded"];
    });
}

-(CIContext *)filterContext {
    if (_filterContext == nil) {
        _filterContext = [CIContext contextWithOptions:nil];
    }
    return _filterContext;
}

#pragma mark New Stuff
-(UIColor *)colorAt:(CGPoint)point {
    if(_pixelDataLoaded == NO) {
        C4Log(@"You must first load pixel data");
    } else  if ([self pointInside:point withEvent:nil]) {
        if(rawData == nil) {
            [self loadPixelData];
        }
        NSUInteger byteIndex = (NSUInteger)(bytesPerPixel * point.x + bytesPerRow * point.y);
        NSInteger r, g, b, a;
        r = rawData[byteIndex];
        g = rawData[byteIndex + 1];
        b = rawData[byteIndex + 2];
        a = rawData[byteIndex + 3];
        
        return [UIColor colorWithRed:RGBToFloat(r) green:RGBToFloat(g) blue:RGBToFloat(b) alpha:RGBToFloat(a)];
    }
    return [UIColor clearColor];
}

-(C4Vector *)rgbVectorAt:(CGPoint)point {
    if(_pixelDataLoaded == NO) {
        C4Log(@"You must first load pixel data");
    } else if([self pointInside:point withEvent:nil]) {
        if(self.pixelDataLoaded == NO) {
            [self loadPixelData];
        }
        NSUInteger byteIndex = (NSUInteger)(bytesPerPixel * point.x + bytesPerRow * point.y);
        CGFloat r, g, b;
        r = rawData[byteIndex];
        g = rawData[byteIndex + 1];
        b = rawData[byteIndex + 2];
        return [C4Vector vectorWithX:r Y:g Z:b];
    }
    return [C4Vector vectorWithX:-1 Y:-1 Z:-1];
}

@synthesize animatedImageDuration, animatedImage, animatedImages;

+(C4Image *)animatedImageWithNames:(NSArray *)imageNames {
    C4Image *animImg = [[C4Image alloc] initAnimatedImageWithNames:imageNames];
    return animImg;
}

-(id)initAnimatedImageWithNames:(NSArray *)imageNames {
    self = [super init];
    if(nil != self) {
        //        self.animatedImageDuration = 2.0f;
        self.animatedImages = CFArrayCreateMutable(kCFAllocatorDefault, 0, nil);
        for(int i = 0; i < [imageNames count]; i++) {
            NSString *name = imageNames[i];
            name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            UIImage *img = [UIImage imageNamed:name];
            CFArrayAppendValue(self.animatedImages,img.CGImage);
        }
        
        UIImage *image = [UIImage imageNamed:imageNames[0]];
        self.originalImage = image;
        _originalSize = self.originalImage.size;
        C4Assert(_originalImage != nil, @"The C4Image you tried to load (%@) returned nil for its UIImage", imageNames[0]);
        C4Assert(_originalImage.CGImage != nil, @"The C4Image you tried to load (%@) returned nil for its CGImage", imageNames[0]);
        _visibleImage = [CIImage imageWithCGImage:_originalImage.CGImage];
        C4Assert(_visibleImage != nil, @"The CIImage you tried to create (%@) returned a nil object", _visibleImage);
        
        CGRect scaledImageFrame = _visibleImage.extent;
        scaledImageFrame.size = _originalSize;
        self.frame = scaledImageFrame;
        
        currentAnimatedImage = 0;
        self.imageLayer.contents = (__bridge id)CFArrayGetValueAtIndex(self.animatedImages,currentAnimatedImage);
    }
    return  self;
}

-(void)play {
    if(self.animatedImageTimer.isValid) [self stop];
    if(CFArrayGetCount(self.animatedImages) > 1) {
        self.animatedImageTimer = [NSTimer timerWithTimeInterval:self.animatedImageDuration/CFArrayGetCount(self.animatedImages) target:self selector:@selector(animateImages) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.animatedImageTimer forMode:NSDefaultRunLoopMode];
    }
}

-(void)stop {
    [self.animatedImageTimer invalidate];
}

-(void)animateImages {
    currentAnimatedImage++;
    if(currentAnimatedImage >= CFArrayGetCount(self.animatedImages)) currentAnimatedImage = 0;
    self.imageLayer.contents = (__bridge id)CFArrayGetValueAtIndex(self.animatedImages,currentAnimatedImage);
}

+(C4Image *)imageWithData:(NSData *)imageData {
    return [[C4Image alloc] initWithData:imageData];
}

-(id)initWithData:(NSData *)imageData {
    return [self initWithUIImage:[UIImage imageWithData:imageData]];
}

/*
 FUCK TERRRRRRRRRIBLE HACK...
 Problem is creating C4Images from NSData provided by AVFoundation...
 Because it's taking video frames it remaps it to fit the appropriate resolution (i.e. wide not tall)
 */
-(UIImage *)fixOrientationFromCamera:(UIImage *)_image {
    return nil;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch ([_image imageOrientation]) {
        case UIImageOrientationUp:
            C4Log(@"up");
            break;
        case UIImageOrientationUpMirrored:
            C4Log(@"upm");
            break;
        case UIImageOrientationDown:
            C4Log(@"down");
            break;
        case UIImageOrientationDownMirrored:
            C4Log(@"downm");
            break;
        case UIImageOrientationLeft:
            C4Log(@"left");
            break;
        case UIImageOrientationLeftMirrored:
            C4Log(@"leftm");
            break;
        case UIImageOrientationRight:
            C4Log(@"right");
            break;
        case UIImageOrientationRightMirrored:
            C4Log(@"rightm");
            break;
        default:
            C4Assert(NO,@"Could not understand the orientation returned by [UIIimage imageOrientation]");
            break;
    }
    transform = CGAffineTransformRotate(transform, -1*HALF_PI);
//    CGContextRef CGBitmapContextCreate ( void *data, size_t width, size_t height, size_t bitsPerComponent, size_t bytesPerRow, CGColorSpaceRef colorspace, CGBitmapInfo bitmapInfo )
    
    size_t width = (size_t) _image.size.width;
    size_t height = (size_t) _image.size.height;
    CGContextRef ctx = CGBitmapContextCreate(NULL, width, height,
                                             CGImageGetBitsPerComponent(_image.CGImage), 0,
                                             CGImageGetColorSpace(_image.CGImage),
                                             CGImageGetBitmapInfo(_image.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    CGContextDrawImage(ctx, CGRectMake(-1*_image.size.height,0,_image.size.height, _image.size.width), _image.CGImage);
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    
    return img;
}

-(CGFloat)width {
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    if(_constrainsProportions) newFrame.size.height = width/self.originalRatio;
    self.frame = newFrame;
}

-(CGFloat)height {
    return self.bounds.size.height;
}

-(void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    if(_constrainsProportions) newFrame.size.width = height * self.originalRatio;
    self.frame = newFrame;
}

-(CGSize)size {
    return self.frame.size;
}

-(void)setSize:(CGSize)size {
    CGRect newFrame = CGRectZero;
    newFrame.origin = self.origin;
    newFrame.size = size;
    self.frame = newFrame;
}

+(C4Image *)defaultStyle {
    return (C4Image *)[C4Image appearance];
}

-(C4Image *)copyWithZone:(NSZone *)zone {
    return [[C4Image allocWithZone:zone] initWithImage:self];
}

-(dispatch_queue_t)filterQueue {
    if(filterQueue == nil) {
        const char *label = [[@"FILTER_QUEUE_" stringByAppendingString:[self description]]UTF8String];
        filterQueue = dispatch_queue_create(label, DISPATCH_QUEUE_CONCURRENT);
    }
    return filterQueue;
}
@end
