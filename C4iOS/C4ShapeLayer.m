//
//  C4ShapeLayer.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4ShapeLayer.h"
@interface C4ShapeLayer () 
-(CGFloat)switchAnimationDuration;
@end

@implementation C4ShapeLayer
@synthesize animationTiming = _animationTiming, animationDuration;
-(id)init {
    self = [super init];
    if(self != nil) {
        self.animationTiming = IMMEDIATE;
        self.animationDuration = 1.0f;
    }
    return self;
}

/* encapsulating an animation that will correspond to the superview's animation */
-(void)setPath:(CGPathRef)newPath {
    if (self.animationTiming != IMMEDIATE) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = [self switchAnimationDuration];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:
                                    kCAMediaTimingFunctionEaseInEaseOut];
        animation.fromValue = (id)self.path;
        animation.toValue = (__bridge id)newPath;    

        [self addAnimation:animation forKey:kCATransition];
    }
    [super setPath:newPath];
}

-(CGFloat)switchAnimationDuration {
    CGFloat _duration;
    switch (self.animationTiming) {
        case IMMEDIATE:
            _duration = 0.0f;
            break;
        case DEFAULT:
            _duration = 0.25f;
            break;
        case CUSTOM:
            _duration = self.animationDuration;
            break;
    }
    return _duration;
}
@end
