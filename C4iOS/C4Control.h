//
//  C4Control.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>
enum {
    TAP = 0,
    PINCH,
    SWIPERIGHT,
    SWIPELEFT,
    SWIPEUP,
    SWIPEDOWN,
    ROTATION,
    PAN,
    LONGPRESS
};
typedef NSUInteger C4GestureType;

enum {
    SWIPEDIRRIGHT = UISwipeGestureRecognizerDirectionRight,
    SWIPEDIRLEFT = UISwipeGestureRecognizerDirectionLeft,
    SWIPEDIRUP = UISwipeGestureRecognizerDirectionUp ,
    SWIPEDIRDOWN = UISwipeGestureRecognizerDirectionDown
};
typedef UISwipeGestureRecognizerDirection C4SwipeDirection;


/*
 should add https://developer.apple.com/library/ios/#qa/qa1673/_index.html
 and animating along a path 
 */

@interface C4Control : UIControl <C4CommonMethods> {
}

#pragma mark Basic Gesture Methods
-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName;
-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName;
-(void)numberOfTouchesRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName;
-(void)setMinimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName;
-(void)setMaximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName;
-(void)setSwipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName;
-(void)setMinimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName;
-(void)touchesBegan;
-(void)move:(id)sender;
-(void)swipedRight;
-(void)swipedLeft;
-(void)swipedUp;
-(void)swipedDown;
-(void)pressedLong;

@property CGFloat animationDuration, animationDelay;
@property (nonatomic) NSUInteger animationOptions;
@property (nonatomic) CGFloat repeatCount;
@property (readonly, nonatomic) BOOL isAnimating;
@property (readonly, strong) NSMutableDictionary *gestureDictionary;
@end
