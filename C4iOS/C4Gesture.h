//
//  C4Gesture.h
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

/** C4Gesture protocol groups methods that are fundamental to basic interaction with all C4 objects which have a visible, on-screen presence.
 
 If an object conforms to this protocol, it can be considered as an interactive object which can respond to gestures.
 
 The C4 Framework is built with the idea that all visible objects have the ability to be interactive. In doing so, all visible objects will be subclasses of C4Control. Furthermore, because C4Control implements the C4Gesture protocol, all visible objects within C4 also conform to the methods defined below. 
 
 @warning *Note:* It is assumed that the object which includes this protocol is a subclass of [UIView](UIView).
*/
@protocol C4Gesture <NSObject>
#pragma mark Gesture Methods
/// @name Gesture Methods
/** Adds a gesture to an object.
 
 From the input parameters, this method constructs a gesture recognizer and adds it to the object from which it was called.
 
 Internally, this method creates a UIGestureRecognizer which it then uses as the main parameter when calling addGestureRecognizer:
  
 @param type defines the type of gesture that will be added, should be one of C4GestureType (e.g. TAP, PINCH, SWIPERIGHT, SWIPELEFT, SWIPEUP, SWIPEDOWN, ROTATION, PAN, LONGPRESS).
 @param gestureName a string (can be anything) which identifies the current gesture, so that it can be accessed later on.
 @param methodName a string which represents the name of a method defined in the object's class or any of its superclasses, this parameter should be written as a string (e.g. @"test", @"changePosition:")
 
 @warning *Note:* The methods being called by this object should take either no messages (e.g. -(void)test {}) or a single message defined as (id)sender (e.g. -(void)move:(id)sender {}). 
 
 In the case of a method such as aMethod:(id)sender it is assumed that the sender object is of the type UIGestureRecognizer or any of its subclasses. From this assumption it is safe to assume that the sender can be cast to the appropriate type, such as UIPanGestureRecognizer depending on the original C4GestureType specified in the _type_ parameter. 
 */
-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName;

/** Specifies the number of taps required for a given gesture. 
 
 This method should work only for the gesture types: TAP and LONGPRESS
 
 @param tapCount the desired number of required taps
 @param gestureName a string identifying the gesture upon which this method should act. The value of _gestureName_ should correspond to the name of a gesture already added using the addGesture:name:action: method
 */
-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName;

/** Specifies the number of touches required for a given gesture. 
 
 This method should work only for the gesture types: TAP, SWIPE and LONGPRESS
 
 @param touchCount the desired number of required touches
 @param gestureName a string identifying the gesture upon which this method should act. The value of _gestureName_ should correspond to the name of a gesture already added using the addGesture:name:action: method
 */
-(void)numberOfTouchesRequired:(NSInteger)touchCount forGesture:(NSString *)gestureName;

/** Specifies the minimum number of touches required for a given gesture. 
 
 This method should work only for the gesture type: PAN
 
 @param touchCount the desired minimum number of touches
 @param gestureName a string identifying the gesture upon which this method should act. The value of _gestureName_ should correspond to the name of a gesture already added using the addGesture:name:action: method
 */
-(void)setMinimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName;

/** Specifies the maximum number of touches required for a given gesture. 
 
 This method should work only for the gesture type: PAN
 
 @param touchCount the desired maximum number of touches
 @param gestureName a string identifying the gesture upon which this method should act. The value of _gestureName_ should correspond to the name of a gesture already added using the addGesture:name:action: method
 */
-(void)setMaximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName;

/** Specifies the direction for a given swipe gesture. 
 
 This method should work only for the gesture types: SWIPELEFT, SWIPERIGHT, SWIPEUP, and SWIPEDOWN
 
 @param touchCount the desired maximum number of touches
 @param gestureName a string identifying the gesture upon which this method should act. The value of _gestureName_ should correspond to the name of a gesture already added using the addGesture:name:action: method

 @warning *Note:* There can be only 1 direction associated with a given gesture and are set up by default. For example, the default direction for a gesture created with the type SWIPELEFT is SWIPEDIRLEFT. You should not have to call this method explicitly.
 
 */
-(void)setSwipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName;

/** Specifies the direction for a given swipe gesture. 
 
 This method should work only for the gesture type: LONGPRESS
  
 @param duration the desired number of seconds (defaults to 0.5)
 @param gestureName a string identifying the gesture upon which this method should act. The value of _gestureName_ should correspond to the name of a gesture already added using the addGesture:name:action: method
 */
-(void)setMinimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName;

#pragma mark Basic Touch Methods
/// @name Basic Touch Methods

/** Method which is called each time an object is touched
 
 This method is a simplified version of touchesBegan:withEvent: which can be called to trigger other custom actions or events.
 
 @warning *Note:* If direct access to the event and set of touches is needed, it is possible to override touchesBegan:withEvent: making sure to call _super touchesBegan:withEvent:_
 */
-(void)touchesBegan;

/** Method which is called each time an object is finished being touched
 
 This method is a simplified version of touchesEnded:withEvent: which can be called to trigger other custom actions or events.
 
 @warning *Note:* If direct access to the event and set of touches is needed, it is possible to override touchesEnded:withEvent: making sure to call _super touchesEnded:withEvent:_
 */
-(void)touchesEnded;

/** Method which is called each time touches associated with an object are moved
 
 This method is a simplified version of touchesMoved:withEvent: which can be overridden to trigger other custom actions or events.
 
 @warning *Note:* If direct access to the event and set of touches is needed, it is possible to override touchesEnded:withEvent: making sure to call _super touchesMoved:withEvent:_
 */
-(void)touchesMoved;

/** Method which is called each time an object receives a long press
 
 This method can be overridden to trigger other custom actions or events.
 
 If a LONGPRESS gesture has been added to an object, and the object receives a long press notification, this method is triggered.
 */
-(void)pressedLong;

#pragma mark Basic Swipe Methods
/// @name Basic Swipe Methods
/** Method which is called each time an object receives a swipe from left to right

 This method can be overridden to trigger other custom actions or events.
*/
-(void)swipedRight;

/** Method which is called each time an object receives a swipe from right to left
 
 This method can be overridden to trigger other custom actions or events.
 */
-(void)swipedLeft;

/** Method which is called each time an object receives a swipe from down to up
 
 This method can be overridden to trigger other custom actions or events.
 */
-(void)swipedUp;

/** Method which is called each time an object receives a swipe from up to down
 
 This method can be overridden to trigger other custom actions or events.
 */
-(void)swipedDown;

/** A default method which can be called when using a PAN gesture, if the object is to follow a moving touch
 
 This method can be overridden to trigger other custom actions or events.
 
 @warning *Note:* In its default implementation, it is assumed that PAN is the only kind of gesture which will call this method.
 */
-(void)move:(id)sender;
@end
