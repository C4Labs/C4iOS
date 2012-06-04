//
//  C4Camera.m
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Camera.h"

@interface C4Camera ()
-(void)_setShadowOffset:(NSValue *)shadowOffset;
-(void)_setShadowRadius:(NSNumber *)shadowRadius;
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity;
-(void)_setShadowColor:(UIColor *)shadowColor;
-(void)_setShadowPath:(id)shadowPath;
-(void)imageWasCaptured;
//-(void)_setCapturedImage:(C4Image *)capturedImage;

@property (readwrite, strong) C4CameraController *cameraController;
@property (readwrite, strong, nonatomic) C4CaptureVideoPreviewLayer *previewLayer;
@end

@implementation C4Camera
@synthesize cameraController;
@synthesize capturedImage = _capturedImage;
@synthesize previewLayer = _previewLayer;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowRadius = _shadowRadius;
@synthesize shadowOpacity = _shadowOpacity;
@synthesize shadowPath = _shadowPath;

+(C4Camera *)cameraWithFrame:(CGRect)frame {
    C4Camera *c = [[C4Camera alloc] initWithFrame:frame];
    return c;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.previewLayer.backgroundColor = [UIColor redColor].CGColor;
        self.cameraController = [[C4CameraController alloc] init];
        self.cameraController.view = (C4View *)self;
        self.cameraController.previewLayer = self.previewLayer;
        self.frame = self.previewLayer.frame;
        [self listenFor:@"imageWasCaptured" fromObject:self.cameraController andRunMethod:@"imageWasCaptured"];
    }
    return self;
}

-(void)initCapture {
    [self.cameraController initCapture];
}

+ (Class)layerClass {
	return [C4CaptureVideoPreviewLayer class];
}

- (C4CaptureVideoPreviewLayer *)previewLayer {
	return (C4CaptureVideoPreviewLayer *)self.layer;
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    [self performSelector:@selector(_setShadowOffset:) withObject:[NSValue valueWithCGSize:shadowOffset] afterDelay:self.animationDelay];
}
-(void)_setShadowOffset:(NSValue *)shadowOffset {
    [self.cameraController.previewLayer animateShadowOffset:[shadowOffset CGSizeValue]];
}

-(void)setShadowRadius:(CGFloat)shadowRadius {
    [self performSelector:@selector(_setShadowRadius:) withObject:[NSNumber numberWithFloat:shadowRadius] afterDelay:self.animationDelay];
}
-(void)_setShadowRadius:(NSNumber *)shadowRadius {
    [self.previewLayer animateShadowRadius:[shadowRadius floatValue]];
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self performSelector:@selector(_setShadowOpacity:) withObject:[NSNumber numberWithFloat:shadowOpacity] afterDelay:self.animationDelay];
}

-(void)_setShadowOpacity:(NSNumber *)shadowOpacity {
    [self.cameraController.previewLayer animateShadowOpacity:[shadowOpacity floatValue]];
}

-(void)setShadowColor:(UIColor *)shadowColor {
    [self performSelector:@selector(_setShadowColor:) withObject:shadowColor afterDelay:self.animationDelay];
}
-(void)_setShadowColor:(UIColor *)shadowColor {
    [self.previewLayer animateShadowColor:shadowColor.CGColor];
}

-(void)setShadowPath:(CGPathRef)shadowPath {
    [self performSelector:@selector(_setShadowPath:) withObject:(__bridge id)shadowPath afterDelay:self.animationDelay];
}

-(void)_setShadowPath:(id)shadowPath {
    [self.previewLayer animateShadowPath:(__bridge CGPathRef)shadowPath];
}

-(void)setAnimationDuration:(CGFloat)animationDuration {
    [super setAnimationDuration:animationDuration];
    self.previewLayer.animationDuration = animationDuration;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    [super setAnimationOptions:animationOptions];
    self.previewLayer.animationOptions = animationOptions;
}

-(void)captureImage {
    [self.cameraController captureImage];
}

-(void)imageWasCaptured {
    [self postNotification:@"imageWasCaptured"];
}

-(C4Image *)capturedImage {
    return self.cameraController.capturedImage;
}

@end
