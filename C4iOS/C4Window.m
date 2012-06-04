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

- (id)init
{
    self = [super init];
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
}

-(void)awakeFromNib {
#ifdef VERBOSE
    C4Log(@"%@ awakeFromNib",[self class]);
#endif
}

-(void)addShape:(C4Shape *)shape {
    NSAssert([shape isKindOfClass:[C4Shape class]],
             @"You tried to add a %@ using [canvas addShape:]", [shape class]);
    [self addSubview:shape];
}

-(void)addLabel:(C4Label *)label {
    NSAssert([label isKindOfClass:[C4Label class]], 
             @"You tried to add a %@ using [canvas addLabel:]", [label class]);
    [self addSubview:label];
}

-(void)addGL:(C4GL *)gl {
    NSAssert([gl isKindOfClass:[C4GL class]], 
             @"You tried to add a %@ using [canvas addGL:]", [gl class]);
    [self addSubview:gl];
}

-(void)addImage:(C4Image *)image {
    NSAssert([image isKindOfClass:[C4Image class]],
             @"You tried to add a %@ using [canvas addImage:]", [image class]);
    [self addSubview:image];
}

-(void)addMovie:(C4Movie *)movie {
    NSAssert([movie isKindOfClass:[C4Movie class]],
             @"You tried to add a %@ using [canvas addMovie:]", [movie class]);
    [self addSubview:movie];
}


-(void)addCamera:(C4Camera *)camera {
    NSAssert([camera isKindOfClass:[C4Camera class]],
             @"You tried to add a %@ using [canvas addCamera:]", [camera class]);
    [self addSubview:camera];
    [camera initCapture];
    [self.canvasController listenFor:@"imageWasCaptured" fromObject:camera andRunMethod:@"imageWasCaptured"];
}

/*
 The following method makes sure that the main backing CALayer
 for this UIWindow subclass will be a C4Canvas
 */

@end
