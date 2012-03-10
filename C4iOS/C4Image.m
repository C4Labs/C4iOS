//
//  C4Image.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-09.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Image.h"

@interface C4Image ()
-(void)_setShadowOffset:(NSValue *)shadowOffset;
-(void)_setShadowRadius:(NSNumber *)shadowRadius;
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity;
-(void)_setShadowColor:(UIColor *)shadowColor;
-(void)_setShadowPath:(id)shadowPath;
@property (readwrite, strong, nonatomic) C4Layer *imageLayer;
@end

@implementation C4Image
@synthesize imageLayer;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowRadius = _shadowRadius;
@synthesize shadowOpacity = _shadowOpacity;
@synthesize shadowPath = _shadowPath;

+(C4Image *)imageNamed:(NSString *)name {
    return [[C4Image alloc] initWithImageName:name];
}

+(C4Image *)imageWithImage:(C4Image *)image {
    return [[C4Image alloc] initWithImage:image];
}

-(id)initWithImage:(C4Image *)image {
    self = [super init];
    if(nil != self) {
        _uiImage = image.UIImage;
        _ciImage = image.CIImage;
        assert(_uiImage != nil);
        assert(_uiImage.CGImage != nil);
        _ciImage = [[CIImage alloc] initWithCGImage:_uiImage.CGImage];
        assert(_ciImage != nil);
        self.frame = _ciImage.extent;
        self.imageLayer.contents = (id)[self CGImage];
    }
    return self;
}

-(id)initWithImageName:(NSString *)name {
    self = [super init];
    if(self != nil) {
        _uiImage = [UIImage imageNamed:name];
        assert(_uiImage != nil);
        assert(_uiImage.CGImage != nil);
        _ciImage = [[CIImage alloc] initWithCGImage:_uiImage.CGImage];
        assert(_ciImage != nil);

        self.frame = self.CIImage.extent;
        [self.imageLayer setContents:(id)[self CGImage]];
    }
    return self;
}

-(UIImage *)UIImage {
    return _uiImage;
}

-(CIImage *)CIImage {
    return _ciImage;
}

-(CGImageRef)CGImage {
    return _uiImage.CGImage;
}

-(void)invert {
    if (filterContext == nil) filterContext = [CIContext contextWithOptions:nil];
    CIFilter *invertFilter = [CIFilter filterWithName:@"CIColorInvert"];
    [invertFilter setDefaults];
    [invertFilter setValue:_ciImage forKey:@"inputImage"];
    _ciImage = [invertFilter outputImage];
    assert(_ciImage != nil);
    CGImageRef imageRef = [filterContext createCGImage:_ciImage fromRect:_ciImage.extent];
    _uiImage = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    assert(_uiImage != nil);
    assert(_uiImage.CGImage != nil);
    [self.imageLayer animateContents:_uiImage.CGImage];
}

-(void)setImage:(C4Image *)image {
    _uiImage = image.UIImage;
    _ciImage = image.CIImage;
    self.imageLayer.contents = (id)[self CGImage];
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
    
}
-(void)_setContents:(CGImageRef)image {
}
@end
