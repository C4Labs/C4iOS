//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"

C4Image *image, *inverted, *descartes;
C4GL *gl;

@implementation C4CanvasController
@synthesize canvas;


-(void)setup {
    canvas = (C4Window *)self.view;

    image = [C4Image imageNamed:@"candahar256.png"];
    [canvas addImage:image];

    gl = [[C4GL alloc] init];
    [canvas addGL:gl];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    image.animationDuration = 2.0f;
    image.shadowOpacity = 0.8f;
    image.shadowOffset = CGSizeMake(15.0, 15.0);
    image.animationOptions = AUTOREVERSE | REPEAT;
    image.center = CGPointMake(384, 512);
    image.transform = CGAffineTransformMakeRotation(PI);
    [image colorInvert];

    gl.animationDuration = 1.0f;
    gl.frame = CGRectMake(0, 812, 300, 200);
}
@end