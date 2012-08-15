//
//  C4Window.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4Window.h"

@implementation C4Window
@synthesize canvasController;
@synthesize width, height;

- (id)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
#ifdef VERBOSE
        C4Log(@"%@ init",[self class]);
#endif
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
#ifdef VERBOSE
        C4Log(@"%@ initWithFrame",[self class]);
        _center = CGPointMake(self.width/2.0f,self.height/2.0f); 
        //[self setup] //need to comment this out right here, because there will be a conflict with calling [canvas setup] from the main app delegate
#endif
    }
    return self;
}

-(void)dealloc {
    for(UIView *v in self.subviews) {
        [v removeFromSuperview];
    }

    NSArray *gestureRecognizerArray = self.gestureRecognizers;
    
    for(UIGestureRecognizer *g in gestureRecognizerArray) {
        [self removeGestureRecognizer:g];
    }
    gestureRecognizerArray = nil;

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)awakeFromNib {
#ifdef VERBOSE
    C4Log(@"%@ awakeFromNib",[self class]);
#endif
}

-(void)addShape:(C4Shape *)shape {
    C4Assert([shape isKindOfClass:[C4Shape class]], 
             @"You tried to add a %@ using [canvas addShape:]", [shape class]);
    [super addSubview:shape];
}

-(void)addLabel:(C4Label *)label {
    C4Assert([label isKindOfClass:[C4Label class]], 
             @"You tried to add a %@ using [canvas addLabel:]", [label class]);
    [super addSubview:label];
}

-(void)addGL:(C4GL *)gl {
    C4Assert([gl isKindOfClass:[C4GL class]], 
             @"You tried to add a %@ using [canvas addGL:]", [gl class]);
    [super addSubview:gl];
}

-(void)addImage:(C4Image *)image {
    C4Assert([image isKindOfClass:[C4Image class]],
             @"You tried to add a %@ using [canvas addImage:]", [image class]);
    [super addSubview:image];
}

-(void)addMovie:(C4Movie *)movie {
    C4Assert([movie isKindOfClass:[C4Movie class]],
             @"You tried to add a %@ using [canvas addMovie:]", [movie class]);
    [super addSubview:movie];
}

-(void)addCamera:(C4Camera *)camera {
    C4Assert([camera isKindOfClass:[C4Camera class]],
             @"You tried to add a %@ using [canvas addCamera:]", [camera class]);
    [self addSubview:camera];
    [camera initCapture];
    [self.canvasController listenFor:@"imageWasCaptured" fromObject:camera andRunMethod:@"imageWasCaptured"];
}
/*
 The following method makes sure that the main backing CALayer
 for this UIWindow subclass will be a C4Canvas
 */

-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName{
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

-(CGFloat)width {
    return self.frame.size.width;
}

-(CGFloat)height {
    return self.frame.size.height;
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

-(void)removeObject:(C4Control *)visibleObject {
    [visibleObject removeFromSuperview];
}
@end
