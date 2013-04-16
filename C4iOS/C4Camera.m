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
@property (readwrite, strong, nonatomic) C4CameraController *cameraController;
@property (readwrite, strong, nonatomic) C4CameraLayer *previewLayer;
@property (readonly, nonatomic) BOOL initialized;
//@property (readwrite, atomic) BOOL shouldAutoreverse;
@end

@implementation C4Camera
//@synthesize animationOptions = _animationOptions;
@synthesize capturedImage = _capturedImage;
@synthesize previewLayer = _previewLayer;
//@synthesize shouldAutoreverse = _shouldAutoreverse;

+(C4Camera *)cameraWithFrame:(CGRect)frame {
    C4Camera *c = [[C4Camera alloc] initWithFrame:frame];
    return c;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.previewLayer.backgroundColor = [UIColor redColor].CGColor;
        self.position = C4CameraFront;
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
    _previewLayer = nil;
    _cameraController = nil;
    _capturedImage = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)initCapture {
    [self.cameraController initCapture:self.cameraPosition];
}

+(Class)layerClass {
	return [C4CameraLayer class];
}

- (C4CameraLayer *)previewLayer {
	return (C4CameraLayer *)self.layer;
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

+(C4Camera *)defaultStyle {
    return (C4Camera *)[C4Camera appearance];
}

-(void)setPosition:(C4CameraPosition)position {
    [self.cameraController switchCameraPosition:position];
}

-(C4CameraPosition)cameraPosition {
    return self.cameraController.cameraPosition;
}

-(void)setCaptureQuality:(NSString *)captureQuality {
    self.cameraController.captureQuality = captureQuality;
}

-(NSString *)captureQuality {
    return self.cameraController.captureQuality;
}

@end
