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

C4Shape *arc;
C4Shape *curve;

@implementation C4CanvasController

-(void)setup {
    CGPoint beginEndPoints[2] = {CGPointMake(668, 512),CGPointMake(100, 512)};
    CGPoint controlPoints[2] = {CGPointMake(100, 100),CGPointMake(668, 924)};
    curve = [C4Shape curve:beginEndPoints controlPoints:controlPoints];
    curve.backgroundColor = [UIColor colorWithWhite:0.33 alpha:0.33];
    [self.view addSubview:curve];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    curve.animationDuration = 2.0f;
    [curve ellipse:CGRectMake(384-100, 512-100, 200, 200)];
}

@end
