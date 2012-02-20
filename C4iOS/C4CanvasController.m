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
 ANIMATIONS ARE ALL SET UP, TIME TO WRITE THEM INTO EACH FUNCTION AND MAKE SURE THEY WORK...
 
 NEED TO FIND A BETTER SOLUTION FOR LINEDASHPATTERN
 */

-(void)setup {
    CGPoint polypoints[4] = {CGPointMake(0, 100),CGPointMake(100, 0),CGPointMake(200, 150),CGPointMake(250, 100)};
    poly = [C4Shape polygon:polypoints pointCount:4];
    [self.view addSubview:poly];
    poly.lineWidth = 5.0f;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!poly.isAnimating) {
        poly.animationDuration = 2.0f;
        poly.animationOptions = AUTOREVERSE;
        poly.strokeEnd = 0.25f;
        poly.fillColor = [UIColor greenColor];
        [poly rect:CGRectMake(400, 400, 100, 100)];
    }
}

@end
