//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"
#import "CustomShape.h"

@implementation C4CanvasController
@synthesize canvas;

CustomShape *rect;

-(void)setup { 
    canvas = (C4Window *)self.view;
    rect = [[CustomShape alloc] init];
    [rect rect:CGRectMake(200, 200, 200, 200)];
    [rect addGesture:TAP name:@"tapGesture" action:@"orangeRect"];
    [rect addGesture:SWIPERIGHT name:@"swipeGestureRight" action:@"swipedRight"];
    [rect addGesture:SWIPELEFT name:@"swipeGestureLeft" action:@"swipedLeft"];
    [rect addGesture:SWIPEUP name:@"swipeGestureUp" action:@"swipedUp"];
    [rect addGesture:SWIPEDOWN name:@"swipeGestureDown" action:@"swipedDown"];
    [rect addGesture:LONGPRESS name:@"longPress" action:@"greenCircle"];
    [canvas addShape:rect];
}

//-(void)setup {
//    canvas = (C4Window *)self.view;
//
//    rect = [[CustomShape alloc] init];
//    [rect rect:CGRectMake(0, 0, 100, 100)];
//    [rect addGesture:PAN name:@"panGesture" action:@"move:"];
//    [rect addGesture:TAP name:@"tapGesture" action:@"circle"];
//    [canvas addShape:rect];
//}

@end

//@interface C4CanvasController ()
//-(void)changeCenters;
//@end
//@implementation C4CanvasController
//@synthesize canvas;
//
//C4Shape *greyrect;
//NSMutableArray *shapes;
//
//
//-(void)setup {
//    greyrect = [[CustomShape alloc] init];
//    [greyrect rect:CGRectMake(334, -100, 100, 100)];
//    greyrect.fillColor = C4GREY;
//    greyrect.strokeColor = C4GREY;
//
//    shapes = [[NSMutableArray alloc] initWithCapacity:0];
//    canvas = (C4Window *)self.view;
//    
//    for(int i = 0; i < 7; i++) {
//        C4Shape *rect = [[CustomShape alloc] init];
//        [rect rect:CGRectMake(334, -100, 100, 100)];
//        rect.fillColor = C4RED;
//        rect.strokeColor = C4RED;
//        [shapes addObject:rect];
//        [canvas addShape:rect];
//    }
//
//    [canvas addShape:greyrect];
//    [shapes addObject:greyrect];
//
//    for(int i = 0; i < 8; i++) {
//        C4Shape *rect = [[CustomShape alloc] init];
//        [rect rect:CGRectMake(334, -100, 100, 100)];
//        rect.fillColor = C4BLUE;
//        rect.strokeColor = C4BLUE;
//        [shapes addObject:rect];
//        [canvas addShape:rect];
//    }
//    [self performSelector:@selector(changeCenters) withObject:self afterDelay:0.25f];
//
//    for(C4Shape *s in shapes) [s listenFor:@"touchesBegan" fromObject:greyrect andRunMethod:@"circle"];
//}
//
//-(C4Window *)canvas {
//    return (C4Window *)self.view;
//}
//
//-(void)changeCenters {
//    for(C4Shape *s in shapes) s.animationDuration = 1.0f;
//    ((C4Shape *)[shapes objectAtIndex:0]).center = CGPointMake(350, 584);
//    ((C4Shape *)[shapes objectAtIndex:1]).center = CGPointMake(250, 584);
//    ((C4Shape *)[shapes objectAtIndex:2]).center = CGPointMake(150, 584);
//    ((C4Shape *)[shapes objectAtIndex:3]).center = CGPointMake(150, 484);
//    ((C4Shape *)[shapes objectAtIndex:4]).center = CGPointMake(150, 384);
//    ((C4Shape *)[shapes objectAtIndex:5]).center = CGPointMake(150, 284);
//    ((C4Shape *)[shapes objectAtIndex:6]).center = CGPointMake(250, 284);
//    ((C4Shape *)[shapes objectAtIndex:7]).center = CGPointMake(350, 284);
//    ((C4Shape *)[shapes objectAtIndex:8]).center = CGPointMake(350, 384);
//    ((C4Shape *)[shapes objectAtIndex:9]).center = CGPointMake(350, 484);
//    ((C4Shape *)[shapes objectAtIndex:10]).center = CGPointMake(450, 484);
//    ((C4Shape *)[shapes objectAtIndex:11]).center = CGPointMake(550, 484);
//    ((C4Shape *)[shapes objectAtIndex:12]).center = CGPointMake(650, 484);
//    ((C4Shape *)[shapes objectAtIndex:13]).center = CGPointMake(550, 284);
//    ((C4Shape *)[shapes objectAtIndex:14]).center = CGPointMake(550, 384);
//    ((C4Shape *)[shapes objectAtIndex:15]).center = CGPointMake(550, 584);
//}
//@end

//
//#import "CustomShape.h"
//
//C4Shape *blueCircle, *blueSquare, *redCircle, *redSquare;
//CustomShape *transformer;
//
//@implementation C4CanvasController
//@synthesize canvas;
//
//-(void)setup {
//    canvas = (C4Window *)self.view;
//    blueCircle = [C4Shape ellipse:CGRectMake(73, 562, 100, 100)];
//    [canvas addShape:blueCircle];
//    
//    blueSquare = [C4Shape rect:CGRectMake(246, 562, 100, 100)];
//    [canvas addShape:blueSquare];
//    
//    redCircle = [C4Shape ellipse:CGRectMake(419, 562, 100, 100)];
//    redCircle.fillColor = C4RED;
//    redCircle.strokeColor = C4BLUE;
//    [canvas addShape:redCircle];
//    
//    redSquare = [C4Shape rect:CGRectMake(592, 562, 100, 100)];
//    redSquare.fillColor = C4RED;
//    redSquare.strokeColor = C4BLUE;
//    [canvas addShape:redSquare];
//    
//    CustomShape *transformer = [[CustomShape alloc] init];
//    [transformer ellipse:CGRectMake(284, 262, 200, 200)];
//    [canvas addShape:transformer];
//    
//    [transformer listenFor:@"touchesBegan" fromObject:blueCircle andRunMethod:@"blueCircle"];
//    [transformer listenFor:@"touchesBegan" fromObject:blueSquare andRunMethod:@"blueSquare"];
//    [transformer listenFor:@"touchesBegan" fromObject:redCircle andRunMethod:@"redCircle"];
//    [transformer listenFor:@"touchesBegan" fromObject:redSquare andRunMethod:@"redSquare"];
//}
//
//@end
