//
//  MyShape.m
//  C4iOS
//
//  Created by Travis Kirton on 12-05-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "MyShape.h"

@implementation MyShape
@synthesize playhead;

-(id)init {
    self = [super init];
    if(self != nil) {
        CGRect newFrame = CGRectMake(100, 100, 568, 100);

        self.animationDuration = 0.0f;
        self.lineWidth = 0.0f;
        [self rect:newFrame];

        CGPoint pointArray[2] = {CGPointZero,CGPointMake(0, newFrame.size.height)};
        playhead = [C4Shape line:pointArray];

        playhead.animationDuration = 0.0f;
        playhead.strokeColor = C4GREY;
        [self addSubview:playhead];
    }
    return self;
}

@end
