//
//  C4WorkSpace.m
//  Cameras In-Depth Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Camera *cam;
    NSMutableArray *image;
    C4Image *m;
    
}

-(void)setup {
    cam = [C4Camera cameraWithFrame:CGRectMake(0, 0, 200, 267)];
    cam.cameraPosition = CAMERAFRONT;
    cam.borderColor = C4GREY;
    cam.borderWidth = 1.0f;
    cam.shadowOpacity = 0.8f;
    cam.shadowOffset = CGSizeMake(5,5);
    
    [cam initCapture];

    [self listenFor:@"imageWasCaptured" fromObject:cam andRunMethod:@"putCapturedImageOnCanvas"];

    [self.canvas addCamera:cam];
    cam.center = CGPointMake(50+cam.width / 2, self.canvas.center.y);
    
    [self addGesture:TAP name:@"capture" action:@"captureImage"];
    [self numberOfTouchesRequired:1 forGesture:@"capture"];

    [self addGesture:TAP name:@"frontBack" action:@"switchFrontBack"];
    [self numberOfTouchesRequired:2 forGesture:@"frontBack"];
    
    image = [@[] mutableCopy];
}

-(void)captureImage {
    [cam captureImage];
}

-(void)switchFrontBack {
    cam.animationDuration = 1.0f;
    cam.perspectiveDistance = 500.0f;
    cam.rotationY += TWO_PI;

    if(cam.cameraPosition == CAMERAFRONT || cam.cameraPosition == CAMERAUNSPECIFIED) {
        cam.cameraPosition = CAMERABACK;
    } else {
        cam.cameraPosition = CAMERAFRONT;
    }
}

-(void)putCapturedImageOnCanvas {
    C4Image *img = cam.capturedImage;
    img.width = 400.0f;
    img.center = CGPointMake(self.canvas.width - 50 - img.width / 2,self.canvas.center.y);
    img.userInteractionEnabled = NO;
    [self.canvas addImage:img];
    [image addObject:img];
    if([image count] > 1) [self fadeOut:(C4Image *)image[0]];
}

-(void)fadeOut:(C4Image *)img {
    img.animationDuration = 0.25f;
    img.alpha = 0.0f;
    img.width = 100.0f;
    img.center = CGPointMake(self.canvas.width + img.width, self.canvas.height / 2.0f);
    [self runMethod:@"dumpImage:" withObject:img afterDelay:0.25f];
}

-(void)dumpImage:(C4Image *)img {
    [image removeObject:img];
}

@end