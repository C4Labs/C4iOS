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
@property (readwrite, nonatomic) CGFloat rotationAngle, rotationAngleX, rotationAngleY;
@end

@implementation C4ShapeLayer
@synthesize animationOptions = _animationOptions, currentAnimationEasing = _currentAnimationEasing, repeatCount = _repeatCount, animationDuration = _animationDuration, allowsInteraction = _allowsInteraction, repeats = _repeats;
@synthesize perspectiveDistance = _perspectiveDistance;

-(id)init {
    self = [super init];
    if(self != nil) {
        self.name = @"shapeLayer";
        _animationDuration = 0.0f;
        _currentAnimationEasing = [[NSString alloc] init];
        _currentAnimationEasing = (NSString *)kCAMediaTimingFunctionEaseInEaseOut;
        _allowsInteraction = NO;
        _repeats = NO;
        
        /* create basic attributes after setting animation attributes above */
        CGPathRef newPath = CGPathCreateWithRect(CGRectZero, nil);
        self.path = newPath;
        [self setActions:@{@"animateRotation":[NSNull null]}];

        /* makes sure there are no extraneous animation keys lingering about after init */
        [self removeAllAnimations];
        CFRelease(newPath);
   }
    return self;
}

-(void)dealloc {
//    C4Log(@"%@, %@, %@",NSStringFromSelector(_cmd),self,self.delegate);
    [self removeAllAnimations];
}

#pragma mark ShapeLayer Methods
/* encapsulating an animation that will correspond to the superview's animation */
-(void)animatePath:(CGPathRef)path {
        [CATransaction begin];
        CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"path"];
        if (animation.repeatCount != FOREVER && !self.autoreverses) {
            [CATransaction setCompletionBlock:^ {
                self.path = path;
                [self removeAnimationForKey:@"path"];
            }];
        }
        animation.fromValue = (id)self.path;
        animation.toValue = (__bridge id)path;
        [self addAnimation:animation forKey:@"animatePath"];
        [CATransaction commit];
}

-(void)animateFillColor:(CGColorRef)fillColor {
        [CATransaction begin];
        CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"fillColor"];
        animation.fromValue = (id)self.fillColor;
        animation.toValue = (__bridge id)fillColor;
        if (animation.repeatCount != FOREVER && !self.autoreverses) {
            [CATransaction setCompletionBlock:^ {
                self.fillColor = fillColor;
                [self removeAnimationForKey:@"fillColor"];
            }];
        }
        [self addAnimation:animation forKey:@"animateFillColor"];
        [CATransaction commit];
}

-(void)animateLineDashPhase:(CGFloat)lineDashPhase {
        [CATransaction begin];
        CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineDashPhase"];
        animation.fromValue = @(self.lineDashPhase);
        animation.toValue = @(lineDashPhase);
        if (animation.repeatCount != FOREVER && !self.autoreverses) {
            [CATransaction setCompletionBlock:^ {
                self.lineDashPhase = lineDashPhase;
                [self removeAnimationForKey:@"lineDashPhase"];
            }];
        }
        [self addAnimation:animation forKey:@"animateLineDashPhase"];
        [CATransaction commit];
}

-(void)animateLineWidth:(CGFloat)lineWidth {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineWidth"];
    animation.fromValue = @(self.lineWidth);
    animation.toValue = @(lineWidth);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.lineWidth = lineWidth;
            [self removeAnimationForKey:@"lineWidth"];
        }];
    }
    [self addAnimation:animation forKey:@"animateLineWidth"];
    [CATransaction commit];
}

-(void)animateMiterLimit:(CGFloat)miterLimit {
        [CATransaction begin];
        CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"miterLimit"];
        animation.fromValue = @(self.miterLimit);
        animation.toValue = @(miterLimit);
        if (animation.repeatCount != FOREVER && !self.autoreverses) {
            [CATransaction setCompletionBlock:^ {
                self.miterLimit = miterLimit;
                [self removeAnimationForKey:@"miterLimit"];
            }];
        }
        [self addAnimation:animation forKey:@"animateMiterLimit"];
        [CATransaction commit];
}

-(void)animateStrokeColor:(CGColorRef)strokeColor {
        [CATransaction begin];
        CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeColor"];
        animation.fromValue = (id)self.strokeColor;
        animation.toValue = (__bridge id)strokeColor;
        if (animation.repeatCount != FOREVER && !self.autoreverses) {
            [CATransaction setCompletionBlock:^ {
                self.strokeColor = strokeColor;
                [self removeAnimationForKey:@"strokeColor"];
            }];
        }
        
        [self addAnimation:animation forKey:@"animateStrokeColor"];
        [CATransaction commit];
}

-(void)animateStrokeEnd:(CGFloat)strokeEnd {
        [CATransaction begin];
        CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeEnd"];
        animation.fromValue = @(self.strokeEnd);
        animation.toValue = @(strokeEnd);
        if (animation.repeatCount != FOREVER && !self.autoreverses) {
            [CATransaction setCompletionBlock:^ {
                self.strokeEnd = strokeEnd;
                [self removeAnimationForKey:@"strokeEnd"];
            }];
        }
        [self addAnimation:animation forKey:@"animateStrokeEnd"];
        [CATransaction commit];
}

-(void)animateStrokeStart:(CGFloat)strokeStart {
        [CATransaction begin];
        CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeStart"];
        animation.fromValue = @(self.strokeStart);
        animation.toValue = @(strokeStart);
        if (animation.repeatCount != FOREVER && !self.autoreverses) {
            [CATransaction setCompletionBlock:^ {
                self.strokeStart = strokeStart;
                [self removeAnimationForKey:@"strokeStart"];
            }];
        }
        [self addAnimation:animation forKey:@"animateStrokeStart"];
        [CATransaction commit];
}

#pragma mark Blocked Methods

-(void)setContentsGravity:(NSString *)contentsGravity {
    contentsGravity = contentsGravity;
    C4Log(@"C4ShapeLayer setContentsGravity not currently available");
}

-(void)setHidden:(BOOL)hidden {
    hidden = hidden;
    C4Log(@"C4ShapeLayer setHidden not currently available");
}

-(void)setDoubleSided:(BOOL)doubleSided {
    doubleSided = doubleSided;
    C4Log(@"C4ShapeLayer setDoubleSided not currently available");
}

-(void)setMinificationFilter:(NSString *)minificationFilter {
    minificationFilter = minificationFilter;
    C4Log(@"C4ShapeLayer setMinificationFilter not currently available");
}

-(void)setMinificationFilterBias:(float)minificationFilterBias {
    minificationFilterBias = minificationFilterBias;
    C4Log(@"C4ShapeLayer setMinificationFilterBias not currently available");
}

-(void)animateContents:(CGImageRef)image {
    image = image;
    C4Log(@"C4ShapeLayer animateContents not currently available");
    //    [CATransaction begin];
    //    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"contents"];
    //    animation.fromValue = self.contents;
    //    animation.toValue = (__bridge id)_image;
    //    if (animation.repeatCount != FOREVER && !self.autoreverses) {
    //        [CATransaction setCompletionBlock:^ {
    //            self.contents = (__bridge id)_image;
    //            [self removeAnimationForKey:@"animateContents"];
    //        }];
    //    }
    //    [self addAnimation:animation forKey:@"animateContents"];
    //    [CATransaction commit];
}

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

-(void)animateCornerRadius:(CGFloat)cornerRadius {
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
