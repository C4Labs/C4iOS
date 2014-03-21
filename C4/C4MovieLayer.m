// Copyright © 2012 Travis Kirton
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

#import "C4MovieLayer.h"

@interface C4MovieLayer ()
@property (readwrite, nonatomic) CGFloat rotationAngle, rotationAngleX, rotationAngleY;
@end

@implementation C4MovieLayer

@synthesize animationOptions = _animationOptions, currentAnimationEasing = _currentAnimationEasing, repeatCount = _repeatCount, animationDuration = _animationDuration, allowsInteraction = _allowsInteraction, repeats = _repeats;
@synthesize perspectiveDistance = _perspectiveDistance;

- (id)init {
    self = [super init];
    if (self != nil) {
        self.name = @"playerLayer";
        self.repeatCount = 0;
        self.autoreverses = NO;
        
        _currentAnimationEasing = (NSString *)kCAMediaTimingFunctionEaseInEaseOut;
        _allowsInteraction = NO;
        _repeats = NO;
        
        /* makes sure there are no extraneous animation keys lingering about after init */
        [self removeAllAnimations];
#ifdef VERBOSE
        C4Log(@"%@ init",[self class]);
#endif
    }
    return self;
}

-(void)awakeFromNib {
#ifdef VERBOSE
    C4Log(@"%@ awakeFromNib",[self class]);
#endif
}

-(void)dealloc {
    [self removeAllAnimations];
}

#pragma mark Safe Initialization Methods
-(void)setup {}
-(void)test {}

#pragma mark C4Layer Animation Methods //code from this line forward should be common amongst all C4Layer variations
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

-(CGFloat)animationDuration {
    //adding this because a default of 0.0 triggers implicit animation of 0.25f
    return _animationDuration + 0.00001f;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    if((animationOptions & LINEAR) == LINEAR) {
        _currentAnimationEasing = kCAMediaTimingFunctionLinear;
    } else if((animationOptions & EASEOUT) == EASEOUT) {
        _currentAnimationEasing = kCAMediaTimingFunctionEaseOut;
    } else if((animationOptions & EASEIN) == EASEIN) {
        _currentAnimationEasing = kCAMediaTimingFunctionEaseIn;
    } else if((animationOptions & EASEINOUT) == EASEINOUT) {
        _currentAnimationEasing = kCAMediaTimingFunctionEaseInEaseOut;
    } else {
        _currentAnimationEasing = kCAMediaTimingFunctionDefault;
    }
    
    if((animationOptions & AUTOREVERSE) == AUTOREVERSE) self.autoreverses = YES;
    else self.autoreverses = NO;
    
    if((animationOptions & REPEAT) == REPEAT) _repeats = YES;
    else _repeats = NO;
    
    if((animationOptions & ALLOWSINTERACTION) == ALLOWSINTERACTION) _allowsInteraction = YES;
    else _allowsInteraction = NO;
}

-(void)setPerspectiveDistance:(CGFloat)perspectiveDistance {
    _perspectiveDistance = perspectiveDistance;
    CATransform3D t = self.transform;
    if(perspectiveDistance != 0.0f) t.m34 = 1/self.perspectiveDistance;
    else t.m34 = 0.0f;
    self.transform = t;
}

-(void)animateBackgroundColor:(CGColorRef)backgroundColor {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.backgroundColor = backgroundColor;
        return;
    }
    if (self.animationDuration == 0.0f) self.backgroundColor = backgroundColor;
    else {
        [CATransaction begin];
        CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"backgroundColor"];
        animation.fromValue = (id)self.backgroundColor;
        animation.toValue = (__bridge id)backgroundColor;
        if (animation.repeatCount != FOREVER && !self.autoreverses) {
            [CATransaction setCompletionBlock:^ {
                self.backgroundColor = backgroundColor;
                [self removeAnimationForKey:@"animateBackgroundColor"];
            }];
        }
        [self addAnimation:animation forKey:@"animateBackgroundColor"];
        [CATransaction commit];
    }
}

-(void)animateBorderColor:(CGColorRef)borderColor {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.borderColor = borderColor;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"borderColor"];
    animation.fromValue = (id)self.borderColor;
    animation.toValue = (__bridge id)borderColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.borderColor = borderColor;
            [self removeAnimationForKey:@"animateBorderColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBorderColor"];
    [CATransaction commit];
}

-(void)animateBackgroundFilters:(NSArray *)backgroundFilters {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.backgroundFilters = backgroundFilters;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"backgroundFilters"];
    animation.fromValue = self.backgroundFilters;
    animation.toValue = backgroundFilters;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.backgroundFilters = backgroundFilters;
            [self removeAnimationForKey:@"animateBackgroundFilters"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBackgroundFilters"];
    [CATransaction commit];
}

-(void)animateBorderWidth:(CGFloat)borderWidth {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.borderWidth = borderWidth;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"borderWidth"];
    animation.fromValue = @(self.borderWidth);
    animation.toValue = @(borderWidth);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.borderWidth = borderWidth;
            [self removeAnimationForKey:@"animateBorderWidth"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBorderWidth"];
    [CATransaction commit];
}

-(void)animateCompositingFilter:(id)compositingFilter {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.compositingFilter = compositingFilter;
        return;
    }
    
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"compositingFilter"];
    animation.fromValue = self.compositingFilter;
    animation.toValue = compositingFilter;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.compositingFilter = compositingFilter;
            [self removeAnimationForKey:@"animateCompositingFilter"];
        }];
    }
    [self addAnimation:animation forKey:@"animateCompositingFilter"];
    [CATransaction commit];
}

-(void)animateContents:(CGImageRef)image {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.contents = (__bridge id)(image);
        return;
    }
    
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"contents"];
    animation.fromValue = self.contents;
    animation.toValue = (__bridge id)image;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.contents = (__bridge id)image;
            [self removeAnimationForKey:@"animateContents"];
        }];
    }
    [self addAnimation:animation forKey:@"animateContents"];
    [CATransaction commit];
}

-(void)animateCornerRadius:(CGFloat)cornerRadius {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.cornerRadius = cornerRadius;
        return;
    }
    
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"cornerRadius"];
    animation.fromValue = @(self.cornerRadius);
    animation.toValue = @(cornerRadius);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.cornerRadius = cornerRadius;
            [self removeAnimationForKey:@"animateCornerRadius"];
        }];
    }
    [self addAnimation:animation forKey:@"animateCornerRadius"];
    [CATransaction commit];
}

-(void)animateLayerTransform:(CATransform3D)layerTransform {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.sublayerTransform = layerTransform;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"sublayerTransform"];
    animation.fromValue = [NSValue valueWithCATransform3D:self.sublayerTransform];
    animation.toValue = [NSValue valueWithCATransform3D:layerTransform];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.sublayerTransform = layerTransform;
            [self removeAnimationForKey:@"sublayerTransform"];
        }];
    }
    [self addAnimation:animation forKey:@"sublayerTransform"];
    [CATransaction commit];
}



-(void)animateRotation:(CGFloat)rotationAngle {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(self.rotationAngle);
    animation.toValue = @(rotationAngle);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.rotationAngle = rotationAngle;
            [self.delegate rotationDidFinish:rotationAngle];
            [self removeAnimationForKey:@"animateRotationZ"];
        }];
    }
    [self addAnimation:animation forKey:@"animateRotationZ"];
    [CATransaction commit];
}

-(void)animateRotationX:(CGFloat)newRotationAngle {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.x"];
    animation.fromValue = @(self.rotationAngleX);
    animation.toValue = @(newRotationAngle);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.transform = CATransform3DRotate(self.transform, newRotationAngle - self.rotationAngleX, 1, 0, 0);
            self.rotationAngleX = newRotationAngle;
            [self removeAnimationForKey:@"animateRotationX"];
        }];
    }
    [self addAnimation:animation forKey:@"animateRotationX"];
    [CATransaction commit];
}

-(void)animateRotationY:(CGFloat)newRotationAngle {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = @(self.rotationAngleY);
    animation.toValue = @(newRotationAngle);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.transform =    CATransform3DRotate(self.transform, newRotationAngle - self.rotationAngleY, 0, 1, 0);
            self.rotationAngleY = newRotationAngle;
            [self removeAnimationForKey:@"animateRotationY"];
        }];
    }
    [self addAnimation:animation forKey:@"animateRotationY"];
    [CATransaction commit];
}

-(void)animateShadowColor:(CGColorRef)shadowColor {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.shadowColor = shadowColor;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowColor"];
    animation.fromValue = (id)self.shadowColor;
    animation.toValue = (__bridge id)shadowColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowColor = shadowColor;
            [self removeAnimationForKey:@"animateShadowColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowColor"];
    [CATransaction commit];
}

-(void)animateShadowOffset:(CGSize)shadowOffset {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.shadowOffset = shadowOffset;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOffset"];
    animation.fromValue = [NSValue valueWithCGSize:self.shadowOffset];
    animation.toValue = [NSValue valueWithCGSize:shadowOffset];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowOffset = shadowOffset;
            [self removeAnimationForKey:@"animateShadowOffset"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowOffset"];
    [CATransaction commit];
}

-(void)animateShadowOpacity:(CGFloat)shadowOpacity {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.shadowOpacity = shadowOpacity;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = @(self.shadowOpacity);
    animation.toValue = @(shadowOpacity);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowOpacity = shadowOpacity;
            [self removeAnimationForKey:@"animateShadowOpacity"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowOpacity"];
    [CATransaction commit];
}

-(void)animateShadowPath:(CGPathRef)shadowPath {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.shadowPath = shadowPath;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowPath"];
    animation.fromValue = (id)self.shadowPath;
    animation.toValue = (__bridge id)shadowPath;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowPath = shadowPath;
            [self removeAnimationForKey:@"animateShadowPath"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowPath"];
    [CATransaction commit];
}

-(void)animateShadowRadius:(CGFloat)shadowRadius {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.shadowRadius = shadowRadius;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowRadius"];
    animation.fromValue = @(self.shadowRadius);
    animation.toValue = @(shadowRadius);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowRadius = shadowRadius;
            [self removeAnimationForKey:@"animateShadowRadius"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowRadius"];
    [CATransaction commit];
}

-(void)animateZPosition:(CGFloat)zPosition {
    //the following if{} makes sure that the property is set immediately, rather than animating...
    //for small values of animationDuration, property might not have enough time to tighten itself up
    //uses _animationDuration because self.animationDuration returns + 0.0001f
    if(_animationDuration == 0.0f) {
        self.zPosition = zPosition;
        return;
    }
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"zPosition"];
    animation.fromValue = @(self.zPosition);
    animation.toValue = @(zPosition);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.zPosition = zPosition;
            [self removeAnimationForKey:@"animateZPosition"];
        }];
    }
    [self addAnimation:animation forKey:@"animateZPosition"];
    [CATransaction commit];
}



@end