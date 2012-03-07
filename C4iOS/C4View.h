//
//  C4View.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>
/** The C4View is a subclass of UIView, which defines a rectangular area on the screen and the interfaces for managing the content in that area. At runtime, a view object handles the rendering of any content in its area and also handles any interactions with that content. The C4View class itself provides basic behavior for filling its rectangular area with a background color.
 
 Because view objects are the main way your application interacts with the user, they have a number of responsibilities. Here are just a few:
 
 Anything visible in a C4 application is a subclass of C4View. So, in this sense, you should never have to construct a C4View yourself. Instead, choose the appropriate C4 object, which if visible will be a descendant of a C4View, and work from there.

 C4Views conform to the C4Notification protocol which means that all views will have the ability to post and receive notifications. Furthermore, C4View defines basic methods that deal with basic animations for the following properties:
 
 @property center
 @property frame
 @property bounds
 @property transform
 @property alpha
 @property backgroundColor
 @property contentStretch
 
 @warning *NOTE:* For more information on the above properties, consult the UIView class documentation.
 
 C4Views also have a custom animation options property which allows for setting of basic characteristics such as AUTOREVERSE, REPEAT, as well as delays and durations. These properties are:
 
 @property animationDelay
 @property animationDuration
 @property animationOptions
 */
@interface C4View : UIView <C4Notification> {
}

///---------------------------------------------------------------------------------------
/// @name Adding Object Methods
///---------------------------------------------------------------------------------------
#pragma mark Adding Objects
/** Adds a C4Shape to the view.
 
 Takes a C4Shape object and adds it to the view hierarchy.

 Use this method instead of addSubview: when adding C4Shapes, because if there are special conditions for adding shapes this method will handle those.
 
 @param aShape A C4Shape object.
 */
-(void)addShape:(C4Shape *)aShape;

/** Adds a C4Label to the view.
 
 Takes a C4Label object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Labels, because if there are special conditions for adding shapes this method will handle those.
 
 @param aShape A C4Label object.
 */
-(void)addLabel:(C4Label *)aLabel;

///---------------------------------------------------------------------------------------
/// @name Setting A View's Origin Point
///---------------------------------------------------------------------------------------
/** Sets the origin point of the view.
 
 Takes a CGPoint and animates the view's origin position from its current point to the new point.
 
 This method positions the origin point of the current view by calculating the difference between this point and what the view's new center point will be. It then initiates the animation by setting the displaced new center point. 
 
 @param CGPoint A new point to which the origin should move.
 */
@property (nonatomic) CGPoint origin;

///---------------------------------------------------------------------------------------
/// @name Configuring A View's Animation Properties
///---------------------------------------------------------------------------------------
#pragma mark Animation Properties

/** Sets the duration of the view's animations.
 
 All animations that occur will use this value as their duration.
 
 For immediate animations set this property to 0.0f;
 
 Defaults to 0.0f;
 
 @param CGFloat A value in seconds for the length that a view should set for its animations.
 */
@property CGFloat animationDuration;

/** Sets the time to wait before the view's animations begin.
 
 All animations that occur will use this value as their delay.
 
 For immediate animations set this property to 0.0f;
 
 Defaults to 0.0f;
 
 @param CGFloat A value in seconds for the length that a view should wait before it triggers its animations.
 */
@property CGFloat animationDelay;

/** Sets the options for which the view should use in its animations.
 
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
 
 @warning *NOTE:* All animation options should be set at the same time using the | bitmask operator. Animation options should never be set in the following way:
 view.animationOptions = AUTOREVERSE;
 view.animationOptions = REPEAT;
  
 @param NSUInteger An integer which can be constructed from bitmasked values.
 */
@property (nonatomic) NSUInteger animationOptions;

/** Sets the number of times an animation autorepeats.
 
 @warning *NOTE:* This parameter is currently unused.
 
 @param CGFloat The number of times an animation should repeat.
 */
@property (nonatomic) CGFloat repeatCount;
@end
