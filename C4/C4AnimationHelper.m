// Copyright © 2012 Travis Kirton, Alejandro Isaza
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import "C4AnimationHelper.h"

@implementation C4AnimationHelper

- (id)initWithLayer:(CALayer *)layer {
    self = [super init];
    if (!self)
        return nil;
    
    _layer = layer;
    self.animationDuration = 0;
    self.animationDelay = 0;
    self.currentAnimationEasing = kCAMediaTimingFunctionEaseInEaseOut;
    self.autoreverses = NO;
    self.repeats = NO;
    
    return self;
}

- (void)setAnimationOptions:(NSUInteger)animationOptions {
    _animationOptions = animationOptions;
    
    if (animationOptions & LINEAR) {
        self.currentAnimationEasing = kCAMediaTimingFunctionLinear;
    } else if(animationOptions & EASEOUT) {
        self.currentAnimationEasing = kCAMediaTimingFunctionEaseOut;
    } else if(animationOptions & EASEIN) {
        self.currentAnimationEasing = kCAMediaTimingFunctionEaseIn;
    } else if(animationOptions & EASEINOUT) {
        self.currentAnimationEasing = kCAMediaTimingFunctionEaseInEaseOut;
    } else {
        self.currentAnimationEasing = kCAMediaTimingFunctionEaseInEaseOut;
    }
    
    self.autoreverses = (animationOptions & AUTOREVERSE) != 0;
    self.repeats = (animationOptions & REPEAT) != 0;
}

- (CABasicAnimation *)animation {
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.duration = self.animationDuration;
    animation.beginTime = CACurrentMediaTime() + self.animationDelay;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:self.currentAnimationEasing];
    animation.autoreverses = self.autoreverses;
    animation.repeatCount = self.repeats ? FOREVER : 0;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeBoth;
    return animation;
}

- (void)animateKeyPath:(NSString *)keyPath toValue:(id)toValue {
    [self animateKeyPath:keyPath toValue:toValue completion:NULL];
}

- (void)animateKeyPath:(NSString *)keyPath toValue:(id)toValue completion:(void (^)())completion {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if (self.animationDuration == 0) {
        [self.layer setValue:toValue forKeyPath:keyPath];
        return;
    }
    
    [CATransaction begin];
    if (completion)
        [CATransaction setCompletionBlock:completion];
    
    CABasicAnimation *animation = [self animation];
    animation.keyPath = keyPath;
    animation.fromValue = [self.layer.presentationLayer valueForKeyPath:keyPath];
    animation.toValue = toValue;
    [_layer addAnimation:animation forKey:keyPath];
    
    [CATransaction commit];
}

- (void)pause {
    CFTimeInterval pausedTime = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = pausedTime;
}

- (void)resume {
    CFTimeInterval pausedTime = [self.layer timeOffset];
    self.layer.speed = 1.0;
    self.layer.timeOffset = 0.0;
    self.layer.beginTime = 0.0;
    CFTimeInterval timeSincePause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    self.layer.beginTime = timeSincePause;
}

@end
