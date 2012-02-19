//
//  C4ShapeLayer.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4ShapeLayer.h"
@interface C4ShapeLayer() 
-(void)setupAnimation;
@end

@implementation C4ShapeLayer
@synthesize animationOptions = _animationOptions, currentAnimationEasing;
-(id)init {
    self = [super init];
    if(self != nil) {
        currentAnimationEasing = kCAMediaTimingFunctionDefault;
    }
    return self;
}

/* encapsulating an animation that will correspond to the superview's animation */
-(void)setPath:(CGPathRef)newPath {
    if ([[self valueForKey:kCATransactionAnimationDuration] floatValue] > 0.0f) {
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = [[self valueForKey:kCATransactionAnimationDuration] doubleValue];
        animation.timingFunction = [CAMediaTimingFunction functionWithName:
                                    self.currentAnimationEasing];
        animation.fromValue = (id)self.path;
        animation.toValue = (__bridge id)newPath;    

        [self addAnimation:animation forKey:kCATransition];
    }
    [super setPath:newPath];
}

-(void)setupAnimation {
    [CATransaction setAnimationDuration:[[self valueForKey:kCATransactionAnimationDuration] doubleValue]];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:self.currentAnimationEasing]];
}

-(void)setFillColor:(CGColorRef)_fillColor {    
    [self setupAnimation];
    [super setFillColor:_fillColor];
}

-(void)setFillRule:(NSString *)_fillRule {
    [self setupAnimation];
    [super setFillRule:_fillRule];
}

-(void)setLineCap:(NSString *)_lineCap {
    [self setupAnimation];
    [super setLineCap:_lineCap];
}

-(void)setLineDashPattern:(NSArray *)_lineDashPattern {
    [self setupAnimation];
    [super setLineDashPattern:_lineDashPattern];
}

-(void)setLineDashPhase:(CGFloat)_lineDashPhase {
    [self setupAnimation];
    [super setLineDashPhase:_lineDashPhase];
}

-(void)setLineJoin:(NSString *)_lineJoin {
    [self setupAnimation];
    [super setLineJoin:_lineJoin];
}

-(void)setLineWidth:(CGFloat)_lineWidth {
    [self setupAnimation];
    [super setLineWidth:_lineWidth];
}

-(void)setMitreLimit:(CGFloat)_mitreLimit {
    [self setupAnimation];
    [super setMiterLimit:_mitreLimit];
}

-(void)setStrokeColor:(CGColorRef)_strokeColor {
    [self setupAnimation];
    [super setStrokeColor:_strokeColor];
}

-(void)setStrokeEnd:(CGFloat)_strokeEnd {
    [self setupAnimation];
    [super setStrokeEnd:_strokeEnd];
}

-(void)setStrokeStart:(CGFloat)_strokeStart {
    [self setupAnimation];
    [super setStrokeStart:_strokeStart];
}

-(void)setAnimationDurationValue:(CGFloat)duration {
    [self setValue:[NSNumber numberWithFloat:duration] forKey:kCATransactionAnimationDuration];
}

-(CGFloat)animationDurationValue {
    return [[self valueForKey:kCATransactionAnimationDuration] floatValue];
}

/* in the following method
 if we implement other kinds of options, we'll have to get rid of the returns...
 (i.e. the ones which are outlined in C4AnimationOptions, in C4Defines.h) 
 was doing shit like the following, and it wasn't working:
    mask = LINEAR;
    C4Log(@"--- EASEIN --- %d", mask);
    if((mask & EASEIN) == EASEIN) C4Log(@"EASEIN");
    if((mask & EASEINOUT) == EASEINOUT) C4Log(@"EASEINOUT");
    if((mask & EASEOUT) == EASEOUT) C4Log(@"EASEOUT");
    if((mask & LINEAR) == LINEAR) C4Log(@"LINEAR");
 */

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    if(animationOptions == EASEIN) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseIn;
        return;
    }
    if(animationOptions == EASEINOUT) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseInEaseOut;
        return;
    }
    if(animationOptions == EASEOUT) {
        currentAnimationEasing = kCAMediaTimingFunctionEaseOut;
        return;
    }
    if(animationOptions == LINEAR) {
        currentAnimationEasing = kCAMediaTimingFunctionLinear;
        return;
    }
    currentAnimationEasing = kCAMediaTimingFunctionDefault;
}

-(void)test {
    C4Log(@"animationOptions: %@",self.currentAnimationEasing);
}

@end
