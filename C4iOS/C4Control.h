//
//  C4Control.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

/*
 should add https://developer.apple.com/library/ios/#qa/qa1673/_index.html
 and animating along a path
 */

#import <UIKit/UIKit.h>

/** The C4Control is a subclass of UIControl, which is the base class for control objects such as buttons and sliders that convey user intent to the application. You cannot use the UIControl class directly to instantiate controls. It instead defines the common interface and behavioral structure for all its subclasses.
 
 In C4, the main role of C4Control is to provide all objects that have a visible representation the ability to receive and handle user interaction. Because we cannot chain subclasses, C4Control mimicks some functionality with is available for C4Views.
 
 Anything visible in a C4 application is a subclass of C4Control. So, in this sense, you should never have to construct a C4Control yourself. Instead, choose the appropriate C4 object, which if visible will be a descendant of a C4Control, and work from there.
 
 C4Controls have custom animation options property which allows for setting of basic characteristics such as AUTOREVERSE, REPEAT, as well as delays and durations. These properties are:
 
 - animationDelay
 - animationDuration
 - animationOptions

 C4Control conforms to the C4Notification protocol which means that all controls will have the ability to post and receive notifications. Furthermore, C4Control defines basic methods that deal with basic animations for the following properties:
 
 - center
 - frame
 - bounds
 - transform
 - alpha
 - backgroundColor
 - contentStretch
 
 @warning For more information on the above properties, consult the [UIView](UIView) class documentation.

 */

@interface C4Control : UIControl <C4Notification, C4Gesture> {
}

/// @name Convenience Methods

/** A method to call instead of overriding any of the standard initializers.
 
 It is easier and safer to override this method than to override something like -(id)init, or -(id)initWithFrame, etc...
  */
-(void)setup;

/** A method to call when you want to test simple things.
 
 Override this method to test small bits of fuctionality. For example, you could call this method to make sure another call is working by doing the following in the .m file of your subclass:
 
 -(void)test {
    C4Log(@"test was run");
 }
 */
-(void)test;

/// @name Setting A Control's Origin Point
/** The origin point of the view.

 Takes a CGPoint and animates the view's origin position from its current point to the new point.
 
 This method positions the origin point of the current view by calculating the difference between this point and what the view's new center point will be. It then initiates the animation by setting the displaced new center point. 
 */
@property (nonatomic) CGPoint origin;

#pragma mark Animation Properties
/// @name Configuring A Control's Animation Properties

/** The duration of the view's animations, measured in seconds.
  
 All animations that occur will use this value as their duration.
 
 For immediate animations set this property to 0.0f;
 
 Defaults to 0.0f
 
 */
@property (nonatomic) CGFloat animationDuration;

/** The time to wait before the view's animations begin, measured in seconds.
 
 All animations that occur will use this value as their delay.
 
 For immediate animations set this property to 0.0f;
 
 Defaults to 0.0f
 */
@property CGFloat animationDelay;

/** The options for which the view should use in its animations.
 
 An integer which can be constructed from bitmasked values
 
 The available animation options are a limited subset of UIViewAnimationOptions and include:
 - ALLOWSINTERACTION
 - BEGINCURRENT (default)
 - REPEAT
 - AUTOREVERSE
 - EASEINOUT
 - EASEIN
 - EASEOUT
 - LINEAR 
 
 This value can have a variety of options attached to it by using integer bitmasks. For example, to set an animation which will auto reverse and repeat:
 view.animationOptions = AUTOREVERSE | REPEAT;
 
 @warning *Note:* All animation options should be set at the same time using the | bitmask operator. Animation options should never be set in the following way:
 view.animationOptions = AUTOREVERSE;
 view.animationOptions = REPEAT;
 */
@property (nonatomic) NSUInteger animationOptions;

/** The number of times an animation autorepeats.
 
 @warning *Note:* This parameter is currently unused.
 */
@property (nonatomic) CGFloat repeatCount;

#pragma mark Inherited methods
///@name Inherited Methods

@end
