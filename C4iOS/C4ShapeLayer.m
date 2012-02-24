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
@synthesize animationOptions = _animationOptions, currentAnimationEasing, repeatCount, animationDuration;
@synthesize allowsInteraction, repeats, isShapeLayer;

-(id)init {
    self = [super init];
    if(self != nil) {
        self.name = @"shapeLayer";
        isShapeLayer = YES;
        currentAnimationEasing = kCAMediaTimingFunctionDefault;
        allowsInteraction = NO;
        repeats = NO;
        self.repeatCount = 0;
        self.autoreverses = NO;
        self.fillMode = kCAFillModeBoth;
        /* create basic attributes after setting animation attributes above */
        self.path = CGPathCreateWithRect(CGRectZero, nil);
        /* makes sure there are no extraneous animation keys lingering about after init */
        [self removeAllAnimations];
    }
    return self;
}

-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath {
    double duration = (double)self.animationDuration;
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:keyPath];
    animation.duration = duration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:self.currentAnimationEasing];
    animation.autoreverses = self.autoreverses;
    animation.repeatCount = self.repeats ? FOREVER : 0;
    animation.fillMode = kCAFillModeBoth;
    animation.removedOnCompletion = YES;
    animation.delegate = self;
    return animation;
}

/* encapsulating an animation that will correspond to the superview's animation */
-(void)animatePath:(CGPathRef)_path {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"path"];
    animation.fromValue = (id)self.path;
    animation.toValue = (__bridge id)_path;    
    [self addAnimation:animation forKey:@"animatePath"];
}

-(void)animateFillColor:(CGColorRef)_fillColor {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"fillColor"];
    animation.fromValue = (id)self.fillColor;
    animation.toValue = (__bridge id)_fillColor;   
    [self addAnimation:animation forKey:@"animateFillColor"];
}

-(void)setLineDashPhase:(CGFloat)_lineDashPhase {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineDashPhase"];
    animation.fromValue = [NSNumber numberWithFloat:self.lineDashPhase];
    animation.toValue = [NSNumber numberWithFloat:_lineDashPhase];
    [self addAnimation:animation forKey:@"animateLineDashPhase"];
    if(!self.autoreverses) [super setLineDashPhase:_lineDashPhase];
}

-(void)animateLineWidth:(CGFloat)_lineWidth {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineWidth"];
    animation.fromValue = [NSNumber numberWithFloat:self.lineWidth];
    animation.toValue = [NSNumber numberWithFloat:_lineWidth];
    [self addAnimation:animation forKey:@"animateLineWidth"];
}

-(void)animateMiterLimit:(CGFloat)_miterLimit {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"miterLimit"];
    animation.fromValue = [NSNumber numberWithFloat:self.miterLimit];
    animation.toValue = [NSNumber numberWithFloat:_miterLimit];
    [self addAnimation:animation forKey:@"animateMiterLimit"];
}

-(void)animateStrokeColor:(CGColorRef)_strokeColor {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeColor"];
    animation.fromValue = (id)self.strokeColor;
    animation.toValue = (__bridge id)_strokeColor;   
    [self addAnimation:animation forKey:@"animateStrokeColor"];
}

-(void)animateStrokeEnd:(CGFloat)_strokeEnd {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeEnd"];
    C4Log(@"strokeEnd");
    C4Log(@"self.animationDuration: %4.2f",self.animationDuration);
    C4Log(@"animation.duration: %4.2f",animation.duration);
    animation.fromValue = [NSNumber numberWithFloat:self.strokeEnd];
    animation.toValue = [NSNumber numberWithFloat:_strokeEnd];
    [self addAnimation:animation forKey:@"animateStrokeEnd"];
}

-(void)animateStrokeStart:(CGFloat)_strokeStart {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeStart"];
    animation.fromValue = [NSNumber numberWithFloat:self.strokeStart];
    animation.toValue = [NSNumber numberWithFloat:_strokeStart];
    [self addAnimation:animation forKey:@"animateStrokeStart"];
}
 
-(void)animateShadowOpacity:(CGFloat)_shadowOpacity {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = [NSNumber numberWithFloat:self.shadowOpacity];
    animation.toValue = [NSNumber numberWithFloat:_shadowOpacity];
    [self addAnimation:animation forKey:@"animateShadowOpacity"];
}

-(void)animateShadowRadius:(CGFloat)_shadowRadius {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowRadius"];
    animation.fromValue = [NSNumber numberWithFloat:self.shadowRadius];
    animation.toValue = [NSNumber numberWithFloat:_shadowRadius];
    [self addAnimation:animation forKey:@"animateShadowOpacity"];
}

-(void)animateShadowOffset:(CGSize)_shadowOffset {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOffset"];
    animation.fromValue = [NSValue valueWithCGSize:self.shadowOffset];
    animation.toValue = [NSValue valueWithCGSize:_shadowOffset];
    [self addAnimation:animation forKey:@"animateShadowOffset"];
}

-(void)animateShadowPath:(CGPathRef)_shadowPath {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowPath"];
    animation.fromValue = (id)self.path;
    animation.toValue = (__bridge id)_shadowPath;    
    [self addAnimation:animation forKey:@"animateShadowPath"];
}

-(void)animateBackgroundFilters:(NSArray *)_backgroundFilters {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"backgroundFilters"];
    animation.fromValue = self.backgroundFilters;
    animation.toValue = _backgroundFilters;
    [self addAnimation:animation forKey:@"animateBackgroundFilters"];
}

-(void)animateCompositingFilter:(id)_compositingFilter {
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"compositingFilter"];
    animation.fromValue = self.compositingFilter;
    animation.toValue = _compositingFilter;
    [self addAnimation:animation forKey:@"animateCompositingFilter"];
}

/* in the following method
 if we implement other kinds of options, we'll have to get rid of the returns...
 reversing how i check the values, if linear is at the bottom, then all the other values get called
 */
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

-(void)test {
    C4Log(@"animationOptions: %@",self.currentAnimationEasing);
    C4Log(@"autoreverses: %@", self.autoreverses ? @"YES" : @"NO");
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *keyPath = ((CAPropertyAnimation *)anim).keyPath;
    if ([keyPath isEqualToString:@"path"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.path = (__bridge CGPathRef)(((CABasicAnimation *)anim).toValue);
            [self addAnimation:animation forKey:@"path"];
        }
    } else if ([keyPath isEqualToString:@"fillColor"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.fillColor = (__bridge CGColorRef)(((CABasicAnimation *)anim).toValue);
            [self addAnimation:animation forKey:@"fillColor"];
        }
    } else if ([keyPath isEqualToString:@"lineWidth"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.lineWidth = [((CABasicAnimation *)anim).toValue floatValue];
            [self addAnimation:animation forKey:@"lineWidth"];
        }
    } else if ([keyPath isEqualToString:@"miterLimit"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.miterLimit = [((CABasicAnimation *)anim).toValue floatValue];
            [self addAnimation:animation forKey:@"miterLimit"];
        }
    } else if ([keyPath isEqualToString:@"strokeColor"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.strokeColor = (__bridge CGColorRef)(((CABasicAnimation *)anim).toValue);
            [self addAnimation:animation forKey:@"strokeColor"];
        }
    } else if ([keyPath isEqualToString:@"strokeEnd"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.strokeEnd = [((CABasicAnimation *)anim).toValue floatValue];
            [self addAnimation:animation forKey:@"strokeEnd"];
        }
    } else if ([keyPath isEqualToString:@"strokeStart"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.strokeStart = [((CABasicAnimation *)anim).toValue floatValue];
            [self addAnimation:animation forKey:@"strokeStart"];
        }
    } else if ([keyPath isEqualToString:@"shadowOpacity"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.shadowOpacity = [((CABasicAnimation *)anim).toValue floatValue];
            [self addAnimation:animation forKey:@"shadowOpacity"];
        }
    } else if ([keyPath isEqualToString:@"shadowRadius"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.shadowRadius = [((CABasicAnimation *)anim).toValue floatValue];
            [self addAnimation:animation forKey:@"shadowRadius"];
        }
    } else if ([keyPath isEqualToString:@"shadowOffset"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.shadowOffset = [((CABasicAnimation *)anim).toValue CGSizeValue];
            [self addAnimation:animation forKey:@"shadowOffset"];
        }
    } else if ([keyPath isEqualToString:@"shadowPath"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.shadowPath = (__bridge CGPathRef)(((CABasicAnimation *)anim).toValue);
            [self addAnimation:animation forKey:@"shadowPath"];
        }
    } else if ([keyPath isEqualToString:@"backgroundFilters"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.backgroundFilters = ((CABasicAnimation *)anim).toValue;
            [self addAnimation:animation forKey:@"backgroundFilters"];
        }
    } else if ([keyPath isEqualToString:@"compositingFilter"] && anim.repeatCount != FOREVER) {
        if(!self.autoreverses){
            CAAnimation *animation = [CAAnimation animation];
            animation.duration = 0.0f;
            self.compositingFilter = ((CABasicAnimation *)anim).toValue;
            [self addAnimation:animation forKey:@"compositingFilter"];
        }
    } 
}

-(BOOL)isOpaque {
    return YES;
}

-(void)setAnimationDurationValue:(CGFloat)duration {
    if (duration <= 0.0f) duration = 0.001f;
    [self setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
}

-(CGFloat)animationDurationValue {
    return [[self valueForKey:kCATransactionAnimationDuration] floatValue];
}

/* blocked methods, for now... */

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

-(void)setMasksToBounds:(BOOL)masksToBounds {
    C4Log(@"C4ShapeLayer setMasksToBounds not currently available");
}

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

@end
