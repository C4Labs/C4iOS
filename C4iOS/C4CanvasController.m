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
    
    CGPoint linepoints[2] = {CGPointMake(500, 500),CGPointMake(600, 600)};
    line = [C4Shape line:linepoints];
    [self.view addSubview:line];
    
    CGPoint trianglepoints[3] = {CGPointMake(200, 500),CGPointMake(200, 600),CGPointMake(300, 550)};
    triangle = [C4Shape triangle:trianglepoints];
    [self.view addSubview:triangle];
    
    triangle.shapeLayer.fillColor = [C4Color greenColor];
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [poly rect:CGRectMake(300, 100, 50, 50)];
}

@end
