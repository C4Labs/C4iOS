//
//  C4Image.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-09.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Image.h"

@interface C4Image () {
    unsigned char *rawData;
    NSUInteger bytesPerPixel;
    NSUInteger bytesPerRow;
}

-(void)_setShadowOffset:(NSValue *)shadowOffset;
-(void)_setShadowRadius:(NSNumber *)shadowRadius;
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity;
-(void)_setShadowColor:(UIColor *)shadowColor;
-(void)_setShadowPath:(id)shadowPath;
@property (readwrite, strong, nonatomic) CIContext *filterContext;
@property (readwrite, strong, nonatomic) UIImage *originalImage;
@property (readwrite, strong, nonatomic) CIImage *visibleImage;
@property (readwrite, nonatomic) CGImageRef contents;
@property (readwrite, strong, nonatomic) C4Layer *imageLayer;
@end

@implementation C4Image
@synthesize imageLayer;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowRadius = _shadowRadius;
@synthesize shadowOpacity = _shadowOpacity;
@synthesize shadowPath = _shadowPath;
@synthesize contents = _contents;
@synthesize originalImage = _originalImage;
@synthesize visibleImage = _visibleImage;
@synthesize filterContext = _filterContext;
@synthesize UIImage = _UIImage;
@synthesize CIImage = _CIImage;
@synthesize CGImage = _CGImage;

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
        NSAssert(_originalImage != nil, @"The C4Image you tried to load returned nil for it's UIImage");
        NSAssert(_originalImage.CGImage != nil, @"The C4Image you tried to load returned nil for it's CGImage");
        _visibleImage = [[CIImage alloc] initWithCGImage:_originalImage.CGImage];
        NSAssert(_visibleImage != nil, @"The CIImage you tried to create returned a nil object");
        self.frame = _visibleImage.extent;
        self.imageLayer.contents = (id)_originalImage.CGImage;
    }
    return self;
}

-(id)initWithImageName:(NSString *)name {
    self = [super init];
    if(self != nil) {
        self.originalImage = [UIImage imageNamed:name];
        NSAssert(_originalImage != nil, @"The C4Image you tried to load returned nil for it's UIImage");
        NSAssert(_originalImage.CGImage != nil, @"The C4Image you tried to load returned nil for it's CGImage");
        self.visibleImage = [[CIImage alloc] initWithCGImage:_originalImage.CGImage];
        NSAssert(_visibleImage != nil, @"The CIImage you tried to create returned a nil object");

        self.frame = self.CIImage.extent;
        [self.imageLayer setContents:(id)_originalImage.CGImage];
    }
    return self;
}

-(UIImage *)UIImage {
    return [UIImage imageWithCIImage:_visibleImage];
}

-(CIImage *)CIImage {
    return self.visibleImage;
}

-(CGImageRef)CGImage {
    if (_filterContext == nil) self.filterContext = [CIContext contextWithOptions:nil];
    return [self.filterContext createCGImage:_visibleImage fromRect:_visibleImage.extent];
}

-(void)setImage:(C4Image *)image {
    self.originalImage = image.UIImage;
    NSAssert(_originalImage != nil, @"The C4Image you tried to load returned nil for its UIImage");
    self.visibleImage = image.CIImage;
    NSAssert(_visibleImage != nil, @"The C4Image you tried to load returned nil for its CIImage");
    self.frame = _visibleImage.extent;
    [self.imageLayer animateContents:self.CGImage];
}

-(C4Layer *)imageLayer {
    return (C4Layer *)self.layer;
}

+(Class)layerClass {
    return [C4Layer class];
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    [self performSelector:@selector(_setShadowOffset:) withObject:[NSValue valueWithCGSize:shadowOffset] afterDelay:self.animationDelay];
}
-(void)_setShadowOffset:(NSValue *)shadowOffset {
    [self.imageLayer animateShadowOffset:[shadowOffset CGSizeValue]];
}

-(void)setShadowRadius:(CGFloat)shadowRadius {
    [self performSelector:@selector(_setShadowRadius:) withObject:[NSNumber numberWithFloat:shadowRadius] afterDelay:self.animationDelay];
}
-(void)_setShadowRadius:(NSNumber *)shadowRadius {
    [self.imageLayer animateShadowRadius:[shadowRadius floatValue]];
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self performSelector:@selector(_setShadowOpacity:) withObject:[NSNumber numberWithFloat:shadowOpacity] afterDelay:self.animationDelay];
}
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity {
    [self.imageLayer animateShadowOpacity:[shadowOpacity floatValue]];
}

-(void)setShadowColor:(UIColor *)shadowColor {
    [self performSelector:@selector(_setShadowColor:) withObject:shadowColor afterDelay:self.animationDelay];
}
-(void)_setShadowColor:(UIColor *)shadowColor {
    [self.imageLayer animateShadowColor:shadowColor.CGColor];
}

-(void)setShadowPath:(CGPathRef)shadowPath {
    [self performSelector:@selector(_setShadowPath:) withObject:(__bridge id)shadowPath afterDelay:self.animationDelay];
}
-(void)_setShadowPath:(id)shadowPath {
    [self.imageLayer animateShadowPath:(__bridge CGPathRef)shadowPath];
}

-(void)setAnimationDuration:(CGFloat)animationDuration {
    [super setAnimationDuration:animationDuration];
    self.imageLayer.animationDuration = animationDuration;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    [super setAnimationOptions:animationOptions];
    self.imageLayer.animationOptions = animationOptions;
}

-(void)setContents:(CGImageRef)image {
    [self performSelector:@selector(_setContents:) withObject:(__bridge id)image afterDelay:self.animationDelay];
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
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorBurn:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorBurnBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorControlSaturation:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorControls"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:saturation] forKey:@"inputSaturation"];
    [filter setValue:[NSNumber numberWithFloat:brightness] forKey:@"inputBrightness"];
    [filter setValue:[NSNumber numberWithFloat:contrast] forKey:@"inputContrast"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorDodge:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorDodgeBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorInvert {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
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
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)colorMonochrome:(UIColor *)color inputIntensity:(CGFloat)intensity {
    CIFilter *filter = [CIFilter filterWithName:@"CIColorMonochrome"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:color.CIColor forKey:@"inputColor"];
    [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)darkenBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIDarkenBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)differenceBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIDifferenceBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)exclusionBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIExclusionBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)exposureAdjust:(CGFloat)adjustment {
    CIFilter *filter = [CIFilter filterWithName:@"CIExposureAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:adjustment] forKey:@"inputEV"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)falseColor:(UIColor *)color1 color2:(UIColor *)color2 {
    CIFilter *filter = [CIFilter filterWithName:@"CIFalseColor"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:color1 forKey:@"inputColor0"];
    [filter setValue:color2 forKey:@"inputColor1"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)gammaAdjustment:(CGFloat)adjustment {
    CIFilter *filter = [CIFilter filterWithName:@"CIGammaAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:adjustment] forKey:@"inputPower"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)hardLightBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIHardLightBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)highlightShadowAdjust:(CGFloat)highlightAmount shadowAmount:(CGFloat)shadowAmount {
    CIFilter *filter = [CIFilter filterWithName:@"CIHighlightShadowAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:highlightAmount] forKey:@"inputHighlightAmount"];
    [filter setValue:[NSNumber numberWithFloat:shadowAmount] forKey:@"inputShadowAmount"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)hueAdjust:(CGFloat)angle {
    CIFilter *filter = [CIFilter filterWithName:@"CIHueAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)hueBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIHueBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)lightenBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CILightenBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)luminosityBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CILuminosityBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)maximumComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIMaximumCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)minimumComposite:(C4Image *)backgroundImage {    
    CIFilter *filter = [CIFilter filterWithName:@"CIMinimumCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)multiplyBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIMultiplyBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)multiplyComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIMultiplyCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)overlayBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIOverlayBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)saturationBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISaturationBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)screenBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CIScreenBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sepiaTone:(CGFloat)intensity {
    CIFilter *filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:intensity] forKey:@"inputIntensity"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)softLightBlend:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISoftLightBlendMode"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sourceAtopComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISourceAtopCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sourceInComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISourceInCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sourceOutComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISourceOutCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)sourceOverComposite:(C4Image *)backgroundImage {
    CIFilter *filter = [CIFilter filterWithName:@"CISourceOverCompositing"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:backgroundImage.CIImage forKey:@"inputBackgroundImage"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)straighten:(CGFloat)angle {
    CIFilter *filter = [CIFilter filterWithName:@"CIStraightenFilter"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:angle] forKey:@"inputAngle"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)tempartureAndTint:(CGSize)neutral target:(CGSize)targetNeutral {
    CIFilter *filter = [CIFilter filterWithName:@"CITemperatureAndTint"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[CIVector vectorWithX:neutral.width Y:neutral.height] forKey:@"inputNeutral"];
    [filter setValue:[CIVector vectorWithX:targetNeutral.width Y:targetNeutral.height] forKey:@"inputTargetNeutral"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
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
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)vibranceAdjust:(CGFloat)amount {
    CIFilter *filter = [CIFilter filterWithName:@"CIVibrance"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:[NSNumber numberWithFloat:amount] forKey:@"inputAmount"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)whitePointAdjust:(UIColor *)color {
    CIFilter *filter = [CIFilter filterWithName:@"CIWhitePointAdjust"];
    [filter setDefaults];
    [filter setValue:_visibleImage forKey:@"inputImage"];
    [filter setValue:color.CIColor forKey:@"inputColor"];
    self.visibleImage = [filter outputImage];
    NSAssert(_visibleImage != nil, @"The filter you tried to create returned nil for its outputImage");
    [self.imageLayer animateContents:self.CGImage];
}

-(void)loadPixelData {
    NSUInteger width = CGImageGetWidth(self.CGImage);
    NSUInteger height = CGImageGetHeight(self.CGImage);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    bytesPerPixel = 4;
    bytesPerRow = bytesPerPixel * width;
    rawData = malloc(height * bytesPerRow);
    
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), self.CGImage);
    CGContextRelease(context);
}

-(UIColor *)colorAt:(CGPoint)point {
    if(rawData == nil) {
        [self loadPixelData];
    }
    NSUInteger byteIndex = bytesPerPixel * point.x + bytesPerRow * point.y;
    CGFloat r, g, b, a;
    r = rawData[byteIndex];
    g = rawData[byteIndex + 1];
    b = rawData[byteIndex + 2];
    a = rawData[byteIndex + 3];
    
    return [UIColor colorWithRed:RGBToFloat(r) green:RGBToFloat(g) blue:RGBToFloat(b) alpha:RGBToFloat(a)];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *t = [touches anyObject];
    CGPoint p = [t locationInView:self];
    C4Log(@"%@",[self colorAt:p]);
}

@end
