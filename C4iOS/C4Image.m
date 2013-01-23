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
}

@property (readwrite, strong, nonatomic) CIContext *filterContext;
@property (readwrite, strong, nonatomic) UIImage *originalImage;
@property (readwrite, strong, nonatomic) CIImage *visibleImage;
@property (readwrite, nonatomic) CGImageRef contents;
@property (readwrite, strong, nonatomic) C4Layer *imageLayer;
@property (readwrite, strong, atomic) NSTimer *animatedImageTimer;
//@property (readwrite, atomic) BOOL shouldAutoreverse;
@end

@implementation C4Image
@synthesize imageLayer;
@synthesize contents = _contents;
@synthesize originalImage = _originalImage;
@synthesize visibleImage = _visibleImage;
@synthesize filterContext = _filterContext;
@synthesize UIImage = _UIImage;
@synthesize CIImage = _CIImage;
@synthesize CGImage = _CGImage;
@synthesize animatedImageTimer;
@synthesize pixelDataLoaded = _pixelDataLoaded;
//@synthesize shouldAutoreverse = _shouldAutoreverse;
//@synthesize animationOptions = _animationOptions;
@synthesize width = _width, height = _height;
@synthesize originalRatio = _originalRatio, originalSize = _originalSize, size = _size;

+(C4Image *)imageNamed:(NSString *)name {
    return [[C4Image alloc] initWithImageName:name];
}

+(C4Image *)imageWithImage:(C4Image *)image {
    return [[C4Image alloc] initWithImage:image];
}

-(id)initWithImage:(C4Image *)image {
    self = [super init];
    if(nil != self) {
        self.originalImage = image.UIImage;
        C4Assert(self.originalImage != nil, @"The C4Image you tried to load (%@) returned nil for its UIImage", image);
        C4Assert(self.originalImage.CGImage != nil, @"The C4Image you tried to load (%@) returned nil for its CGImage", image);
        self.visibleImage = [[CIImage alloc] initWithCGImage:self.originalImage.CGImage];
        C4Assert(self.visibleImage != nil, @"The CIImage you tried to create (%@) returned a nil object", _visibleImage);
        self.frame = self.visibleImage.extent;
        _pixelDataLoaded = NO;
        self.imageLayer.contents = (id)_originalImage.CGImage;
        _constrainsProportions = YES;
        [self setup];
    }
    return self;
}

-(id)initWithRawData:(unsigned char*)data width:(NSInteger)width height:(NSInteger)height {
    self = [super init];
    if (self != nil) {

        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();

        NSUInteger bitsPerComponent = 8;

        CGContextRef context = CGBitmapContextCreate(data, width, height, bitsPerComponent, 4*width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
        CGImageRef image = CGBitmapContextCreateImage(context);
        
        self.originalImage = [UIImage imageWithCGImage:image];
        C4Assert(self.originalImage != nil, @"The C4Image you tried to load (%@) returned nil for its UIImage", image);
//        C4Assert(self.originalImage.CGImage != nil, @"The C4Image you tried to load (%@) returned nil for its CGImage", image);
        self.visibleImage = [[CIImage alloc] initWithCGImage:image];
        C4Assert(self.visibleImage != nil, @"The CIImage you tried to create (%@) returned a nil object", _visibleImage);
        self.frame = self.visibleImage.extent;
        _pixelDataLoaded = NO;
        self.imageLayer.contents = (__bridge id)image;
        _constrainsProportions = YES;
        [self setup];
        
        CGColorSpaceRelease(colorSpace);
        CGContextRelease(context);
    }
    return self;
}

-(id)initWithCGImage:(CGImageRef)image {
    self = [super init];
    if (self != nil) {
        self.originalImage = [UIImage imageWithCGImage:image];
//        _visibleImage = [CIImage imageWithCGImage:image];
        C4Assert(self.originalImage != nil, @"The C4Image you tried to load (%@) returned nil for its UIImage", image);
        C4Assert(self.originalImage.CGImage != nil, @"The C4Image you tried to load (%@) returned nil for its CGImage", image);
        self.visibleImage = [[CIImage alloc] initWithCGImage:image];
        C4Assert(self.visibleImage != nil, @"The CIImage you tried to create (%@) returned a nil object", _visibleImage);
        self.frame = self.visibleImage.extent;
        _pixelDataLoaded = NO;
        self.imageLayer.contents = (__bridge id)image;
        _constrainsProportions = YES;
        [self setup];
    }
    return self;
}

-(id)initWithImageName:(NSString *)name {
    self = [super init];
    if(self != nil) {
        name = [name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        self.originalImage = [UIImage imageNamed:name];
        _originalSize = self.originalImage.size;
        _originalRatio = self.originalSize.width/self.originalSize.height;
        C4Assert(self.originalImage != nil, @"The C4Image you tried to load (%@) returned nil for its UIImage", name);
        C4Assert(self.originalImage.CGImage != nil, @"The C4Image you tried to load (%@) returned nil for its CGImage", name);
        self.visibleImage = [[CIImage alloc] initWithImage:self.originalImage];
        C4Assert(self.visibleImage != nil, @"The CIImage you tried to create (%@) returned a nil object", self.visibleImage);
        _pixelDataLoaded = NO;
        self.frame = self.CIImage.extent;
        self.imageLayer.contents = (id)_originalImage.CGImage;
        _constrainsProportions = YES;
        [self setup];
    }
    return self;
}

-(UIImage *)UIImage {
    CIContext *c = [CIContext contextWithOptions:nil];
    UIImage *visibleUIImage = [UIImage imageWithCGImage:[c createCGImage:self.visibleImage fromRect:self.visibleImage.extent]];
    return visibleUIImage;
}

-(CIImage *)CIImage {
    return self.visibleImage;
}

-(CGImageRef)CGImage {
    if (_filterContext == nil) self.filterContext = [CIContext contextWithOptions:nil];
    return [self.filterContext createCGImage:_visibleImage fromRect:_visibleImage.extent];
}

-(void)setImage:(C4Image *)image {
    CGPoint oldOrigin = self.frame.origin;
    self.originalImage = image.UIImage;
    C4Assert(_originalImage != nil, @"The C4Image you tried to load (%@) returned nil for its UIImage", image);
    self.visibleImage = image.CIImage;
    C4Assert(_visibleImage != nil, @"The C4Image you tried to load (%@) returned nil for its CIImage", image);
    CGRect newFrame = _visibleImage.extent;
    newFrame.origin = oldOrigin;
    self.frame = newFrame;
    [self.imageLayer animateContents:self.CGImage];
}

-(C4Layer *)imageLayer {
    return (C4Layer *)self.layer;
}

+(Class)layerClass {
    return [C4Layer class];
}

-(void)setContents:(CGImageRef)image {
    if(self.animationDelay == 0.0f) [self _setContents:(__bridge id)image];
    else [self performSelector:@selector(_setContents:) withObject:(__bridge id)image afterDelay:self.animationDelay];
}

-(void)_setContents:(id)image {
    [self.imageLayer animateContents:(__bridge CGImageRef)image];
}

#pragma mark Filters
-(void)additionComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIAdditionCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorBurn:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorBurnBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorControlSaturation:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:@(saturation) forKey:@"inputSaturation"];
    [filter setValue:@(brightness) forKey:@"inputBrightness"];
    [filter setValue:@(contrast) forKey:@"inputContrast"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorDodge:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorDodgeBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorInvert {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}


-(void)colorMatrix:(UIColor *)color bias:(CGFloat)bias {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMatrix"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    CGFloat red, green, blue, alpha;
    [color getRed:&red green:&green blue:&blue alpha:&alpha];
    
    [filter setValue:[CIVector vectorWithX:red Y:0 Z:0 W:0] forKey:@"inputRVector"];
    [filter setValue:[CIVector vectorWithX:0 Y:green Z:0 W:0] forKey:@"inputGVector"];
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:blue W:0] forKey:@"inputBVector"];
    [filter setValue:[CIVector vectorWithX:0 Y:0 Z:0 W:alpha] forKey:@"inputAVector"];
    [filter setValue:[CIVector vectorWithX:bias Y:bias Z:bias W:bias] forKey:@"inputBiasVector"];
    
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorMonochrome:(UIColor *)color inputIntensity:(CGFloat)intensity {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:color.CIColor forKey:@"inputColor"];
    [filter setValue:@(intensity) forKey:@"inputIntensity"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)darkenBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIDarkenBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)differenceBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIDifferenceBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)exclusionBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIExclusionBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)exposureAdjust:(CGFloat)adjustment {
    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:@(adjustment) forKey:@"inputEV"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)falseColor:(UIColor *)color1 color2:(UIColor *)color2 {
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:color1 forKey:@"inputColor0"];
    [filter setValue:color2 forKey:@"inputColor1"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)gammaAdjustment:(CGFloat)adjustment {
    CIFilter *filter = [CIFilter filterWithName:@"CIGammaAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:@(adjustment) forKey:@"inputPower"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)hardLightBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)highlightShadowAdjust:(CGFloat)highlightAmount shadowAmount:(CGFloat)shadowAmount {
    CIFilter *filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:@(highlightAmount) forKey:@"inputHighlightAmount"];
    [filter setValue:@(shadowAmount) forKey:@"inputShadowAmount"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)hueAdjust:(CGFloat)angle {
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:@(angle) forKey:@"inputAngle"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)hueBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIHueBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)lightenBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CILightenBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)luminosityBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CILuminosityBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)maximumComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIMaximumCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)minimumComposite:(C4Image *)backgroundImage {    
    CIFilter *filter = [CIFilter filterWithName:@"CIMinimumCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)multiplyBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIMultiplyBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)multiplyComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIMultiplyCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)overlayBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIOverlayBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)saturationBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISaturationBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)screenBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIScreenBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sepiaTone:(CGFloat)intensity {
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:@(intensity) forKey:@"inputIntensity"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)softLightBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISoftLightBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sourceAtopComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISourceAtopCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sourceInComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISourceInCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sourceOutComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISourceOutCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sourceOverComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)straighten:(CGFloat)angle {
    CIFilter *filter = [CIFilter filterWithName:@"CIStraightenFilter"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:@(angle) forKey:@"inputAngle"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)tempartureAndTint:(CGSize)neutral target:(CGSize)targetNeutral {
    CIFilter *filter = [CIFilter filterWithName:@"CITemperatureAndTint"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:neutral.width Y:neutral.height] forKey:@"inputNeutral"];
    [filter setValue:[CIVector vectorWithX:targetNeutral.width Y:targetNeutral.height] forKey:@"inputTargetNeutral"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)toneCurve:(CGPoint *)pointArray {
    CIFilter *filter = [CIFilter filterWithName:@"CIToneCurve"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithCGPoint:pointArray[0]] forKey:@"inputPoint0"];
    [filter setValue:[CIVector vectorWithCGPoint:pointArray[1]] forKey:@"inputPoint1"];
    [filter setValue:[CIVector vectorWithCGPoint:pointArray[2]] forKey:@"inputPoint2"];
    [filter setValue:[CIVector vectorWithCGPoint:pointArray[3]] forKey:@"inputPoint3"];
    [filter setValue:[CIVector vectorWithCGPoint:pointArray[4]] forKey:@"inputPoint4"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)vibranceAdjust:(CGFloat)amount {
    CIFilter *filter = [CIFilter filterWithName:@"CIVibrance"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:@(amount) forKey:@"inputAmount"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)whitePointAdjust:(UIColor *)color {
    CIFilter *filter = [CIFilter filterWithName:@"CIWhitePointAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:color.CIColor forKey:@"inputColor"];
    self.visibleImage = [filter outputImage];
    C4Assert(_visibleImage != nil, @"The filter you tried to create (%@) returned nil for its outputImage", filter.name);
    [self.imageLayer animateContents:self.CGImage];
}

-(void)loadPixelData {
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
}

#pragma mark New Stuff
-(UIColor *)colorAt:(CGPoint)point {
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

-(C4Vector *)rgbVectorAt:(CGPoint)point {
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
        C4Assert(_originalImage != nil, @"The C4Image you tried to load (%@) returned nil for its UIImage", imageNames[0]);
        C4Assert(_originalImage.CGImage != nil, @"The C4Image you tried to load (%@) returned nil for its CGImage", imageNames[0]);
        _visibleImage = [[CIImage alloc] initWithCGImage:_originalImage.CGImage];
        C4Assert(_visibleImage != nil, @"The CIImage you tried to create (%@) returned a nil object", _visibleImage);
        self.frame = _visibleImage.extent;
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
    C4Image *img = [[C4Image alloc] initWithData:imageData];
    return img;
}

-(id)initWithData:(NSData *)imageData {
    self = [super init];
    if(self != nil) {
        UIImage *img = [UIImage imageWithData:imageData];
        img = [self fixOrientationFromCamera:img];
        self.originalImage = img;
        C4Assert(_originalImage != nil, @"The UIImage you tried to create returned %@ for from the NSData you provided", _originalImage);
        C4Assert(_originalImage.CGImage != nil, @"The UIImage you tried to create returned %@ for it's CGImage", _originalImage.CGImage);
        _visibleImage = [[CIImage alloc] initWithCGImage:_originalImage.CGImage];
        C4Assert(_visibleImage != nil, @"The CIImage you tried to create returned a %@ object", _visibleImage);
        self.frame = _visibleImage.extent;
        self.imageLayer.contents = (id)_originalImage.CGImage;
    }
    return self;
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

//-(void)setAnimationOptions:(NSUInteger)animationOptions {
//    /*
//     This method needs to be in all C4Control subclasses, not sure why it doesn't inherit properly
//     
//     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
//     i.e. reversing without having set REPEAT
//     
//     UIView animation will flicker if we don't do this...
//     */
//    ((id <C4LayerAnimation>)self.layer).animationOptions = _animationOptions;
//    
//    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
//        self.shouldAutoreverse = YES;
//        animationOptions &= ~AUTOREVERSE;
//    }
//    
//    _animationOptions = animationOptions | BEGINCURRENT;
//}

-(CGFloat)width {
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width {
    _width = width;
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    if(_constrainsProportions) newFrame.size.height = width/self.originalRatio;
    self.frame = newFrame;
}

-(CGFloat)height {
    return self.bounds.size.height;
}

-(void)setHeight:(CGFloat)height {
    _height = height;
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
@end
