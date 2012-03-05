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

UIControl is the base class for control objects such as buttons and sliders that convey user intent to the application. You cannot use the UIControl class directly to instantiate controls. It instead defines the common interface and behavioral structure for all its subclasses.

The main role of UIControl is to define an interface and base implementation for preparing action messages and initially dispatching them to their targets when certain events occur.

For an overview of the target-action mechanism, see “Target-Action in UIKit” in Cocoa Fundamentals Guide. For information on the Multi-Touch event model, see Event Handling Guide for iOS.

The UIControl class also includes methods for getting and setting control state—for example, for determining whether a control is enabled or highlighted—and it defines methods for tracking touches within a control. These tracking methods are overridden by UIControl subclasses.


/** C4Control is the base class for almost all objects that have visual representations. Because of the interactive nature of C4, where all objects have the flexibility of enabling user interaction, it makes sense to have them all as basic subclasses of UIControl rather than UIView.

 The main rold of C4Control is to define 
 
 @return C4Window a subclass of UIWindow customized specifically for the C4 Framework
 */

@interface C4Control : UIControl <C4NotificationMethods, C4GestureMethods> {
}

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

-(void)listenFor:(NSString *)aNotification fromObject:(id)anObject andRunMethod:(NSString *)aMethodName {
}

-(void)stopListeningFor:(NSString *)aMethodName {
}

-(void)postNotification:(NSString *)aNotification {
}
@end
*/
