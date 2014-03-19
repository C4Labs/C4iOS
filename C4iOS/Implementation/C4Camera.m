// Copyright © 2012 Travis Kirton
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

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
        self.cameraController = [[C4CameraController alloc] init];
        self.cameraController.view = (C4View *)self;
        self.previewLayer = [C4CameraLayer layerWithSession:self.cameraController.captureSession];
        self.cameraController.previewLayer = self.previewLayer;
        self.previewLayer.frame = self.layer.bounds;
        
        [self.layer addSublayer:self.previewLayer];
        self.cameraPosition = CAMERAFRONT;
        
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
    [self.cameraController initCapture];
}

+(Class)layerClass {
    return [C4Layer class];
}

//- (C4CameraLayer *)previewLayer {
//    return (C4CameraLayer *)self.layer;
//}

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

-(void)setCameraPosition:(C4CameraPosition)position {
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
