//
//  C4Control.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 should add https://developer.apple.com/library/ios/#qa/qa1673/_index.html
 and animating along a path 
 */

@interface C4Control : UIControl <C4Notification, C4Gesture> {
}

-(void)setup;
-(void)test;

@property CGFloat animationDuration, animationDelay;
@property (nonatomic) NSUInteger animationOptions;
@property (nonatomic) CGFloat repeatCount;
@property (readonly, strong) NSMutableDictionary *gestureDictionary;
@property (nonatomic) CGPoint origin;

@end

/*
 -(id)initWithFrame:(CGRect)frame {
 }

#pragma mark UIView animatable property overrides

-(void)setCenter:(CGPoint)center {
}

-(void)setOrigin:(CGPoint)origin {
}

-(void)setFrame:(CGRect)frame {
}

-(void)setBounds:(CGRect)bounds {
}

-(void)setTransform:(CGAffineTransform)transform {
}

-(void)setAlpha:(CGFloat)alpha {
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
}

-(void)setContentStretch:(CGRect)contentStretch {
}

#pragma mark Animation methods
-(void)animateWithBlock:(void (^)(void))animationBlock {
};

-(void)animateWithBlock:(void (^)(void))animationBlock completion:(void (^)(BOOL))completionBlock {
};

-(void)setAnimationOptions:(NSUInteger)animationOptions {
}


#pragma mark Move
-(void)move:(id)sender {
}

#pragma mark Gesture Methods

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {
}

-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {
}

-(void)numberOfTouchesRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {
                }

-(void)setMinimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {
        }

-(void)setMinimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
        }

-(void)setMaximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
        }

-(void)setSwipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {
        }

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
}

-(void)touchesBegan {
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self postNotification:@"touchesMoved"];
    [super touchesMoved:touches withEvent:event];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
}


-(void)swipedRight {
}

-(void)swipedLeft {
}

-(void)swipedUp {
}

-(void)swipedDown {
}

-(void)pressedLong {
}

#pragma mark Test
-(void)test {
}

#pragma mark Notification Methods
-(void)setup {}

-(void)listenFor:(NSString *)aNotification andRunMethod:(NSString *)aMethodName {
}

-(void)listenFor:(NSString *)aNotification fromObject:(id)object andRunMethod:(NSString *)aMethodName {
}

-(void)stopListeningFor:(NSString *)aMethodName {
}

-(void)postNotification:(NSString *)aNotification {
}
@end
*/
