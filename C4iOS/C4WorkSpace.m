//
//  C4WorkSpace.m
//  Complex Shapes Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Camera *cam;
    NSArray *qualities;
    NSInteger currentQuality;
}

-(void)setup {
    qualities = @[
    C4CameraQuality1280x720,
    C4CameraQuality1920x1080,
    C4CameraQuality352x288,
    C4CameraQuality640x480,
    C4CameraQualityiFrame960x540,
    C4CameraQualityiFrame1280x720,
    C4CameraQualityHigh,
    C4CameraQualityLow,
    C4CameraQualityMedium,
    C4CameraQualityPhoto
    ];
    
    cam = [C4Camera cameraWithFrame:CGRectMake(0, 0, 200, 200)];
    cam.cameraPosition = C4CameraFront;
    [cam initCapture];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"imageWasCaptured"];
    [self.canvas addCamera:cam];
    
    [self addGesture:TAP name:@"quality" action:@"switchQuality"];
    [self numberOfTouchesRequired:1 forGesture:@"quality"];
    
    [self addGesture:TAP name:@"capture" action:@"captureImage"];
    [self numberOfTouchesRequired:2 forGesture:@"capture"];
}

-(void)captureImage {
    [cam captureImage];
}

-(void)switchQuality {
    cam.captureQuality = qualities[currentQuality];
    currentQuality++;
    if(currentQuality == [qualities count])currentQuality = 0;
    C4Log(cam.captureQuality);
}

-(void)switchFrontBack {
    if(cam.cameraPosition == C4CameraFront) cam.cameraPosition = C4CameraBack;
    else cam.cameraPosition = C4CameraFront;
}

-(void)imageWasCaptured {
    C4Image *img = cam.capturedImage;
    img.center = self.canvas.center;
    img.userInteractionEnabled = NO;
    [self.canvas addImage:img];
}

@end