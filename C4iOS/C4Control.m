//
//  C4Control.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Control.h"

@interface C4Control() 
-(void)animateWithBlock:(void (^)(void))blockAnimation;
-(void)animateWithBlock:(void (^)(void))blockAnimation completion:(void (^)(BOOL))completionBlock;
@end

@implementation C4Control

/* leaving animation delay only to views for now */
@synthesize animationDuration, animationDelay, animationOptions = _animationOptions, repeatCount = _repeatCount;
@synthesize gestureDictionary;

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.animationDuration = 0.0f;
        self.animationDelay = 0.0f;
        self.repeatCount = 0;
    }
    return self;
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
    UIColor *oldBackgroundColor = [self.backgroundColor copy];
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

-(void)setContentStretch:(CGRect)contentStretch {
    CGRect oldContentStretch = self.contentStretch;
    [self animateWithBlock:^{
        [super setContentStretch:contentStretch];
    } completion:^(BOOL completed) {
        if ((self.animationOptions & AUTOREVERSE) == AUTOREVERSE && completed) {
            CGFloat oldDuration = self.animationDuration;
            CGFloat oldDelay = self.animationDelay;
            [super setContentStretch:oldContentStretch];
            self.animationDuration = oldDuration;
            self.animationDelay = oldDelay;
        }
    }];
}

-(void)animateWithBlock:(void (^)(void))animationBlock {
    [self animateWithBlock:animationBlock completion:nil];
};

-(void)animateWithBlock:(void (^)(void))animationBlock completion:(void (^)(BOOL))completionBlock {
    [UIView animateWithDuration:self.animationDuration
                          delay:(NSTimeInterval)self.animationDelay
                        options:self.animationOptions
                     animations:animationBlock
                     completion:completionBlock];
};

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    _animationOptions = animationOptions | UIViewAnimationOptionBeginFromCurrentState;
}

-(BOOL)isAnimating {
    return [self.layer.animationKeys count];
}

-(void)move:(id)sender {
    CGFloat _ani = self.animationOptions;
    CGFloat _dur = self.animationDuration;
    CGFloat _del = self.animationDelay;
    self.animationDuration = 0;
    self.animationDelay = 0;
    self.animationOptions = 0;
    CGPoint tranlatedPoint = [(UIPanGestureRecognizer *)sender locationInView:self];
    self.center = CGPointMake(self.center.x + tranlatedPoint.x - self.frame.size.width/2.0f, self.center.y+tranlatedPoint.y-self.frame.size.height/2.0f);
    self.animationDuration = _dur;
    self.animationDelay = _del;
    self.animationOptions = _ani;
}

#pragma mark Gesture Methods

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {
    if(gestureDictionary == nil) gestureDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    UIGestureRecognizer *recognizer;
    switch (type) {
        case TAP:
            recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
            break;
        case PAN:
            recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
            break;
        case SWIPERIGHT:
            recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
            ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRRIGHT;
            break;
        case SWIPELEFT:
            recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
            ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRLEFT;
            break;
        case SWIPEUP:
            recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
            ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRUP;
            break;
        case SWIPEDOWN:
            recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
            ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRDOWN;
            break;
        case LONGPRESS:
            recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
            ((UILongPressGestureRecognizer *)recognizer).minimumPressDuration = 1.0f;
        default:
            break;
    }
    [self addGestureRecognizer:recognizer];
}

-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        ((UITapGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
    else if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        ((UILongPressGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
    }
}

-(void)numberOfTouchesRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        ((UITapGestureRecognizer *) recognizer).numberOfTouchesRequired = tapCount;
    else if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]])
        ((UISwipeGestureRecognizer *) recognizer).numberOfTouchesRequired = tapCount;
    else if([recognizer isKindOfClass:[UILongPressGestureRecognizer class]])
        ((UILongPressGestureRecognizer *) recognizer).numberOfTouchesRequired = tapCount;
}

-(void)setMinimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UITapGestureRecognizer class]])
        ((UILongPressGestureRecognizer *) recognizer).minimumPressDuration = duration;
}
  
-(void)setMinimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
        ((UIPanGestureRecognizer *) recognizer).minimumNumberOfTouches = touchCount;
}

-(void)setMaximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UIPanGestureRecognizer class]])
        ((UIPanGestureRecognizer *) recognizer).maximumNumberOfTouches = touchCount;
}

-(void)setSwipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [gestureDictionary objectForKey:gestureName];
    if([recognizer isKindOfClass:[UISwipeGestureRecognizer class]])
        ((UISwipeGestureRecognizer *) recognizer).direction = direction;
}

#pragma mark Common Methods
-(void)setup {}

-(void)listenFor:(NSString *)aNotification andRunMethod:(NSString *)aMethodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(aMethodName) name:aNotification object:nil];
}

-(void)listenFor:(NSString *)aNotification fromObject:(id)anObject andRunMethod:(NSString *)aMethodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(aMethodName) name:aNotification object:anObject];
}

-(void)stopListeningFor:(NSString *)aMethodName {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:aMethodName object:nil];
}

-(void)postNotification:(NSString *)aNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:aNotification object:self];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self postNotification:@"touchesBegan"];
    [self touchesBegan];
}
-(void)touchesBegan {
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self postNotification:@"touchesMoved"];
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self postNotification:@"touchesEnded"];
    [super touchesEnded:touches withEvent:event];
}

@end

