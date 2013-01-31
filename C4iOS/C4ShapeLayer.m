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
//        self.strokeColor = (__bridge CGColorRef)(C4RED.CGColor);
//        self.fillColor = (__bridge CGColorRef)(C4BLUE.CGColor);
//        self.lineWidth = 5.0f;
//        self.repeatCount = 0;
//        self.autoreverses = NO;
        _currentAnimationEasing = [[NSString alloc] init];
        _currentAnimationEasing = (NSString *)kCAMediaTimingFunctionEaseInEaseOut;
        _allowsInteraction = NO;
        _repeats = NO;
        
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
//    C4Log(@"%@, %@, %@",NSStringFromSelector(_cmd),self,self.delegate);
    [self removeAllAnimations];
}

#pragma mark ShapeLayer Methods
/* encapsulating an animation that will correspond to the superview's animation */
-(void)animatePath:(CGPathRef)_path {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"path"];
    C4Log(@"dur:%4.2f",animation.duration);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.path = _path;
            [self removeAnimationForKey:@"path"];
        }];
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
        [CATransaction setCompletionBlock:^ {
            self.fillColor = _fillColor;
            [self removeAnimationForKey:@"fillColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateFillColor"];
    [CATransaction commit];
}

-(void)animateLineDashPhase:(CGFloat)_lineDashPhase {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineDashPhase"];
    animation.fromValue = @(self.lineDashPhase);
    animation.toValue = @(_lineDashPhase);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.lineDashPhase = _lineDashPhase;
            [self removeAnimationForKey:@"lineDashPhase"];
        }];
    }
    [self addAnimation:animation forKey:@"animateLineDashPhase"];
    [CATransaction commit];
}

-(void)animateLineWidth:(CGFloat)_lineWidth {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"lineWidth"];
    animation.fromValue = @(self.lineWidth);
    animation.toValue = @(_lineWidth);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.lineWidth = _lineWidth;
            [self removeAnimationForKey:@"lineWidth"];
        }];
    }
    [self addAnimation:animation forKey:@"animateLineWidth"];
    [CATransaction commit];
}

-(void)animateMiterLimit:(CGFloat)_miterLimit {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"miterLimit"];
    animation.fromValue = @(self.miterLimit);
    animation.toValue = @(_miterLimit);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.miterLimit = _miterLimit;
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

-(void)animateStrokeEnd:(CGFloat)_strokeEnd {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeEnd"];
    animation.fromValue = @(self.strokeEnd);
    animation.toValue = @(_strokeEnd);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.strokeEnd = _strokeEnd;
            [self removeAnimationForKey:@"strokeEnd"];
        }];
    }
    [self addAnimation:animation forKey:@"animateStrokeEnd"];
    [CATransaction commit];
}

-(void)animateStrokeStart:(CGFloat)_strokeStart {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"strokeStart"];
    animation.fromValue = @(self.strokeStart);
    animation.toValue = @(_strokeStart);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.strokeStart = _strokeStart;
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

-(void)animateBackgroundFilters:(NSArray *)_backgroundFilters {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"backgroundFilters"];
    animation.fromValue = self.backgroundFilters;
    animation.toValue = _backgroundFilters;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.backgroundFilters = _backgroundFilters;
            [self removeAnimationForKey:@"animateBackgroundFilters"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBackgroundFilters"];
    [CATransaction commit];
}

-(void)animateBorderWidth:(CGFloat)_borderWidth {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"borderWidth"];
    animation.fromValue = @(self.borderWidth);
    animation.toValue = @(_borderWidth);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.borderWidth = _borderWidth;
            [self removeAnimationForKey:@"animateBorderWidth"];
        }];
    }
    [self addAnimation:animation forKey:@"animateBorderWidth"];
    [CATransaction commit];
}

-(void)animateCompositingFilter:(id)_compositingFilter {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"compositingFilter"];
    animation.fromValue = self.compositingFilter;
    animation.toValue = _compositingFilter;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.compositingFilter = _compositingFilter;
            [self removeAnimationForKey:@"animateCompositingFilter"];
        }];
    }
    [self addAnimation:animation forKey:@"animateCompositingFilter"];
    [CATransaction commit];
}

-(void)animateCornerRadius:(CGFloat)_cornerRadius {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"cornerRadius"];
    animation.fromValue = @(self.cornerRadius);
    animation.toValue = @(_cornerRadius);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.cornerRadius = _cornerRadius;
            [self removeAnimationForKey:@"animateCornerRadius"];
        }];
    }
    [self addAnimation:animation forKey:@"animateCornerRadius"];
    [CATransaction commit];
}

-(void)animateLayerTransform:(CATransform3D)newTransform {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"sublayerTransform"];
    animation.fromValue = [NSValue valueWithCATransform3D:self.sublayerTransform];
    animation.toValue = [NSValue valueWithCATransform3D:newTransform];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.sublayerTransform = newTransform;
            [self removeAnimationForKey:@"sublayerTransform"];
        }];
    }
    [self addAnimation:animation forKey:@"sublayerTransform"];
    [CATransaction commit];
}

-(void)animateRotation:(CGFloat)newRotationAngle {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = @(self.rotationAngle);
    animation.toValue = @(newRotationAngle);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.rotationAngle = newRotationAngle;
            [self.delegate rotationDidFinish:newRotationAngle];
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

-(void)animateShadowColor:(CGColorRef)_shadowColor {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowColor"];
    animation.fromValue = (id)self.shadowColor;
    animation.toValue = (__bridge id)_shadowColor;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowColor = _shadowColor;
            [self removeAnimationForKey:@"animateShadowColor"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowColor"];
    [CATransaction commit];
}

-(void)animateShadowOffset:(CGSize)_shadowOffset {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOffset"];
    animation.fromValue = [NSValue valueWithCGSize:self.shadowOffset];
    animation.toValue = [NSValue valueWithCGSize:_shadowOffset];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowOffset = _shadowOffset;
            [self removeAnimationForKey:@"animateShadowOffset"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowOffset"];
    [CATransaction commit];
}

-(void)animateShadowOpacity:(CGFloat)_shadowOpacity {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowOpacity"];
    animation.fromValue = @(self.shadowOpacity);
    animation.toValue = @(_shadowOpacity);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowOpacity = _shadowOpacity;
            [self removeAnimationForKey:@"animateShadowOpacity"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowOpacity"];
    [CATransaction commit];
}

-(void)animateShadowPath:(CGPathRef)_shadowPath {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowPath"];
    animation.fromValue = (id)self.shadowPath;
    animation.toValue = (__bridge id)_shadowPath;
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowPath = _shadowPath;
            [self removeAnimationForKey:@"animateShadowPath"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowPath"];
    [CATransaction commit];
}

-(void)animateShadowRadius:(CGFloat)_shadowRadius {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"shadowRadius"];
    animation.fromValue = @(self.shadowRadius);
    animation.toValue = @(_shadowRadius);
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.shadowRadius = _shadowRadius;
            [self removeAnimationForKey:@"animateShadowRadius"];
        }];
    }
    [self addAnimation:animation forKey:@"animateShadowRadius"];
    [CATransaction commit];
}

-(void)animateZPosition:(CGFloat)_zPosition {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"zPosition"];
    animation.fromValue = @(self.zPosition);
    animation.toValue = @(_zPosition);
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
