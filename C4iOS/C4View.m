//
//  C4View.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4View.h"
@interface C4View() 
-(void)animateWithBlock:(void (^)(void))blockAnimation;
@end

@implementation C4View

/* leaving animation delay only to views for now */
@synthesize animationDuration, animationDelay, animationOptions = _animationEasing;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.animationDuration = 0.25f;
        self.animationDelay = 0.0f;
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

-(void)setCenter:(CGPoint)center {
    [self animateWithBlock:^{
        [super setCenter:center];
    }];
}

-(void)setFrame:(CGRect)frame {
    [self animateWithBlock:^{
        [super setFrame:frame];
    }];
}

-(void)setBounds:(CGRect)bounds {
    [self animateWithBlock:^{
        [super setBounds:bounds];
    }];
}

-(void)setTransform:(CGAffineTransform)transform {
    [self animateWithBlock:^{
        [super setTransform:transform];
    }];
}

-(void)setAlpha:(CGFloat)alpha {
    [self animateWithBlock:^{
        [super setAlpha:alpha];
    }];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [self animateWithBlock:^{
        [super setBackgroundColor:backgroundColor];
    }];
}

-(void)setContentStretch:(CGRect)contentStretch {
    [self animateWithBlock:^{
        [super setContentStretch:contentStretch];
    }];
}

-(void)animateWithBlock:(void (^)(void))blockAnimation {
    [UIView animateWithDuration:self.animationDuration
                          delay:(NSTimeInterval)self.animationDelay
                        options:self.animationOptions 
                     animations:blockAnimation
                     completion:nil];
};

@end
