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
@synthesize longPressMethodName;
@synthesize gestureDictionary = _gestureDictionary;
@synthesize origin;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self != nil) {
        _canvas = (C4Window *)self.view;
    }
    return self;
}

-(void)dealloc {
    self.longPressMethodName = nil;
    NSEnumerator *enumerator = [self.gestureDictionary keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        UIGestureRecognizer *g = [self.gestureDictionary objectForKey:key];
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

#pragma mark Gesture Methods

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {
    if(self.gestureDictionary == nil) self.gestureDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    BOOL containsGesture = ([self.gestureDictionary objectForKey:gestureName] != nil);
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
                break;
        }
        [self.canvas addGestureRecognizer:recognizer];
        [self.gestureDictionary setObject:recognizer forKey:gestureName];
    }
}

-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        ((UITapGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
    else if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        ((UILongPressGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
    }
}

-(void)numberOfTouchesRequired:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        ((UITapGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
    else if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]])
        ((UISwipeGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
    else if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        ((UILongPressGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
}

-(void)setMinimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        ((UILongPressGestureRecognizer *) recognizer).minimumPressDuration = duration;
}

-(void)setMinimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
        ((UIPanGestureRecognizer *) recognizer).minimumNumberOfTouches = touchCount;
}

-(void)setMaximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
        ((UIPanGestureRecognizer *) recognizer).maximumNumberOfTouches = touchCount;
}

-(void)setSwipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];
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
    //does nothing
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

@end