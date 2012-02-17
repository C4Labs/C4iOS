//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"
#import "C4View.h"
#import "C4ShapeView.h"
#import "C4ShapeLayer.h"

//C4View *c4view1, *c4view2, *c4view3;
C4ShapeView *shape;

@implementation C4CanvasController

@synthesize canvas;

-(void)setup {
//    shape = [[C4ShapeView alloc] initWithFrame:CGRectMake(100, 300, 100, 100)];
//    shape.backgroundColor = [UIColor redColor];
//    CAShapeLayer *shapeLayer = [CAShapeLayer layer];   
//    [shapeLayer setFillColor:[[UIColor redColor] CGColor]];
//    [shapeLayer setStrokeColor:[[UIColor blueColor] CGColor]];
//    [shapeLayer setLineCap:kCALineCapRound];
//    [shapeLayer setLineWidth:4.0f];
//    
//    // draw the graph line
//    CGMutablePathRef newPath = CGPathCreateMutable();
//    CGPathAddEllipseInRect(newPath, nil, CGRectMake(0, 0, 10, 10));
//
//    [shapeLayer setPath:newPath];
//    CFRelease(newPath);    
//       
//    [shape.layer addSublayer:shapeLayer];
//    [shapeLayer setNeedsDisplay];
//    
//    [self.view addSubview:shape];
//    [self.view setNeedsDisplay];
    
    shape = [[C4ShapeView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    shape.backgroundColor = [UIColor blueColor];

//    C4ShapeLayer *newLayer = [C4ShapeLayer layer];
//    CGPathRef path = CGPathCreateWithEllipseInRect(CGRectMake(0, 0, 300, 30), nil);
//    [newLayer setPath:path];
//    CGPathRelease(path);
//    [newView.layer addSublayer:newLayer];
    
    [self.view addSubview:shape];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [shape addAnotherShape];
}

@end
