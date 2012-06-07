//
//  C4OpenGLLayer.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4EAGLLayer.h"

@implementation C4EAGLLayer
@synthesize animationOptions = _animationOptions, currentAnimationEasing, repeatCount, animationDuration = _animationDuration;
@synthesize allowsInteraction, repeats;

-(id)init {
    self = [super init]; 
    if(self != nil) {
        self.name = @"eaglLayer";
        self.repeatCount = 0;
        self.autoreverses = NO;
        
        currentAnimationEasing = (NSString *)kCAMediaTimingFunctionEaseInEaseOut;
        allowsInteraction = NO;
        repeats = NO;
    }
    return self;
}

#pragma mark C4Layer Animation Methods
-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = self.animationDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:self.currentAnimationEasing];
    animation.autoreverses = self.autoreverses;
    animation.repeatCount = self.repeats ? FOREVER : 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    return animation;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    if((animationOptions & LINEAR) == LINEAR) {
        currentAnimationEasing = kCAMediaTimingFunctionLinear;
    } else if((animationOptions & EASEOUT) == EASEOUT) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseOut;
    } else if((animationOptions & EASEIN) == EASEIN) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseIn;
    } else if((animationOptions & EASEINOUT) == EASEINOUT) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseInEaseOut;
    } else {
        currentAnimationEasing = kCAMediaTimingFunctionDefault;
    }
    
    if((animationOptions & AUTOREVERSE) == AUTOREVERSE) self.autoreverses = YES;
    else self.autoreverses = NO;
    
    if((animationOptions & REPEAT) == REPEAT) repeats = YES;
    else repeats = NO;
    
    if((animationOptions & ALLOWSINTERACTION) == ALLOWSINTERACTION) allowsInteraction = YES;
    else allowsInteraction = NO;
}

#pragma mark C4Layer methods
-(void)animateShadowColor:(CGColorRef)_shadowColor {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowColor"];
    animation.fromValue = (id)self.shadowColor;
    animation.toValue = (__bridge id)_shadowColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.shadowColor = _shadowColor; }];
    }
    [self addAnimation:animation forKey:@"animateShadowColor"];
    [CATransaction commit];
}

-(void)animateShadowOpacity:(CGFloat)_shadowOpacity {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = [NSNumber numberWithFloat:self.shadowOpacity];
    animation.toValue = [NSNumber numberWithFloat:_shadowOpacity];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.shadowOpacity = _shadowOpacity; }];
    }
    [self addAnimation:animation forKey:@"animateShadowOpacity"];
    [CATransaction commit];
}

-(void)animateShadowRadius:(CGFloat)_shadowRadius {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowRadius"];
    animation.fromValue = [NSNumber numberWithFloat:self.shadowRadius];
    animation.toValue = [NSNumber numberWithFloat:_shadowRadius];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.shadowRadius = _shadowRadius; }];
    }
    [self addAnimation:animation forKey:@"animateShadowOpacity"];
    [CATransaction commit];
}

-(void)animateShadowOffset:(CGSize)_shadowOffset {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOffset"];
    animation.fromValue = [NSValue valueWithCGSize:self.shadowOffset];
    animation.toValue = [NSValue valueWithCGSize:_shadowOffset];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.shadowOffset = _shadowOffset; }];
    }
    [self addAnimation:animation forKey:@"animateShadowOffset"];
    [CATransaction commit];
}

-(void)animateShadowPath:(CGPathRef)_shadowPath {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowPath"];
    animation.fromValue = (id)self.shadowPath;
    animation.toValue = (__bridge id)_shadowPath;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.shadowPath = _shadowPath; }];
    }
    [self addAnimation:animation forKey:@"animateShadowPath"];
    [CATransaction commit];
}

-(void)animateBackgroundFilters:(NSArray *)_backgroundFilters {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"backgroundFilters"];
    animation.fromValue = self.backgroundFilters;
    animation.toValue = _backgroundFilters;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.backgroundFilters = _backgroundFilters; }];
    }
    [self addAnimation:animation forKey:@"animateBackgroundFilters"];
    [CATransaction commit];
}

-(void)animateCompositingFilter:(id)_compositingFilter {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"compositingFilter"];
    animation.fromValue = self.compositingFilter;
    animation.toValue = _compositingFilter;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.compositingFilter = _compositingFilter; }];
    }
    [self addAnimation:animation forKey:@"animateCompositingFilter"];
    [CATransaction commit];
}

-(void)setAnimationDuration:(CGFloat)duration {
    if (duration <= 0.0f) duration = 0.001f;
    _animationDuration = duration;
}

-(void)animateContents:(CGImageRef)image {
    C4Log(@"C4ShapeLayer animateContents not currently available");
}

#pragma mark New Stuff
-(void)animateBackgroundColor:(CGColorRef)_backgroundColor {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"backgroundColor"];
    animation.fromValue = (id)self.backgroundColor;
    animation.toValue = (__bridge id)_backgroundColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.backgroundColor = _backgroundColor; 
            [self removeAnimationForKey:@"animateBackgroundColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBackgroundColor"];
    [CATransaction commit];
}

-(void)animateBorderWidth:(CGFloat)_borderWidth {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"borderWidth"];
    animation.fromValue = [NSNumber numberWithFloat:self.borderWidth];
    animation.toValue = [NSNumber numberWithFloat:_borderWidth];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.borderWidth = _borderWidth; 
            [self removeAnimationForKey:@"animateBorderWidth"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBorderWidth"];
    [CATransaction commit];
}

-(void)animateBorderColor:(CGColorRef)_borderColor {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"borderColor"];
    animation.fromValue = (id)self.borderColor;
    animation.toValue = (__bridge id)_borderColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.borderColor = _borderColor; 
            [self removeAnimationForKey:@"animateBorderColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBorderColor"];
    [CATransaction commit];
}

-(void)animateCornerRadius:(CGFloat)_cornerRadius {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"cornerRadius"];
    animation.fromValue = [NSNumber numberWithFloat:self.cornerRadius];
    animation.toValue = [NSNumber numberWithFloat:_cornerRadius];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.cornerRadius = _cornerRadius; 
            [self removeAnimationForKey:@"animateCornerRadius"];
        }];
    }
    [self addAnimation:animation forKey:@"animateCornerRadius"];
    [CATransaction commit];
}

-(void)animateZPosition:(CGFloat)_zPosition {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"zPosition"];
    animation.fromValue = [NSNumber numberWithFloat:self.zPosition];
    animation.toValue = [NSNumber numberWithFloat:_zPosition];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.zPosition = _zPosition; 
            [self removeAnimationForKey:@"animateZPosition"];
        }];
    }
    [self addAnimation:animation forKey:@"animateZPosition"];
    [CATransaction commit];
}

@end
