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
@synthesize origin = _origin;
@synthesize width, height;

-(id)init {
    self = [self initWithFrame:CGRectZero];
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.animationDuration = 0.0f;
        self.animationDelay = 0.0f;
        self.animationOptions = BEGINCURRENT;
        self.repeatCount = 0;
        [self setup];
    }
    return self;
}

-(void)addCamera:(C4Camera *)camera {
    C4Assert([camera isKindOfClass:[C4Camera class]],
             @"You tried to add a %@ using [canvas addCamera:]", [camera class]);
    [super addSubview:camera];
}

-(void)addShape:(C4Shape *)shape {
    C4Assert([shape isKindOfClass:[C4Shape class]],
             @"You tried to add a %@ using [canvas addShape:]", [shape class]);
    [super addSubview:shape];
}

-(void)addSubview:(UIView *)subview {
    C4Assert(![[subview class] isKindOfClass:[C4Camera class]], @"You just tried to add a C4Camera using the addSubview: method, please use addCamera:");
    C4Assert(![[subview class] isKindOfClass:[C4Shape class]], @"You just tried to add a C4Shape using the addSubview: method, please use addShape:");
    C4Assert(![[subview class] isKindOfClass:[C4Movie class]], @"You just tried to add a C4Movie using the addSubview: method, please use addMovie:");
    C4Assert(![[subview class] isKindOfClass:[C4Image class]], @"You just tried to add a C4Image using the addSubview: method, please use addImage:");
    C4Assert(![[subview class] isKindOfClass:[C4GL class]], @"You just tried to add a C4GL using the addSubview: method, please use addGL:");
    C4Assert(![[subview class] isKindOfClass:[C4Label class]], @"You just tried to add a C4Label using the addSubview: method, please use addLabel:");
    [super addSubview:subview];
}

-(void)addLabel:(C4Label *)label {
    C4Assert([label isKindOfClass:[C4Label class]], 
             @"You tried to add a %@ using [canvas addLabel:]", [label class]);
    [super addSubview:label];
}

-(void)addGL:(C4GL *)gl {
    C4Assert([gl isKindOfClass:[C4GL class]], 
             @"You tried to add a %@ using [canvas addGL:]", [gl class]);
    [super addSubview:gl];
}

-(void)addImage:(C4Image *)image {
    C4Assert([image isKindOfClass:[C4Image class]],
             @"You tried to add a %@ using [canvas addImage:]", [image class]);
    [super addSubview:image];
}

-(void)addMovie:(C4Movie *)movie {
    C4Assert([movie isKindOfClass:[C4Movie class]],
             @"You tried to add a %@ using [canvas addMovie:]", [movie class]);
    [super addSubview:movie];
}

-(void)addObjects:(NSArray *)array {
    for(id obj in array) {
        if([obj isKindOfClass:[C4Shape class]]) {
            [self addShape:obj];
        }
        else if([obj isKindOfClass:[C4GL class]]) {
            [self addGL:obj];
        }
        else if([obj isKindOfClass:[C4Image class]]) {
            [self addImage:obj];
        }
        else if([obj isKindOfClass:[C4Movie class]]) {
            [self addMovie:obj];
        }
        else if([obj isKindOfClass:[C4Camera class]]) {
            [self addCamera:obj];
        }
        else if([obj isKindOfClass:[UIView class]]) {
            [self addSubview:obj];
        }
        else {
            C4Log(@"unable to determine type of class");
        }
    }
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

-(CGPoint)center {
    CGPoint currentCenter = super.center;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        currentCenter.x = super.center.y;
        currentCenter.y = super.center.x;
    }
    return currentCenter;
}

-(void)setOrigin:(CGPoint)origin {
    _origin = origin;
    CGPoint difference = self.origin;
    difference.x += self.frame.size.width/2.0f;
    difference.y += self.frame.size.height/2.0f;
    self.center = difference;
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

//-(void)setContentStretch:(CGRect)contentStretch {
//    CGRect oldContentStretch = self.contentStretch;
//    [self animateWithBlock:^{
//        [super setContentStretch:contentStretch];
//    } completion:^(BOOL completed) {
//        if ((self.animationOptions & AUTOREVERSE) == AUTOREVERSE && completed) {
//            CGFloat oldDuration = self.animationDuration;
//            CGFloat oldDelay = self.animationDelay;
//            [super setContentStretch:oldContentStretch];
//            self.animationDuration = oldDuration;
//            self.animationDelay = oldDelay;
//        }
//    }];
//}

-(void)animateWithBlock:(void (^)(void))animationBlock {
    [self animateWithBlock:animationBlock completion:nil];
}

-(void)animateWithBlock:(void (^)(void))animationBlock completion:(void (^)(BOOL))completionBlock {
    [UIView animateWithDuration:self.animationDuration
                          delay:(NSTimeInterval)self.animationDelay
                        options:self.animationOptions
                     animations:animationBlock
                     completion:completionBlock];
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    /*
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    ((id <C4LayerAnimation>)self.layer).animationOptions = _animationOptions;
    
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
//        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    
    _animationOptions = animationOptions | BEGINCURRENT;
}

#pragma mark Notification Methods
-(void)setup {}

-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:nil];
}

-(void)listenFor:(NSString *)notification fromObject:(id)object andRunMethod:(NSString *)methodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
}

-(void)listenFor:(NSString *)notification fromObjects:(NSArray *)objectArray andRunMethod:(NSString *)methodName {
    for(id object in objectArray) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
    }
}

-(void)stopListeningFor:(NSString *)methodName {
    [self stopListeningFor:methodName object:nil];
}

-(void)stopListeningFor:(NSString *)methodName object:(id)object {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
}

-(void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {
    for(id object in objectArray) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
    }
}

-(void)postNotification:(NSString *)notification {
	[[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

-(CGFloat)width {
    return self.bounds.size.width;
}

-(CGFloat)height {
    return self.bounds.size.height;
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

-(void)removeObject:(C4Control *)visibleObject {
    [visibleObject removeFromSuperview];
}

@end
