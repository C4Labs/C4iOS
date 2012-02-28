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
-(void)animateWithBlock:(void (^)(void))blockAnimation completion:(void (^)(BOOL))completionBlock;
@end

@implementation C4View

/* leaving animation delay only to views for now */
@synthesize animationDuration, animationDelay, animationOptions = _animationOptions, repeatCount = _repeatCount;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.animationDuration = 0.0f;
        self.animationDelay = 0.0f;
        self.animationOptions = BEGINCURRENT;
        self.repeatCount = 0;
    }
    return self;
}

-(void)addShape:(C4Shape *)aShape {
    [self addSubview:aShape];
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
    CGPoint oldCenter = CGPointMake(self.center.x, self.center.y);
    [self animateWithBlock:^{
        [super setCenter:center];
    } completion:^(BOOL completed) {
        if ((self.animationOptions & AUTOREVERSE) == AUTOREVERSE && completed) {
            CGFloat oldDuration = self.animationDuration;
            CGFloat oldDelay = self.animationDelay;
            [super setCenter:oldCenter];
            self.animationDuration = oldDuration;
            self.animationDelay = oldDelay;
        }
    }];
}

-(void)setFrame:(CGRect)frame {
    CGRect oldFrame = self.frame;
    [self animateWithBlock:^{
        [super setFrame:frame];
    } completion:^(BOOL completed) {
        if ((self.animationOptions & AUTOREVERSE) == AUTOREVERSE && completed) {
            CGFloat oldDuration = self.animationDuration;
            CGFloat oldDelay = self.animationDelay;
            [super setFrame:oldFrame];
            self.animationDuration = oldDuration;
            self.animationDelay = oldDelay;
        }
    }];
}

-(void)setBounds:(CGRect)bounds {
    CGRect oldBounds = self.bounds;
    [self animateWithBlock:^{
        [super setBounds:bounds];
    } completion:^(BOOL completed) {
        if ((self.animationOptions & AUTOREVERSE) == AUTOREVERSE && completed) {
            CGFloat oldDuration = self.animationDuration;
            CGFloat oldDelay = self.animationDelay;
            [super setBounds:oldBounds];
            self.animationDuration = oldDuration;
            self.animationDelay = oldDelay;
        }
    }];
}

-(void)setTransform:(CGAffineTransform)transform {
    CGAffineTransform oldTransform = self.transform;
    [self animateWithBlock:^{
        [super setTransform:transform];
    } completion:^(BOOL completed) {
        if ((self.animationOptions & AUTOREVERSE) == AUTOREVERSE && completed) {
            CGFloat oldDuration = self.animationDuration;
            CGFloat oldDelay = self.animationDelay;
            [super setTransform:oldTransform];
            self.animationDuration = oldDuration;
            self.animationDelay = oldDelay;
        }
    }];
}

-(void)setAlpha:(CGFloat)alpha {
    CGFloat oldAlpha = self.alpha;
    [self animateWithBlock:^{
        [super setAlpha:alpha];
    } completion:^(BOOL completed) {
        if ((self.animationOptions & AUTOREVERSE) == AUTOREVERSE && completed) {
            CGFloat oldDuration = self.animationDuration;
            CGFloat oldDelay = self.animationDelay;
            [super setAlpha:oldAlpha];
            self.animationDuration = oldDuration;
            self.animationDelay = oldDelay;
        }
    }];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    UIColor *oldBackgroundColor = self.backgroundColor;
    [self animateWithBlock:^{
        [super setBackgroundColor:backgroundColor];
    } completion:^(BOOL completed) {
        if ((self.animationOptions & AUTOREVERSE) == AUTOREVERSE && completed) {
            CGFloat oldDuration = self.animationDuration;
            CGFloat oldDelay = self.animationDelay;
            [super setBackgroundColor:oldBackgroundColor];
            self.animationDuration = oldDuration;
            self.animationDelay = oldDelay;
        }
    }];
}

-(void)setContentStretch:(CGRect)contentStretch {
    CGRect oldContentStretch = self.contentStretch;
    [self animateWithBlock:^{
        [super setContentStretch:contentStretch];
    } completion:^(BOOL completed) {
        if ((self.animationOptions & AUTOREVERSE) == AUTOREVERSE && completed) {
            CGFloat oldDuration = self.animationDuration;
            CGFloat oldDelay = self.animationDelay;
            [super setContentStretch:oldContentStretch];
            self.animationDuration = oldDuration;
            self.animationDelay = oldDelay;
        }
    }];
}

-(void)animateWithBlock:(void (^)(void))animationBlock {
    [self animateWithBlock:animationBlock completion:nil];
};

-(void)animateWithBlock:(void (^)(void))animationBlock completion:(void (^)(BOOL))completionBlock {
    [UIView animateWithDuration:self.animationDuration
                          delay:(NSTimeInterval)self.animationDelay
                        options:self.animationOptions
                     animations:animationBlock
                     completion:completionBlock];
};

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    _animationOptions = animationOptions;
}

-(BOOL)isAnimating {
    return [self.layer.animationKeys count];
}

#pragma mark Common Methods
-(void)setup {}

-(void)listenFor:(NSString *)aNotification andRunMethod:(NSString *)aMethodName{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(aMethodName) name:aNotification object:nil];
}

-(void)listenFor:(NSString *)aNotification fromObject:(id)anObject andRunMethod:(NSString *)aMethodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(aMethodName) name:aNotification object:anObject];
}

-(void)stopListeningFor:(NSString *)aMethodName {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:aMethodName object:nil];
}

-(void)postNotification:(NSString *)aNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:aNotification object:self];
}

@end
