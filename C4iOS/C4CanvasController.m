//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"
#import <objc/message.h>

@interface C4CanvasController ()
@property (readwrite, atomic, strong) NSString *longPressMethodName;
@property (readwrite, atomic, strong) NSMutableDictionary *gestureDictionary;
@end

@implementation C4CanvasController
@synthesize canvas = _canvas;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil) {
        _canvas = (C4Window *)self.view;
        [self listenFor:@"movieIsReadyForPlayback" andRunMethod:@"movieIsReadyForPlayback:"];
    }
    return self;
}

-(void)dealloc {
    self.longPressMethodName = nil;
    NSEnumerator *enumerator = [self.gestureDictionary keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        UIGestureRecognizer *g = (self.gestureDictionary)[key];
        [g removeTarget:self action:nil];
        [self.canvas removeGestureRecognizer:g];
    }
    [self.gestureDictionary removeAllObjects];
    self.gestureDictionary = nil;
    _canvas = nil;
}

-(void)setup {

}

-(C4Window *)canvas {
    return (C4Window *)self.view;
}

-(void)addCamera:(C4Camera *)camera {
    C4Assert([camera isKindOfClass:[C4Camera class]],
             @"You tried to add a %@ using [canvas addCamera:]", [camera class]);
    [self.canvas addSubview:camera];
    [camera initCapture];
    [self listenFor:@"imageWasCaptured" fromObject:camera andRunMethod:@"imageWasCaptured"];
}

-(void)addShape:(C4Shape *)shape {
    [(C4View *)self.view addShape:shape];
}

-(void)addSubview:(UIView *)subview {
    [(C4View *)self.view addSubview:subview];
}

-(void)addLabel:(C4Label *)label {
    [(C4View *)self.view addLabel:label];
}

-(void)addGL:(C4GL *)gl {
    [(C4View *)self.view addGL:gl];
}

-(void)addImage:(C4Image *)image {
    [(C4View *)self.view addImage:image];
}

-(void)addMovie:(C4Movie *)movie {
    [(C4View *)self.view addMovie:movie];
}

#pragma mark Notification Methods
-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:nil];
}

-(void)listenFor:(NSString *)notification fromObject:(id)object andRunMethod:(NSString *)methodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
}

-(void)listenFor:(NSString *)notification fromObjects:(NSArray *)objectArray andRunMethod:(NSString *)methodName {
    for (id object in objectArray) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
    }
}

-(void)stopListeningFor:(NSString *)methodName {
    [self stopListeningFor:methodName object:nil];
}

-(void)stopListeningFor:(NSString *)methodName object:(id)object {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
}

-(void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {
    for(id object in objectArray) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
    }
}

-(void)postNotification:(NSString *)notification {
	[[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

#pragma mark New Stuff

-(void)imageWasCaptured {
    
}

#pragma mark Gesture Methods

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {
    if(self.gestureDictionary == nil) self.gestureDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    BOOL containsGesture = ((self.gestureDictionary)[gestureName] != nil);
    if(containsGesture == NO) {
        UIGestureRecognizer *recognizer;
        switch (type) {
            case TAP:
                recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                break;
            case PAN:
                recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                break;
            case SWIPERIGHT:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRRIGHT;
                break;
            case SWIPELEFT:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRLEFT;
                break;
            case SWIPEUP:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRUP;
                break;
            case SWIPEDOWN:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRDOWN;
                break;
            case LONGPRESS:
                self.longPressMethodName = methodName;
                recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
            default:
                C4Assert(NO,@"The gesture you tried to use is not one of: TAP, PINCH, SWIPERIGHT, SWIPELEFT, SWIPEUP, SWIPEDOWN, ROTATION, PAN, or LONGPRESS");
                break;
        }
        [self.canvas addGestureRecognizer:recognizer];
        (self.gestureDictionary)[gestureName] = recognizer;
    }
}

-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        ((UITapGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
    else if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        ((UILongPressGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
    }
}

-(void)numberOfTouchesRequired:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        ((UITapGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
    }
    else if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]]) {
        ((UISwipeGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
    }
    else if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        ((UILongPressGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
    }
}

-(void)minimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        ((UILongPressGestureRecognizer *) recognizer).minimumPressDuration = duration;
}

-(void)minimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        ((UIPanGestureRecognizer *) recognizer).minimumNumberOfTouches = touchCount;
    }
}

-(void)maximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
        ((UIPanGestureRecognizer *) recognizer).maximumNumberOfTouches = touchCount;
}

-(void)swipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]])
        ((UISwipeGestureRecognizer *) recognizer).direction = direction;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self postNotification:@"touchesBegan"];
    [self touchesBegan];
}

-(void)touchesBegan {
}

-(void)touchesEnded {
}

-(void)touchesMoved {
    
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self postNotification:@"touchesMoved"];
    [super touchesMoved:touches withEvent:event];
    [self touchesMoved];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self postNotification:@"touchesEnded"];
    [super touchesEnded:touches withEvent:event];
    [self touchesEnded];
}


-(void)swipedRight {
}

-(void)swipedLeft {
}

-(void)swipedUp {
}

-(void)swipedDown {
}

-(void)pressedLong {
}

-(void)pressedLong:(id)sender {
    if(((UIGestureRecognizer *)sender).state == UIGestureRecognizerStateBegan
       && [((UIGestureRecognizer *)sender) isKindOfClass:[UILongPressGestureRecognizer class]]) {
        objc_msgSend(self, NSSelectorFromString(self.longPressMethodName)); // have to do this manually here... because the WorkSpace doesn't respond to performSelector: or sendAction:
    }
}

-(void)move:(id)sender {
    sender = sender;
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

-(void)movieIsReadyForPlayback:(NSNotification *)notification {
    C4Movie *currentMovie = (C4Movie *)[notification object];
    [self movieIsReady:currentMovie];
    [self stopListeningFor:@"movieIsReadyForPlayback" object:currentMovie];
}

-(void)movieIsReady:(C4Movie *)movie {
    movie = movie;
}

@end