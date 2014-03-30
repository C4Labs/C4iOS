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
/**A stepper control provides a user interface for incrementing or decrementing a value.
 
 A stepper displays two buttons, one with a minus (“–”) symbol and one with a plus (“+”) symbol. The bounding rectangle for a stepper matches that of a C4Switch object.
 
 If you set stepper behavior to “autorepeat” (which is the default), pressing and holding one of its buttons increments or decrements the stepper’s value repeatedly. The rate of change depends on how long the user continues pressing the control.
 */
@interface C4Stepper : C4Control <C4UIElement>

/**Creates and returns a new C4Stepper object.
 
 The primary subview of C4Stepper is a UIStepper.
 
 @return a new C4Stepper.
 */
+ (instancetype)stepper;

#pragma mark - Configuring the Stepper
///@name Configuring the Stepper

/**The continuous vs. noncontinuous state of the stepper.
 
 If YES, value change events are sent immediately when the value changes during user interaction. If NO, a value change event is sent when user interaction ends.
 
 The default value for this property is YES.
 */
@property(nonatomic, getter = isContinuous) BOOL continuous;

/**The automatic vs. nonautomatic repeat state of the stepper.
 
 If YES, the user pressing and holding on the stepper repeatedly alters value.
 
 The default value for this property is YES.
 */
@property(nonatomic) BOOL autorepeat;

/**The wrap vs. no-wrap state of the stepper.
 
 If YES, incrementing beyond maximumValue sets value to minimumValue; likewise, decrementing below minimumValue sets value to maximumValue. If NO, the stepper does not increment beyond maximumValue nor does it decrement below minimumValue but rather holds at those values.
 
 The default value for this property is NO.
 */
@property(nonatomic) BOOL wraps;

/**The lowest possible numeric value for the stepper.
 
 Must be numerically less than maximumValue. If you attempt to set a value equal to or greater than maximumValue, the system raises an NSInvalidArgumentException exception.
 
 The default value for this property is 0.
 */
@property(nonatomic) CGFloat minimumValue;

/**The highest possible numeric value for the stepper.
 
 Must be numerically greater than minimumValue. If you attempt to set a value equal to or lower than minimumValue, the system raises an NSInvalidArgumentException exception.
 
 The default value of this property is 5.
 */
@property(nonatomic) CGFloat maximumValue;

/**The step, or increment, value for the stepper.
 
 Must be numerically greater than 0. If you attempt to set this property’s value to 0 or to a negative number, the system raises an NSInvalidArgumentException exception.
 
 The default value for this property is 1.
 */
@property(nonatomic) CGFloat stepValue;

#pragma mark - Accessing the Stepper’s Value
///@name Accessing the Stepper’s Value
/**The numeric value of the stepper.
 
 When the value changes, the stepper sends the UIControlEventValueChanged flag to its target (see addTarget:action:forControlEvents:). Refer to the description of the continuous property for information about whether value change events are sent continuously or when user interaction ends.
 
 The default value for this property is 0. This property is clamped at its lower extreme to minimumValue and is clamped at its upper extreme to maximumValue.
 */
@property(nonatomic) CGFloat value;

#pragma mark - Customizing Appearance
///@name Customizing Appearance
/**The tint color for the stepper control.
 
 The value of this property is nil by default.
 */
@property(nonatomic, strong) UIColor *tintColor;
/**Returns the background image associated with the specified control state.
 
 @param state The control state in which the image is displayed (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 @return The background image used by the control when it is in the specified state.
 */
-(C4Image*)backgroundImageForState:(C4ControlState)state;

/**Sets the background image for the control when it is in the specified state.
 
 For good results, image must be a stretchable image.
 
 @param image The background image to use for the specified state.
 @param state The control state in which you want to display the image (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 */
-(void)setBackgroundImage:(C4Image*)image forState:(C4ControlState)state;

/**Returns the image used for the decrement glyph of the control.
 
 @param state The control state in which the image is displayed (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 @return The image used for the decrement glyph of the control.
 */
-(C4Image *)decrementImageForState:(C4ControlState)state;

/**Sets the image to use for the decrement glyph of the control.
 
 The image you specify is composited on top of the control’s background to create the final control. If you do not specify a custom image, a minus (-) glyph is used.
 
 @param image The image to use for the decrement glyph.
 @param state The control state in which you want to display the image (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 */
-(void)setDecrementImage:(C4Image *)image forState:(C4ControlState)state;

/**Returns the divider image for the given combination of left and right states.
 
 @param leftState The state of the left side of the control (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 @param rightState The state of the right side of the control (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 @return The image used for the specified combination of left and right states.
 */
-(C4Image*)dividerImageForLeftSegmentState:(C4ControlState)leftState rightSegmentState:(C4ControlState)rightState;

/**Sets the image to use for the given combination of left and right states.
 
 @param image The divider image to use.
 @param leftState The state of the left side of the control (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 @param rightState The state of the right side of the control (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 */
-(void)setDividerImage:(C4Image*)image forLeftSegmentState:(C4ControlState)leftState rightSegmentState:(C4ControlState)rightState;

/**Returns the image used for the increment glyph of the control.
 
 @param state The control state in which the image is displayed (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 @return The image used for the increment glyph of the control.
 */
-(C4Image *)incrementImageForState:(C4ControlState)state;

/**Sets the image to use for the increment glyph of the control
 
 The image you specify is composited on top of the control’s background to create the final control. If you do not specify a custom image, a plus (+) glyph is used.
 
 @param image The image to use for the increment glyph.
 @param state The control state (one of: DISABLED, NORMAL, HIGHLIGHTED, SELECTED).
 */
-(void)setIncrementImage:(C4Image *)image forState:(C4ControlState)state;

#pragma mark - Accessing The UIStepper
///@name Accessing The UIStepper
/**The UIStepper object which is the primary subview of the receiver.
 */
@property(nonatomic, readonly, strong) UIStepper *UIStepper;

@end
