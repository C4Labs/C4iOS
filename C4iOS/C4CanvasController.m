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

C4Shape *shape;

@implementation C4CanvasController

-(void)setup {
    shape = [C4Shape ellipse:CGRectMake(374, 502, 20,20)];
    shape.animationOptions = EASEIN;
    shape.lineWidth = 1.0f;
    shape.shadowRadius = 4.0f;
    shape.shadowOffset = CGSizeMake(1, 1);
    shape.shadowOpacity = 0.7f;
    [self.view addSubview:shape];
}
/*
 ANIMATIONS ARE ALL SET UP, TIME TO MAKE SURE THEY WORK...
*/

//-(void)setup {
//    
//    shapeA = [C4Shape rect:CGRectMake(0, 0, 160, 160)];
//    shapeB = [C4Shape rect:CGRectMake(0, 0, 160, 160)];
//    shapeC = [C4Shape rect:CGRectMake(0, 0, 160, 160)];
//    shapeD = [C4Shape rect:CGRectMake(0, 0, 160, 160)];
//
//    shapeA.center = CGPointMake(368, 205);
//    shapeB.center = CGPointMake(368, 410);
//    shapeC.center = CGPointMake(368, 615);
//    shapeD.center = CGPointMake(368, 820);
//
//    shapeA.lineWidth = 5.0f;
//    shapeB.lineWidth = 5.0f;
//    shapeC.lineWidth = 5.0f;
//    shapeD.lineWidth = 5.0f;
//    
//    [self.view addSubview:shapeA];
//    [self.view addSubview:shapeB];
//    [self.view addSubview:shapeC];
//    [self.view addSubview:shapeD];
//
//    shapeA.animationDuration = 2.0f;
//    shapeB.animationDuration = 2.0f;
//    shapeC.animationDuration = 2.0f;
//    shapeD.animationDuration = 2.0f;
//
//    shapeA.lineJoin = kCALineJoinMiter;
//    shapeB.lineJoin = kCALineJoinMiter;
//    shapeC.lineJoin = kCALineJoinMiter;
//    shapeD.lineJoin = kCALineJoinMiter;
//
//}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    shapeB.animationOptions = AUTOREVERSE;
//    shapeC.animationOptions = REPEAT;
//    shapeD.animationOptions = AUTOREVERSE | REPEAT;
//
////    shapeA.center = CGPointMake(80,shapeA.center.y);
////    shapeB.center = CGPointMake(80,shapeB.center.y);
////    shapeC.center = CGPointMake(80,shapeC.center.y);
////    shapeD.center = CGPointMake(80,shapeD.center.y);
//
////    [shapeA ellipse:shapeA.frame];
////    [shapeB ellipse:shapeB.frame];
////    [shapeC ellipse:shapeC.frame];
////    [shapeD ellipse:shapeD.frame];
//    
////    shapeA.fillColor = C4RED;
////    shapeB.fillColor = C4RED;
////    shapeC.fillColor = C4RED;
////    shapeD.fillColor = C4RED;
//
////    shapeA.lineWidth = 20.0f;
////    shapeB.lineWidth = 20.0f;
////    shapeC.lineWidth = 20.0f;
////    shapeD.lineWidth = 20.0f;
//    
////    shapeA.strokeColor = C4GREY;
////    shapeB.strokeColor = C4GREY;
////    shapeC.strokeColor = C4GREY;
////    shapeD.strokeColor = C4GREY;
//
////    shapeA.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:20],[NSNumber numberWithInt:10], nil];
////    shapeB.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:20],[NSNumber numberWithInt:10], nil];
////    shapeC.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:20],[NSNumber numberWithInt:10], nil];
////    shapeD.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:20],[NSNumber numberWithInt:10], nil];
////    shapeA.lineDashPhase = 150.0f;
////    shapeB.lineDashPhase = 150.0f;
////    shapeC.lineDashPhase = 150.0f;
////    shapeD.lineDashPhase = 150.0f;
//    
////    shapeA.miterLimit = 0.05f;
////    shapeB.miterLimit = 0.15f;
////    shapeC.miterLimit = 0.15f;
////    shapeD.miterLimit = 0.15f;
//    
////    shapeA.strokeEnd = 0.5f;
////    shapeB.strokeEnd = 0.5f;
////    shapeC.strokeEnd = 0.5f;
////    shapeD.strokeEnd = 0.5f;
//
//    shapeA.strokeStart = 0.5f;
//    shapeB.strokeStart = 0.5f;
//    shapeC.strokeStart = 0.5f;
//    shapeD.strokeStart = 0.5f;
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    shape.animationDuration = 1.0f;
//    shape.lineWidth = 5.0f;
//    shape.animationOptions = AUTOREVERSE | REPEAT;
//    [shape ellipse:CGRectMake(334, 462, 100, 100)];
//    shape.shadowOffset = CGSizeMake(300, 300);
//    shape.shadowOpacity = 0.20f;
//    shape.shadowRadius = 4.0f;
}

@end
