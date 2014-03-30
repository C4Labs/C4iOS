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

#import "C4Control.h"
/**This document describes the C4Slider class. An instance of the C4Slider class implements a slider on the touch screen. A slider intercepts touch events and sends an action message to a target object when its value has changed, or for other touch events.
 
 A C4Slider object is a visual control used to select a single value from a continuous range of values. Sliders are always displayed as horizontal bars. An indicator, or thumb, notes the current value of the slider and can be moved by the user to change the setting.
 
 The most common way to customize the slider’s appearance is to provide custom minimum and maximum value images. These images sit at either end of the slider control and indicate which value that end of the slider represents. For example, a slider used to control volume might display a small speaker with no sound waves emanating from it for the minimum value and display a large speaker with many sound waves emanating from it for the maximum value.
 
 The bar on which the thumb rides is referred to as the slider’s track. Slider controls draw the track using two distinct images, which are customizable.
 
 The region between the thumb and the end of the track associated with the slider’s minimum value is drawn using the minimum track image.
 
 The region between the thumb and the end of the track associated with the slider’s maximum value is drawn using the maximum track image.
 
 Different track images are used in order to provide context as to which end contains the minimum value. For example, the minimum track image typically contains a blue highlight while the maximum track image contains a white highlight.
 
 You can assign different tint colors for all of the standard parts provided by the slider, or you customize the appearance further by assigning different pairs of track images to each of the control states of the slider. Assigning different images to each state lets you customize the appearance of the slider when it is enabled, disabled, highlighted, and so on.
 
 In addition to customizing the track images, you can also customize the appearance of the thumb itself. Like the track images, you can assign different thumb images to each control state of the slider.
 
 Note: The slider control provides a set of default images for both the track and thumb. If you do not specify any custom images, those images are used automatically.
 
 */
@interface C4Slider : C4Control <C4UIElement>

/**Creates and returns a new slider object fit inside the given frame.
 
 The slider will not fit entirely to the frame. It will stretch out to the width of the frame, but the default height will remain the same. For example, for the frames of (0,0,100,100) and (0,0,100,200) will each produce sliders 100 pts wide, and the default slider height as defined by UISlider. The only difference will be the size of the slider's frame.
 
 @param rect a CGRect structure used to construct the slider's view.
 @return a new C4Slider object.
 */
+ (instancetype)slider:(CGRect)rect;

/**Initializes and returns a new slider object fit inside the given frame.
 
 The slider will not fit entirely to the frame. It will stretch out to the width of the frame, but the default height will remain the same. For example, for the frames of (0,0,100,100) and (0,0,100,200) will each produce sliders 100 pts wide, and the default slider height as defined by UISlider. The only difference will be the size of the slider's frame.
 
 @param frame a CGRect structure used to construct the slider's view.
 @param useDefaults a boolean flag that allows the slider to be constructed with C4 default style. YES to use the default C4 images and colors, NO to use default UISlider style.
 @return a new C4Slider object.
 */
-(id)initWithFrame:(CGRect)frame defaults:(BOOL)useDefaults;

#pragma mark - Accessing the Slider’s Value
///@name Accessing the Slider’s Value
/**Contains the receiver’s current value.
 
 Setting this property causes the receiver to redraw itself using the new value. To render an animated transition from the current value to the new value, you should use the setValue:animated: method instead.
 
 If you try to set a value that is below the minimum or above the maximum value, the minimum or maximum value is set instead. The default value of this property is 0.0.
 */
@property(nonatomic) CGFloat value;

/**Sets the receiver’s current value, allowing you to animate the change visually.
 
 If you try to set a value that is below the minimum or above the maximum value, the minimum or maximum value is set instead. The default value of this property is 0.0.
 
 @param value The new value to assign to the value property
 @param animated Specify YES to animate the change in value when the receiver is redrawn; otherwise, specify NO to draw the receiver with the new value only. Animations are performed asynchronously and do not block the calling thread.
 */
-(void)setValue:(CGFloat)value animated:(BOOL)animated;

#pragma mark - Accessing the Slider’s Value Limits
///@name Accessing the Slider’s Value Limits
/**Contains the minimum value of the receiver.
 
 If you change the value of this property, and the current value of the receiver is below the new minimum, the current value is adjusted to match the new minimum value automatically.
 
 The default value of this property is 0.0.
 */
@property(nonatomic) CGFloat minimumValue;

/**Contains the maximum value of the receiver.
 
 If you change the value of this property, and the current value of the receiver is above the new maximum, the current value is adjusted to match the new maximum value automatically.
 
 The default value of this property is 1.0.
 */
@property(nonatomic) CGFloat maximumValue;

#pragma mark - Modifying the Slider’s Behavior
///@name Modifying the Slider’s Behavior
/**Contains a Boolean value indicating whether changes in the sliders value generate continuous update events.
 
 If YES, the slider sends update events continuously to the associated target’s action method. If NO, the slider only sends an action event when the user releases the slider’s thumb control to set the final value.
 
 The default value of this property is YES.
 */
@property(nonatomic,getter=isContinuous) BOOL continuous;

#pragma mark - Changing the Slider’s Appearance
///@name Changing the Slider’s Appearance
/**Contains the image that is drawn on the side of the slider representing the minimum value.
 
 The image you specify should fit within the bounding rectangle returned by the minimumValueImageRectForBounds: method. If it does not, the image is scaled to fit. In addition, the receiver’s track is lengthened or shortened as needed to accommodate the image in its bounding rectangle.
 
 This default value of this property is nil.
 */
@property(nonatomic, strong) C4Image *minimumValueImage;

/**Contains the image that is drawn on the side of the slider representing the maximum value.
 
 The image you specify should fit within the bounding rectangle returned by the maximumValueImageRectForBounds: method. If it does not, the image is scaled to fit. In addition, the receiver’s track is lengthened or shortened as needed to accommodate the image in its bounding rectangle.
 
 This default value of this property is nil.
 */
@property(nonatomic, strong) C4Image *maximumValueImage;

/*The color used to tint the standard minimum track images.
 
 Setting this property removes any custom minimum track images associated with the slider.
 */
@property(nonatomic, strong) UIColor *minimumTrackTintColor;

/**Contains the minimum track image currently being used to render the receiver. (read-only)
 
 Sliders can have different track images for different control states. The image associated with this property reflects the minimum track image associated with the currently active control state. To get the minimum track image for a different control state, use the minimumTrackImageForState: method.
 
 If no custom track images have been set using the setMinimumTrackImage:forState: method, this property contains the value nil. In that situation, the receiver uses the default minimum track image for drawing.
 */
@property(nonatomic, readonly, strong) C4Image* currentMinimumTrackImage;

/**Returns the minimum track image associated with the specified control state.
 
 @param state The control state whose minimum track image you want (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED). You should specify only one control state value for this parameter.
 @return A C4Image. The minimum track image associated with the specified state, or nil if no image has been set. This method might also return nil if you specify multiple control states in the state parameter. For a description of track images, see “Customizing the Slider’s Appearance.”
 */
-(C4Image *)minimumTrackImageForState:(C4ControlState)state;

/**Assigns a minimum track image to the specified control states.
 
 The orientation of the track image must match the orientation of the slider control. To facilitate the stretching of the image to fill the space between the thumb and end point, track images are usually defined in three regions. A stretchable region sits between two end cap regions. The end caps define the portions of the image that remain as is and are not stretched. The stretchable region is a 1-point wide area between the end caps that can be replicated to make the image appear longer.
 
 To define the end cap sizes for a slider, assign an appropriate value to the image’s leftCapWidth property. For more information about how this value defines the regions of the slider, see the C4Image class.
 
 Setting a new track image for any state clears any custom tint color you may have provided for minimum track images.
 
 @param image The minimum track image to associate with the specified states.
 @param state The control state with which to associate the image (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 */
-(void)setMinimumTrackImage:(C4Image *)image forState:(C4ControlState)state;

/**The color used to tint the standard maximum track images.
 
 Setting this property removes any custom maximum track images associated with the slider.
 */
@property(nonatomic, strong) UIColor *maximumTrackTintColor;

/**Contains the maximum track image currently being used to render the receiver. (read-only)
 
 Sliders can have different track images for different control states. The image associated with this property reflects the maximum track image associated with the currently active control state. To get the maximum track image for a different control state, use the maximumTrackImageForState: method.
 
 If no custom track images have been set using the setMaximumTrackImage:forState: method, this property contains the value nil. In that situation, the receiver uses the default maximum track image for drawing.
 */
@property(nonatomic, readonly, strong) C4Image* currentMaximumTrackImage;

/**Returns the maximum track image associated with the specified control state.
 
 @param state The control state whose maximum track image you want (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED). You should specify only one control state value for this parameter.
 @return A C4Image. The maximum track image associated with the specified state, or nil if an appropriate image could not be retrieved. This method might return nil if you specify multiple control states in the state parameter.
 */
-(C4Image *)maximumTrackImageForState:(C4ControlState)state;

/**Assigns a maximum track image to the specified control states.
 
 The orientation of the track image must match the orientation of the slider control. To facilitate the stretching of the image to fill the space between the thumb and end point, track images are usually defined in three regions. A stretchable region sits between two end cap regions. The end caps define the portions of the image that remain as is and are not stretched. The stretchable region is a 1-point wide area between the end caps that can be replicated to make the image appear longer.
 
 To define the end cap sizes for a slider, assign an appropriate value to the image’s leftCapWidth property. For more information about how this value defines the regions of the slider, see the UIImage class.
 
 Setting a new track image for any state clears any custom tint color you may have provided for maximum track images.
 
 @param image The maximum track image to associate with the specified states.
 @param state The control state with which to associate the image (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 */
-(void)setMaximumTrackImage:(C4Image *)image forState:(C4ControlState)state;

/**The color used to tint the standard thumb images.
 
 Setting this property removes any custom thumb images associated with the slider.
 */
@property(nonatomic, strong) UIColor *thumbTintColor;

/**Contains the thumb image currently being used to render the receiver. (read-only)
 
 Sliders can have different thumb images for different control states. The image associated with this property reflects the thumb image associated with the currently active control state. To get the thumb image for a different control state, use the thumbImageForState: method.
 
 If no custom thumb images have been set using the setThumbImage:forState: method, this property contains the value nil. In that situation, the receiver uses the default thumb image for drawing.
 */
@property(nonatomic, readonly, strong) C4Image* currentThumbImage;

/**Returns the thumb image associated with the specified control state.
 
 @param state The control state whose thumb image you want (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED). You should specify only one control state value for this parameter.
 @return The thumb image associated with the specified state, or nil if an appropriate image could not be retrieved. This method might return nil if you specify multiple control states in the state parameter.
 */
-(C4Image *)thumbImageForState:(C4ControlState)state;

/**Assigns a thumb image to the specified control states.
 
 Setting a new thumb image for any state clears any custom tint color you may have provided for thumb images.
 
 @param image The thumb image to associate with the specified states.
 @param state The control state with which to associate the image (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 */
-(void)setThumbImage:(C4Image *)image forState:(C4ControlState)state;

#pragma mark - Accessing The UISlider
///@name Accessing The UISlider
/**The UISlider object which is the primary subview of the receiver.
 */
@property(nonatomic, readonly) UISlider *UISlider;

@end