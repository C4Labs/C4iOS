//
//  C4GestureMethods.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-28.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

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

#import <Foundation/Foundation.h>

@protocol C4GestureMethods <NSObject>
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
@end
