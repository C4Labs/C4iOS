//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"

C4Movie *inception;

@implementation C4CanvasController
@synthesize canvas;


-(void)setup {
    canvas = (C4Window *)self.view;
    inception = [C4Movie movieNamed:@"inception.m4v"];
    inception.width = 512;
    inception.alpha = 0.0f;
    inception.center = CGPointMake(384, inception.height/2);
    [canvas addMovie:inception];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    inception.animationDuration = 2.0f;
    inception.animationOptions = AUTOREVERSE | REPEAT;
    inception.width = 768;
    inception.alpha = 1.0f;
    inception.center = CGPointMake(384, 512);
}

@end