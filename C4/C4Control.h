// Copyright © 2012 Travis Kirton
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import <UIKit/UIKit.h>
#import "C4Object.h"

@class C4AnimationHelper;
@class C4Layer;
@class C4Template;

/** The C4Control is a subclass of C4Object, which is the base class for control objects such as buttons and sliders that convey user intent to the application. It instead defines the common interface and behavioral structure for all its subclasses.
 
 In C4, the main role of C4Control is to provide all objects that have a visible representation the ability to receive and handle user interaction.
 
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

@interface C4Control : C4Object

- (id)initWithFrame:(CGRect)frame;
- (id)initWithView:(UIView*)view;


#pragma mark - Properties

@property(nonatomic, readonly, strong) UIView* view;
@property(nonatomic, readonly, strong) C4AnimationHelper *animationHelper;

/** The receiver's frame. */
@property(nonatomic) CGRect frame;

/** The receiver's bounds. */
@property(nonatomic) CGRect bounds;

/** The position of the receiver's center, in parent coordinates. */
@property(nonatomic) CGPoint center;

/** The position of the receiver's top-left corner, in parent coordinates. */
@property(nonatomic) CGPoint origin;

/** The width of the receiver's frame. */
@property(nonatomic, readonly) CGFloat width;

/** The height of the receiver's frame. */
@property(nonatomic, readonly) CGFloat height;

/** The size of the receiver's frame. */
@property(nonatomic, readonly) CGSize size;

@property(nonatomic) CGAffineTransform transform;

#pragma mark Animation Properties
///@name Animation Properties
/** The duration of the view's animations, measured in seconds.
 
 All animations that occur will use this value as their duration.
 
 For immediate animations set this property to 0.0f;
 
 Defaults to 0.0f
 
 */
@property(nonatomic) CGFloat animationDuration;

/** The time to wait before the view's animations begin, measured in seconds.
 
 All animations that occur will use this value as their delay.
 
 For immediate animations set this property to 0.0f;
 
 Defaults to 0.0f
 */
@property(nonatomic) CGFloat animationDelay;

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
@property(nonatomic) NSUInteger animationOptions;


#pragma mark Shadow Properties
///@name Shadow Properties

/**Specifies the blur radius used to render the receiver’s shadow.
 
 This applies to the shadow of the contents of the layer, and not specifically the text.
 */
@property(nonatomic) CGFloat shadowRadius;

/**Specifies the opacity of the receiver’s shadow. Animatable.
 
 This applies to the shadow of the contents of the layer, and not specifically the text.
 */
@property(nonatomic) CGFloat shadowOpacity;
/**The shadow color of the text.
 
 The default value for this property is nil, which indicates that no shadow is drawn. In addition to this property, you may also want to change the default shadow offset by modifying the shadowOffset property. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property(nonatomic, strong) UIColor *shadowColor;

/**The shadow offset (measured in points) for the text.
 
 The shadow color must be non-nil for this property to have any effect. The default offset size is (0, -1), which indicates a shadow one point above the text. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property(nonatomic) CGSize shadowOffset;

/**Defines the shape of the shadow. Animatable.
 
 Unlike most animatable properties, shadowPath does not support implicit animation.
 
 If the value in this property is non-nil, the shadow is created using the specified path instead of the layer’s composited alpha channel. The path defines the outline of the shadow. It is filled using the non-zero winding rule and the current shadow color, opacity, and blur radius.
 
 Specifying an explicit path usually improves rendering performance.
 
 The default value of this property is NULL.
 */
@property(nonatomic) CGPathRef shadowPath;


#pragma mark Style Properties

@property(nonatomic, copy) UIColor *backgroundColor;
@property(nonatomic) CGFloat alpha;
@property(nonatomic, getter=isHidden) BOOL hidden;

/**Specifies the width of the receiver’s border. Animatable.
 
 The border is drawn inset from the receiver’s bounds by borderWidth. It is composited above the receiver’s contents and sublayers and includes the effects of the cornerRadius property. The default is 0.0.
 */
@property(nonatomic) CGFloat borderWidth;

/**Specifies a radius used to draw the rounded corners of the receiver’s background. Animatable.
 
 If the radius is greater than 0 the background is drawn with rounded corners. The default value is 0.0.
 */
@property(nonatomic) CGFloat cornerRadius;

/**The color of the receiver’s border. Animatable.
 
 Defaults to opaque black.
 
 The value of this property is retained using the Core Foundation retain/release semantics. This behavior occurs despite the fact that the property declaration appears to use the default assign semantics for object retention.
 */
@property(nonatomic, strong) UIColor *borderColor;


#pragma mark Other Properties
///@name Other Properties
/**Determines if the sublayers are clipped to the receiver’s bounds. Animatable.
 
 If YES, an implicit mask matching the layer bounds is applied to the layer, including the effects of the cornerRadius property. If YES and a mask property is specified, the two masks are multiplied to get the actual mask values. Defaults to NO.
 */
@property(nonatomic) BOOL masksToBounds;

/**Specifies a transform applied to each sublayer when rendering. Animatable.
 
 This property is typically used as the projection matrix to add perspective and other viewing effects to the receiver. Defaults to the identity transform.
 */
@property(nonatomic) CATransform3D layerTransform;

/**An optional layer whose alpha channel is used as a mask to select between the layer's background and the result of compositing the layer's contents with its filtered background.
 
 Defaults to nil.
 */
@property(nonatomic, strong) C4Control *mask;

/**Specifies the receiver’s position on the z axis. Animatable.
 
 Defaults to 0.
 */
@property(nonatomic) CGFloat zPosition;

/**Specifies the receiver's z-axis rotation value. Animatable.
 
 Setting this value will rotate the receiver around its anchorPoint.
 */
@property(nonatomic) CGFloat rotation;

/**Specifies the receiver's x-axis rotation value. Animatable.
 
 Setting this value will rotate the receiver around its anchorPoint.
 */
@property(nonatomic) CGFloat rotationX;

/**Specifies the receiver's y-axis rotation value. Animatable.
 
 Setting this value will rotate the receiver around its anchorPoint.
 */
@property(nonatomic) CGFloat rotationY;

/**Specifies the perspective distance for x and y axis rotations.
 
 Technically, this will set the perspective transform component of the receiver's transform to 1/value (i.e. the new value that is set). It will perform the following action:
 
 `CATransform3D t = self.transform;
 if(perspectiveDistance != 0.0f) t.m34 = 1/self.perspectiveDistance;
 else t.m34 = 0.0f;
 self.transform = t;`
 
 Defaults to 0.
 */
@property(nonatomic) CGFloat perspectiveDistance;

/**Defines the anchor point of the layer's bounds rectangle. Animatable.
 
 Described in the unit coordinate space. The value of this property is specified in points. Defaults to (0.5, 0.5), the center of the bounds rectangle.
 
 See “Layer Geometry and Transforms” in Core Animation Programming Guide for more information on the relationship between the bounds, anchorPoint and position properties.
 */
@property(nonatomic) CGPoint anchorPoint;


#pragma mark - Adding sub-elements

/** Adds a UIView to the control.
 
 Takes a UIView object and adds it to the view hierarchy.
 
 @param view A view.
 */
-(void)addSubview:(UIView *)view;

/** Adds a C4Control to the view.
 
 Takes a C4Control object and adds it to the view hierarchy.
 
 @param control A control.
 */
-(void)addControl:(C4Control *)control;

/** A method for adding multiple objects to the canvas at one time.
 
 This will run the appropriate add method for all C4 objects, and will run the default addSubview for any other objects.
 
 @param array The array of visual objects to remove from their parent view.
 */
-(void)addObjects:(NSArray *)array;

/** A method to remove another object from its view.
 
 For the object in question, use this method to remove any visible object that was previously added to it as a subview.
 
 @param visualObject the visible object to remove from its parent view
 */
-(void)removeObject:(id)visualObject;

/** A method to remove an array of objects from their view.
 
 This will run the removeObject: method on each object in an array.
 
 @param array The array of visual objects to remove from their parent view
 */
-(void)removeObjects:(NSArray *)array;


#pragma mark - Gestures
///@name Gestures

typedef void (^C4TapGestureBlock)(CGPoint location);
typedef void (^C4PanGestureBlock)(CGPoint location, CGPoint translation, CGPoint velocity);
typedef void (^C4PinchGestureBlock)(CGPoint location, CGFloat scale, CGFloat velocity);
typedef void (^C4RotationGestureBlock)(CGPoint location, CGFloat rotation, CGFloat velocity);
typedef void (^C4LongPressGestureBlock)(CGPoint location);
typedef void (^C4SwipeGestureBlock)(CGPoint location);

/** Registers a block of code to execute when the control is tapped.
 */
- (void)onTap:(C4TapGestureBlock)block;

/** Registers a block of code to execute when the control is panned (dragged).
 */
- (void)onPan:(C4PanGestureBlock)block;

/** Registers a block of code to execute when the control is pinched.
 */
- (void)onPinch:(C4PinchGestureBlock)block;

/** Register a block of code to exectue when the control is rotated.
 */
- (void)onRotation:(C4RotationGestureBlock)block;

/** Restier a block of code to execute when the control is long-pressed.
 */
- (void)onLongPressStart:(C4LongPressGestureBlock)block;

/** Register a block of code to exectue when the control stops being long-pressed.
 */
- (void)onLongPressEnd:(C4LongPressGestureBlock)block;

/** Register a block of code to execute when the control is swiped right.
 */
- (void)onSwipeRight:(C4SwipeGestureBlock)block;

/** Register a block of code to exectue when the control is swiped left.
 */
- (void)onSwipeLeft:(C4SwipeGestureBlock)block;

/** Register a block of code to exectue when the control is swiped up.
 */
- (void)onSwipeUp:(C4SwipeGestureBlock)block;

/** Register a block of code to exectue when the control is swiped down.
 */
- (void)onSwipeDown:(C4SwipeGestureBlock)block;


#pragma mark - Templates
///@name Templates

/**Returns the default template for the object.
 
 @return The default template for the receiver.
 */
+ (C4Template *)defaultTemplate;

/**Returns the template proxy for the object, cast as a C4Control.
 
 You use this method to grab the default template proxy object that allows you to change the default template for C4Control objects.
 
 @return The template proxy for the receiver, cast as a C4Control.
 */
+ (instancetype)defaultTemplateProxy;


/** Return a new blank template for the object.
 */
+ (C4Template *)template;

/** Apply a template to the object.
 */
- (void)applyTemplate:(C4Template*)template;


#pragma mark - Convenience Methods

/**Renders the receiver and its sublayers into the specified context.
 
 This method renders the contents of a C4Control directly from the layer tree, ignoring any animations added to the render tree. It essentially binds to the `renderInContext` method of the underlying C4Layer.
 
 This method is used for rendering objects into a graphics context before either creating an image or saving drawing to external files.
 
 @param context The graphics context to use to render the layer.
 */
-(void)renderInContext:(CGContextRef)context;

#pragma - mark Gesture Additions
-(void)tapped;
-(void)tapped:(CGPoint)location;
-(void)panned;
-(void)panned:(CGPoint)location translation:(CGPoint)translation velocity:(CGPoint)velocity;
-(void)pinched;
-(void)pinched:(CGPoint)location scale:(CGFloat)scale velocity:(CGFloat)velocity;
-(void)rotated;
-(void)rotated:(CGPoint)location rotation:(CGFloat)rotation velocity:(CGFloat)velocity;
-(void)swipedLeft;
-(void)swipedRight;
-(void)swipedUp;
-(void)swipedDown;
-(void)longPressStarted;
-(void)longPressStarted:(CGPoint)location;
-(void)longPressEnded;
-(void)longPressEnded:(CGPoint)location;
-(void)move:(CGPoint)location;

#pragma - mark Other Additions
-(void)removeFromSuperview;
@property (nonatomic) BOOL userInteractionEnabled;

@end
