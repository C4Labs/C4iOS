//
//  C4Camera.m
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Camera.h"
#import "C4CameraController.h"

@interface C4Camera ()
-(void)imageWasCaptured;

@property (readwrite, strong, nonatomic) C4CameraController *cameraController;
@property (readwrite, strong, nonatomic) C4CaptureVideoPreviewLayer *previewLayer;
@property (readwrite, atomic) BOOL shouldAutoreverse;
@end

@implementation C4Camera
@synthesize cameraController;
@synthesize animationOptions = _animationOptions;
@synthesize capturedImage = _capturedImage;
@synthesize previewLayer = _previewLayer;
@synthesize shouldAutoreverse = _shouldAutoreverse;

+(C4Camera *)cameraWithFrame:(CGRect)frame {
    C4Camera *c = [[C4Camera alloc] initWithFrame:frame];
    return c;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.previewLayer.backgroundColor = [UIColor redColor].CGColor;
        self.cameraController = [[C4CameraController alloc] init];
        self.cameraController.view = (C4View *)self;
        self.cameraController.previewLayer = self.previewLayer;
        self.frame = self.previewLayer.frame;
        [self listenFor:@"imageWasCaptured" fromObject:self.cameraController andRunMethod:@"imageWasCaptured"];
        [self setup];
    }
    return self;
}

-(void)dealloc {
    self.previewLayer = nil;
    self.cameraController = nil;
    self.shadowColor = nil;
    self.shadowPath = nil;
    _capturedImage = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initCapture {
    [self.cameraController initCapture];
}

+(Class)layerClass {
	return [C4CaptureVideoPreviewLayer class];
}

- (C4CaptureVideoPreviewLayer *)previewLayer {
	return (C4CaptureVideoPreviewLayer *)self.layer;
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

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    /*
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    
    //shapelayer animation options should be set first
    self.previewLayer.animationOptions = animationOptions;
    
    //strip the autoreverse from the control's animation options if needed
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    _animationOptions = animationOptions | BEGINCURRENT;
}

@end
