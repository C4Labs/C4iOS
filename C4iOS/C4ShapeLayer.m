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
@synthesize animationOptions = _animationOptions, currentAnimationEasing, repeatCount, animationDuration = _animationDuration;
@synthesize allowsInteraction, repeats;
@synthesize rotationAngle, rotationAngleX, rotationAngleY;
@synthesize perspectiveDistance = _perspectiveDistance;

-(id)init {
    self = [super init];
    if(self != nil) {
        self.name = @"shapeLayer";
        self.strokeColor = C4RED.CGColor;
        self.fillColor = C4BLUE.CGColor;
        self.lineWidth = 5.0f;
        self.repeatCount = 0;
        self.autoreverses = NO;
        currentAnimationEasing = [[NSString alloc] init];
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
        [CATransaction setCompletionBlock:^ { 
            self.shadowColor = _shadowColor; 
            [self removeAnimationForKey:@"shadowColor"];
        }];
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
        [CATransaction setCompletionBlock:^ { 
            self.shadowOpacity = _shadowOpacity; 
            [self removeAnimationForKey:@"shadowOpacity"];
        }];
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
        [CATransaction setCompletionBlock:^ { 
            self.shadowRadius = _shadowRadius; 
            [self removeAnimationForKey:@"shadowRadius"];
        }];
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
        [CATransaction setCompletionBlock:^ { 
            self.shadowOffset = _shadowOffset; 
            [self removeAnimationForKey:@"shadowOffset"];
        }];
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
        [CATransaction setCompletionBlock:^ { 
            self.shadowPath = _shadowPath; 
            [self removeAnimationForKey:@"shadowPath"];
        }];
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
        [CATransaction setCompletionBlock:^ { 
            self.backgroundFilters = _backgroundFilters; 
            [self removeAnimationForKey:@"backgroundFilters"];
        }];
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
        [CATransaction setCompletionBlock:^ { 
            self.compositingFilter = _compositingFilter; 
            [self removeAnimationForKey:@"compositingFilter"];
        }];
    }
    [self addAnimation:animation forKey:@"animateCompositingFilter"];
    [CATransaction commit];
}

//-(BOOL)isOpaque {
//    /*
//     Apple docs say that the frameworks flip this to NO automatically 
//     ...if you do things like set the background color to anything transparent
//     */
//    return YES;
//}

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
    animation.fromValue = [NSNumber numberWithFloat:self.lineDashPhase];
    animation.toValue = [NSNumber numberWithFloat:_lineDashPhase];
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
    animation.fromValue = [NSNumber numberWithFloat:self.lineWidth];
    animation.toValue = [NSNumber numberWithFloat:_lineWidth];
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
    animation.fromValue = [NSNumber numberWithFloat:self.miterLimit];
    animation.toValue = [NSNumber numberWithFloat:_miterLimit];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.miterLimit = _miterLimit;
            [self removeAnimationForKey:@"miterLimit"]; 
        }];
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
        [CATransaction setCompletionBlock:^ { 
            self.strokeColor = _strokeColor; 
            [self removeAnimationForKey:@"strokeColor"];
        }];
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
    animation.fromValue = [NSNumber numberWithFloat:self.strokeStart];
    animation.toValue = [NSNumber numberWithFloat:_strokeStart];
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

//-(void)setStyle:(NSDictionary *)style {
//    C4Log(@"C4ShapeLayer setStyle not currently available");
//    for(NSString *s in [style allKeys]) {
//        C4Log(@"%@, %@", [style objectForKey:s], s);
//    }
//    [super setStyle:style];
//}

//-(void)setZPosition:(CGFloat)zPosition {
//    C4Log(@"C4ShapeLayer setZPosition not currently available");
//}

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

-(void)setPerspectiveDistance:(CGFloat)perspectiveDistance {
    _perspectiveDistance = perspectiveDistance;
    CATransform3D t = self.transform;
    if(perspectiveDistance != 0.0f) t.m34 = 1/self.perspectiveDistance;
    else t.m34 = 0.0f;
    self.transform = t;
}

-(void)animateRotation:(CGFloat)_rotationAngle {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.z"];
    animation.fromValue = [NSNumber numberWithFloat:self.rotationAngle];
    animation.toValue = [NSNumber numberWithFloat:_rotationAngle];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.rotationAngle = _rotationAngle;
            [self.delegate rotationDidFinish:_rotationAngle];
            [self removeAnimationForKey:@"animateRotationZ"];
        }];
    }
    [self addAnimation:animation forKey:@"animateRotationZ"];
    [CATransaction commit];
}

-(void)animateRotationX:(CGFloat)_rotationAngle {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.x"];
    animation.fromValue = [NSNumber numberWithFloat:self.rotationAngleX];
    animation.toValue = [NSNumber numberWithFloat:_rotationAngle];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.transform = CATransform3DRotate(self.transform, _rotationAngle - self.rotationAngleX, 1, 0, 0);
            self.rotationAngleX = _rotationAngle;
            [self removeAnimationForKey:@"animateRotationX"];
        }];
    }
    [self addAnimation:animation forKey:@"animateRotationX"];
    [CATransaction commit];
}

-(void)animateRotationY:(CGFloat)_rotationAngle {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform.rotation.y"];
    animation.fromValue = [NSNumber numberWithFloat:self.rotationAngleY];
    animation.toValue = [NSNumber numberWithFloat:_rotationAngle];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.transform =    CATransform3DRotate(self.transform, _rotationAngle - self.rotationAngleY, 0, 1, 0);
            self.rotationAngleY = _rotationAngle;
            [self removeAnimationForKey:@"animateRotationY"];
        }];
    }
    [self addAnimation:animation forKey:@"animateRotationY"];
    [CATransaction commit];
}

-(void)animateLayerTransform:(CATransform3D)_transform {
    [CATransaction begin];
    CABasicAnimation *animation = [self setupBasicAnimationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:self.sublayerTransform];
    animation.toValue = [NSValue valueWithCATransform3D:_transform];
    if (animation.repeatCount != FOREVER && !self.autoreverses) {
        [CATransaction setCompletionBlock:^ { 
            self.transform = _transform; 
            [self removeAnimationForKey:@"animateTransform"];
        }];
    }
    [self addAnimation:animation forKey:@"animateTransform"];
    [CATransaction commit];
}

@end
