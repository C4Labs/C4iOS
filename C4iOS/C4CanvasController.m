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

-(void)setup {
    CGPoint polypoints[4] = {CGPointMake(0, 100),CGPointMake(100, 0),CGPointMake(200, 150),CGPointMake(250, 100)};
    poly = [C4Shape polygon:polypoints pointCount:4];
    [self.view addSubview:poly];
    poly.animationDuration = 2.0f;
    poly.animationOptions = EASEIN | UIViewAnimationOptionAllowUserInteraction;

    NSUInteger mask = UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction;
    if((mask & UIViewAnimationOptionAllowUserInteraction) == UIViewAnimationOptionAllowUserInteraction) NSLog(@"INTERACTION");
    if((mask & UIViewAnimationOptionShowHideTransitionViews) == UIViewAnimationOptionShowHideTransitionViews) NSLog(@"TRANSITIONVIEWS");
    if((mask & UIViewAnimationOptionCurveEaseIn) == UIViewAnimationOptionCurveEaseIn) NSLog(@"EASEIN");
    if((mask & UIViewAnimationOptionCurveLinear) == UIViewAnimationOptionCurveLinear) NSLog(@"LINEAR");
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    poly.animationDelay = 2.0f;
    poly.fillColor = [UIColor redColor];
}

@end
