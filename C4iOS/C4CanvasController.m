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

#import "CustomShape.h"

C4Shape *blueCircle, *blueSquare, *redCircle, *redSquare;
CustomShape *transformer;

@implementation C4CanvasController

-(void)setup {
    
    blueCircle = [C4Shape ellipse:CGRectMake(73, 562, 100, 100)];
    [self.view addSubview:blueCircle];

    blueSquare = [C4Shape rect:CGRectMake(246, 562, 100, 100)];
    [self.view addSubview:blueSquare];
    
    redCircle = [C4Shape ellipse:CGRectMake(419, 562, 100, 100)];
    redCircle.fillColor = C4RED;
    redCircle.strokeColor = C4BLUE;
    [self.view addSubview:redCircle];
    
    redSquare = [C4Shape rect:CGRectMake(592, 562, 100, 100)];
    redSquare.fillColor = C4RED;
    redSquare.strokeColor = C4BLUE;
    [self.view addSubview:redSquare];
    
    CustomShape *transformer = [[CustomShape alloc] init];
    [transformer ellipse:CGRectMake(284, 262, 200, 200)];
    [self.view addSubview:transformer];
    
    [transformer listenFor:@"touchesBegan" fromObject:blueCircle andRunMethod:@"blueCircle"];
    [transformer listenFor:@"touchesBegan" fromObject:blueSquare andRunMethod:@"blueSquare"];
    [transformer listenFor:@"touchesBegan" fromObject:redCircle andRunMethod:@"redCircle"];
    [transformer listenFor:@"touchesBegan" fromObject:redSquare andRunMethod:@"redSquare"];
}

@end