//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"
#import "C4View.h"
#import "C4Shape.h"
#import "C4ShapeLayer.h"

C4Shape *line, *triangle, *poly;

@implementation C4CanvasController

/*
 ANIMATIONS ARE ALL SET UP, TIME TO MAKE SURE THEY WORK...
*/

-(void)setup {
    poly = [C4Shape ellipse:CGRectMake(0, 0, 500, 500)];
    [self.view addSubview:poly];
    poly.animationDuration = 2.0f;
    poly.animationOptions = AUTOREVERSE | REPEAT;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!poly.isAnimating) {
        poly.center = CGPointMake(368, 512);
        poly.strokeEnd = 0.250f;
    }
}

@end
