//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"

@implementation C4CanvasController
@synthesize canvas = _canvas;
@synthesize origin;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil) {
        _canvas = (C4Window *)self.view;
    }
    return self;
}

-(void)setup {

}

-(C4Window *)canvas {
    return (C4Window *)self.view;
}

-(void)addShape:(C4Shape *)shape {
    NSAssert([shape isKindOfClass:[C4Shape class]], 
             @"You tried to add a %@ using [self.canvas addShape:]", [shape class]);
    [self.view addSubview:shape];
}

-(void)addLabel:(C4Label *)label {
    NSAssert([label isKindOfClass:[C4Label class]], 
             @"You tried to add a %@ using [self.canvas addLabel:]", [label class]);
    [self.view addSubview:label];
}

-(void)addGL:(C4GL *)gl {
    NSAssert([gl isKindOfClass:[C4GL class]], 
             @"You tried to add a %@ using [self.canvas addGL:]", [gl class]);
    [self.view addSubview:gl];
}

-(void)addImage:(C4Image *)image {
    NSAssert([image isKindOfClass:[C4Image class]],
             @"You tried to add a %@ using [self.canvas addImage:]", [image class]);
    [self.view addSubview:image];
}

-(void)addMovie:(C4Movie *)movie {
    NSAssert([movie isKindOfClass:[C4Movie class]],
             @"You tried to add a %@ using [self.canvas addMovie:]", [movie class]);
    [self.view addSubview:movie];
}

#pragma mark Notification Methods
-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:nil];
}

-(void)listenFor:(NSString *)notification fromObject:(id)object andRunMethod:(NSString *)methodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
}

-(void)stopListeningFor:(NSString *)methodName {
    [self stopListeningFor:methodName object:nil];
}

-(void)stopListeningFor:(NSString *)methodName object:(id)object {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
}

-(void)postNotification:(NSString *)notification {
	[[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

#pragma mark New Stuff
-(void)addCamera:(C4Camera *)camera {
    NSAssert([camera isKindOfClass:[C4Camera class]],
             @"You tried to add a %@ using [canvas addCamera:]", [camera class]);
    [self.canvas addSubview:camera];
    [camera initCapture];
    [self listenFor:@"imageWasCaptured" fromObject:camera andRunMethod:@"imageWasCaptured"];
}

-(void)imageWasCaptured {
    
}

@end