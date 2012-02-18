//
//  C4View.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4View.h"

@interface C4View()
-(CGFloat)switchAnimationDuration;
@end

@implementation C4View
@synthesize animationDuration = _animationDuration, animationTiming = _animationTiming;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        
        CGFloat colorComponents[4] = {0,0,0,0.5};
        self.animationTiming = IMMEDIATE;
        self.animationDuration = 0.0f;
        self.layer.backgroundColor = CGColorCreate(CGColorSpaceCreateDeviceRGB(), colorComponents);
    }
    return self;
}

/* don't add this ever...
 creates a:
 CoreAnimation: failed to allocate 3145760 bytes
 wait_fences: failed to receive reply: 10004003
 -(void)drawRect:(CGRect)rect {
 [self.layer display];
 }
 */

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

-(void)setCenter:(CGPoint)center {
    [UIView animateWithDuration:[self switchAnimationDuration] animations:^{
        [super setCenter:center];
    }];
}

-(void)setFrame:(CGRect)frame {
    [UIView animateWithDuration:[self switchAnimationDuration] animations:^{
        [super setFrame:frame];
    }];
}

-(void)setBounds:(CGRect)bounds {
    [UIView animateWithDuration:[self switchAnimationDuration] animations:^{
        [super setBounds:bounds];
    }];
}

-(void)setTransform:(CGAffineTransform)transform {
    [UIView animateWithDuration:[self switchAnimationDuration] animations:^{
        [super setTransform:transform];
    }];
}

-(void)setAlpha:(CGFloat)alpha {
    [UIView animateWithDuration:[self switchAnimationDuration] animations:^{
        [super setAlpha:alpha];
    }];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [UIView animateWithDuration:[self switchAnimationDuration] animations:^{
        [super setBackgroundColor:backgroundColor];
    }];
}

-(void)setContentStretch:(CGRect)contentStretch {
    [UIView animateWithDuration:[self switchAnimationDuration] animations:^{
        [super setContentStretch:contentStretch];
    }];
}

-(void)setAnimationTiming:(C4ViewAnimationTiming)animationTiming {
    _animationTiming = animationTiming;
}

@end
