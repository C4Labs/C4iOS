//
//  C4WorkSpace.m
//  Complex Shapes Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Camera *cam;
}

-(void)setup {
    cam = [C4Camera cameraWithFrame:CGRectMake(0, 0, 200, 200)];
    cam.position = C4CameraBack;
    [cam initCapture];
    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"imageWasCaptured"];
    [self.canvas addCamera:cam];
}

-(void)touchesBegan {
    if (cam.position == C4CameraBack) {
        cam.position = C4CameraFront;
    } else {
        cam.position = C4CameraBack;
    }
    [cam initCapture];
}

-(void)imageWasCaptured {
    C4Image *img = cam.capturedImage;
    img.center = self.canvas.center;
    img.userInteractionEnabled = NO;
    [self.canvas addImage:img];
}

@end