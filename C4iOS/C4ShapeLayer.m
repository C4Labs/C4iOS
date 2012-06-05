//
//  C4ShapeLayer.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4ShapeLayer.h"

@interface C4ShapeLayer()
-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath;
@end

@implementation C4ShapeLayer
@synthesize animationOptions = _animationOptions, currentAnimationEasing, repeatCount, animationDuration = _animationDuration;
@synthesize allowsInteraction, repeats;

-(id)init {
    self = [super init];
    if(self != nil) {
        self.name = @"shapeLayer";
        self.strokeColor = C4RED.CGColor;
        self.fillColor = C4BLUE.CGColor;
        self.lineWidth = 5.0f;
        self.repeatCount = 0;
        self.autoreverses = NO;
        
        currentAnimationEasing = (NSString *)kCAMediaTimingFunctionEaseInEaseOut;
        allowsInteraction = NO;
        repeats = NO;
        
        /* create basic attributes after setting animation attributes above */
        CGPathRef newPath = CGPathCreateWithRect(CGRectZero, nil);
        self.path = newPath;
        /* makes sure there are no extraneous animation keys lingering about after init */
        [self removeAllAnimations];
        CFRelease(newPath);
    }
    return self;
}

-(void)dealloc {
    [self removeAllAnimations];
}

#pragma mark C4Layer Animation Methods
-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath {
    double duration = (double)self.animationDuration;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = duration;
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
    animation.fromValue = (id)self.path;
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

-(BOOL)isOpaque {
    /*
     Apple docs say that the frameworks flip this to NO automatically 
     ...if you do things like set the background color to anything transparent
     */
    return YES;
}

-(void)setAnimationDuration:(CGFloat)duration {
    if (duration <= 0.0f) duration = 0.001f;
    _animationDuration = duration;
}

#pragma mark ShapeLayer Methods
/* encapsulating an animation that will correspond to the superview's animation */
-(void)animatePath:(CGPathRef)_path {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"path"];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.path = _path; }];
    }
    animation.fromValue = (id)self.path;
    animation.toValue = (__bridge id)_path;    
    [self addAnimation:animation forKey:@"animatePath"];
    [CATransaction commit];
}

-(void)animateFillColor:(CGColorRef)_fillColor {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"fillColor"];
    animation.fromValue = (id)self.fillColor;
    animation.toValue = (__bridge id)_fillColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.fillColor = _fillColor; }];
    }
    [self addAnimation:animation forKey:@"animateFillColor"];
    [CATransaction commit];
}

-(void)setLineDashPhase:(CGFloat)_lineDashPhase {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineDashPhase"];
    animation.fromValue = [NSNumber numberWithFloat:self.lineDashPhase];
    animation.toValue = [NSNumber numberWithFloat:_lineDashPhase];
    [self addAnimation:animation forKey:@"animateLineDashPhase"];
    if(!self.autoreverses) [super setLineDashPhase:_lineDashPhase];
    [CATransaction commit];
}

-(void)animateLineWidth:(CGFloat)_lineWidth {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineWidth"];
    animation.fromValue = [NSNumber numberWithFloat:self.lineWidth];
    animation.toValue = [NSNumber numberWithFloat:_lineWidth];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.lineWidth = _lineWidth; }];
    }
    [self addAnimation:animation forKey:@"animateLineWidth"];
    [CATransaction commit];
}

-(void)animateMiterLimit:(CGFloat)_miterLimit {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"miterLimit"];
    animation.fromValue = [NSNumber numberWithFloat:self.miterLimit];
    animation.toValue = [NSNumber numberWithFloat:_miterLimit];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.miterLimit = _miterLimit; }];
    }
    [self addAnimation:animation forKey:@"animateMiterLimit"];
    [CATransaction commit];
}

-(void)animateStrokeColor:(CGColorRef)_strokeColor {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeColor"];
    animation.fromValue = (id)self.strokeColor;
    animation.toValue = (__bridge id)_strokeColor;   
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.strokeColor = _strokeColor; }];
    }
    
    [self addAnimation:animation forKey:@"animateStrokeColor"];
    [CATransaction commit];
}

-(void)animateStrokeEnd:(CGFloat)_strokeEnd {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeEnd"];
    animation.fromValue = [NSNumber numberWithFloat:self.strokeEnd];
    animation.toValue = [NSNumber numberWithFloat:_strokeEnd];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.strokeEnd = _strokeEnd; }];
    }
    [self addAnimation:animation forKey:@"animateStrokeEnd"];
    [CATransaction commit];
}

-(void)animateStrokeStart:(CGFloat)_strokeStart {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeStart"];
    animation.fromValue = [NSNumber numberWithFloat:self.strokeStart];
    animation.toValue = [NSNumber numberWithFloat:_strokeStart];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { self.strokeStart = _strokeStart; }];
    }
    [self addAnimation:animation forKey:@"animateStrokeStart"];
    [CATransaction commit];
}

#pragma mark Blocked Methods
-(void)setBorderWidth:(CGFloat)borderWidth{
    C4Log(@"C4ShapeLayer setBorderWidth not currently available");
}

-(void)setBorderColor:(CGColorRef)borderColor{
    C4Log(@"C4ShapeLayer setBorderColor not currently available");
}

-(void)setBackgroundColor:(CGColorRef)backgroundColor {
    C4Log(@"C4ShapeLayer setBackgroundColor not currently available");
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    C4Log(@"C4ShapeLayer setCornerRadius not currently available");
}

//-(void)setMasksToBounds:(BOOL)masksToBounds {
//    C4Log(@"C4ShapeLayer setMasksToBounds not currently available");
//}

-(void)setContentsGravity:(NSString *)contentsGravity {
    C4Log(@"C4ShapeLayer setContentsGravity not currently available");
}

-(void)setHidden:(BOOL)hidden {
    C4Log(@"C4ShapeLayer setHidden not currently available");
}

-(void)setDoubleSided:(BOOL)doubleSided {
    C4Log(@"C4ShapeLayer setDoubleSided not currently available");
}

-(void)setMinificationFilter:(NSString *)minificationFilter {
    C4Log(@"C4ShapeLayer setMinificationFilter not currently available");
}

-(void)setMinificationFilterBias:(float)minificationFilterBias {
    C4Log(@"C4ShapeLayer setMinificationFilterBias not currently available");
}

-(void)setOpacity:(float)opacity {
    C4Log(@"C4ShapeLayer setOpacity not currently available");
}

-(void)setStyle:(NSDictionary *)style {
    C4Log(@"C4ShapeLayer setStyle not currently available");
    
}

-(void)setZPosition:(CGFloat)zPosition {
    C4Log(@"C4ShapeLayer setZPosition not currently available");
}

-(void)animateContents:(CGImageRef)image {
    C4Log(@"C4ShapeLayer animateContents not currently available");
}

@end
