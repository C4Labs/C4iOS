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

@class C4Label;


/**This document describes the C4Button class. An instance of the C4Button class implements a button on the touch screen. A button intercepts touch events and sends an action message to a target object when tapped.
 
 The C4Button class implements a UIButton embedded in a C4Control view with bindings directly to the native object. That is, many of the methods in this class are simpy wrappers for triggering the same methods on the contained UIButton.
 
 This class provides methods for setting the title, image, and other appearance properties of a button. By using these accessors, you can specify a different appearance for each button state.
 */
@interface C4Button : C4Control <C4UIElement>

#pragma mark Creating Buttons
///@name Creating Buttons
/**Creates and returns a new button of the specified type.
 
 This method is a convenience constructor for creating button objects with specific configurations. If you subclass C4Button, this method does not return an instance of your subclass. If you want to create an instance of a specific subclass, you must alloc/init the button directly.
 
 When creating a custom button—that is a button with the type CUSTOM — the frame of the button is set to (0, 0, 0, 0) initially. Before adding the button to your interface, you should update the frame to a more appropriate value.
 
 @param buttonType The button type. See C4ButtonType (in C4Defaults) for the possible values.
 
 @return A newly created button.
 */
+ (instancetype)buttonWithType:(C4ButtonType)buttonType;

/**The default initialization method for the C4Button class.
 
 When called, this method creates a C4Control and adds a newly created UIButton object of the same type passed to the method. It updates the frame of the UIButton and then calls its own setup method.
 
 @param buttonType The button type. See C4ButtonType (in C4Defaults) for the possible values.
 
 @return A newly created C4Button.
 */
-(id)initWithType:(C4ButtonType)buttonType;

#pragma mark Configuring the Button Title

/**A Boolean value that determines whether the title shadow changes when the button is highlighted.
 
 If YES, the shadow changes from engrave to emboss appearance when highlighted. The default value is NO.
 */
@property(nonatomic) BOOL reversesTitleShadowWhenHighlighted;

/**Sets the title to use for the specified state.
 
 Use this method to set the title for the button. The title you specify derives its formatting from the button’s associated label object.
 
 At a minimum, you should set the value for the normal state. If a title is not specified for a state, the default behavior is to use the title associated with the NORMAL state. If the value for NORMAL is not set, then the property defaults to a system value.
 
 @param title The title to use for the specified state.
 
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 */
-(void)setTitle:(NSString *)title forState:(C4ControlState)state;

/**Sets the styled title to use for the specified state.
 
 Use this method to set the title of the button, including any relevant formatting information. If you set both a title and an attributed title for the button, the button prefers the use of the attributed title.
 
 At a minimum, you should set the value for the normal state. If a title is not specified for a state, the default behavior is to use the title associated with the NORMAL state. If the value for NORMAL is not set, then the property defaults to a system value.
 
 @param title The styled text string so use for the title.
 @param state The state that uses the specified title. The possible values are described in UIControlState.
 */
-(void)setAttributedTitle:(NSAttributedString *)title forState:(C4ControlState)state NS_AVAILABLE_IOS(6_0);

/**Sets the color of the title to use for the specified state.
 
 In general, if a property is not specified for a state, the default is to use the NORMAL value. If the NORMAL value is not set, then the property defaults to a system value. Therefore, at a minimum, you should set the value for the normal state.
 
 @param color The color of the title to use for the specified state.
 @param state The state that uses the specified color. The possible values are described in C4ControlState.
 */
-(void)setTitleColor:(UIColor *)color forState:(C4ControlState)state;

/**Sets the color of the title to use for the specified state.
 
 In general, if a property is not specified for a state, the default is to use the NORMAL value. If the NORMAL value is not set, then the property defaults to a system value. Therefore, at a minimum, you should set the value for the normal state.
 
 @param color The color of the title to use for the specified state.
 @param state The state that uses the specified color. The possible values are described in C4ControlState.
 */
-(void)setTitleShadowColor:(UIColor *)color forState:(C4ControlState)state;

/**Returns the title color used for a state.
 
 @param state The state that uses the title color. The possible values are described in UIControlState.
 
 @return The color of the title for the specified state.
 */
-(UIColor *)titleColorForState:(C4ControlState)state;

/**Returns the title associated with the specified state.
 
 @param state The state that uses the title. The possible values are described in C4ControlState.
 
 @return The title for the specified state. If no title has been set for the specific state, this method returns the title associated with the NORMAL state.
 */
-(NSString *)titleForState:(C4ControlState)state;

/**Returns the styled title associated with the specified state.
 
 @param state The state that uses the styled title. The possible values are described in C4ControlState.
 @return The title for the specified state. If no attributed title has been set for the specific state, this method returns the attributed title associated with the NORMAL state.
 */
-(NSAttributedString *)attributedTitleForState:(C4ControlState)state NS_AVAILABLE_IOS(6_0);

/**Returns the title color used for a state.
 
 @param state The state that uses the title color. The possible values are described in C4ControlState.
 @return The color of the title for the specified state.
 */
-(UIColor *)titleShadowColorForState:(C4ControlState)state;

#pragma mark - Configuring Button Presentation
///@name Configuring Button Presentation
/**A Boolean value that determines whether the image changes when the button is highlighted.
 
 If YES, the image is drawn lighter when the button is highlighted. The default value is YES.
 */
@property(nonatomic) BOOL adjustsImageWhenHighlighted;

/**A Boolean value that determines whether the image changes when the button is disabled.
 
 If YES, the image is drawn darker when the button is disabled. The default value is YES.
 */
@property(nonatomic) BOOL adjustsImageWhenDisabled;

/**A Boolean value that determines whether tapping the button causes it to glow.
 
 If YES, the button glows when tapped; otherwise, it does not. The image and button behavior is not changed by the glow. The default value is NO.
 */
@property(nonatomic) BOOL showsTouchWhenHighlighted;

/**Returns the C4Image used for the background of a button state.
 
 @param state The state that uses the image. Possible values are described in C4ControlState.
 
 @return The image used for the background of the specified state.
 */
-(C4Image *)backgroundImageForState:(C4ControlState)state;

/**Returns the C4Image used for a button state.
 
 @param state The state that uses the image. Possible values are described in C4ControlState.
 
 @return The image used for the specified state.
 */
-(C4Image *)imageForState:(C4ControlState)state;

/**Sets the background image to use for the specified button state.
 
 In general, if a property is not specified for a state, the default is to use the NORMAL value. If the NORMAL value is not set, then the property defaults to a system value. Therefore, at a minimum, you should set the value for the normal state.
 
 @param image The background image to use for the specified state.
 @param state The state that uses the specified image. The values are described in UIControlState.
 */
-(void)setBackgroundImage:(C4Image *)image forState:(C4ControlState)state;

/**Sets the C4Image to use for the specified state.
 
 In general, if a property is not specified for a state, the default is to use the NORMAL value. If the NORMAL value is not set, then the property defaults to a system value. Therefore, at a minimum, you should set the value for the normal state.
 
 @param image The image to use for the specified state.
 @param state The state that uses the specified title. The values are described in C4ControlState.
 */
-(void)setImage:(C4Image *)image forState:(C4ControlState)state;

/**The tint color for the button.
 
 The default value is a UIColor created with the darkBluePattern image.
 
 This property is not valid for all button types.
 */
@property(nonatomic, strong) UIColor *tintColor;

/**The font used to display text on the button.
 
 This method binds to the UIButton's font by accessing its titleLabel.font property.
 
 If nil, a system font is used. The default value is 15.0pt Avenir-Medium.
 */
@property(nonatomic, strong) C4Font *font;

#pragma mark - Configuring Edge Insets
///@name Configuring Edge Insets
/**The inset or outset margins for the rectangle surrounding all of the button’s content.
 
 Use this property to resize and reposition the effective drawing rectangle for the button content. The content comprises the button image and button title. You can specify a different value for each of the four insets (top, left, bottom, right). A positive value shrinks, or insets, that edge—moving it closer to the center of the button. A negative value expands, or outsets, that edge. Use the UIEdgeInsetsMake function to construct a value for this property. The default value is UIEdgeInsetsZero.
 */
@property(nonatomic) UIEdgeInsets contentEdgeInsets;

/**The inset or outset margins for the rectangle around the button’s title text.
 
 Use this property to resize and reposition the effective drawing rectangle for the button title. You can specify a different value for each of the four insets (top, left, bottom, right). A positive value shrinks, or insets, that edge—moving it closer to the center of the button. A negative value expands, or outsets, that edge. Use the UIEdgeInsetsMake function to construct a value for this property. The default value is UIEdgeInsetsZero.
 
 The insets you specify are applied to the title rectangle after that rectangle has been sized to fit the button’s text. Thus, positive inset values may actually clip the title text.
 */
@property(nonatomic) UIEdgeInsets titleEdgeInsets;

/**The inset or outset margins for the rectangle around the button’s image.
 
 Use this property to resize and reposition the effective drawing rectangle for the button image. You can specify a different value for each of the four insets (top, left, bottom, right). A positive value shrinks, or insets, that edge—moving it closer to the center of the button. A negative value expands, or outsets, that edge. Use the UIEdgeInsetsMake function to construct a value for this property. The default value is UIEdgeInsetsZero.
 */
@property(nonatomic) UIEdgeInsets imageEdgeInsets;

#pragma mark - Getting the Current State
///@name Getting the Current State
/**The button type. (read-only)
 
 See C4ButtonType for the possible values.
 */
@property(nonatomic, readonly) C4ButtonType buttonType;

/**The current title that is displayed on the button. (read-only)
 
 The value for this property is set automatically whenever the button state changes. For states that do not have a custom title string associated with them, this method returns the title that is currently displayed, which is typically the one associated with the NORMAL state. The value may be nil.
 */
@property(nonatomic, readonly, strong) NSString *currentTitle;

/**The current styled title that is displayed on the button. (read-only)
 
 The value for this property reflects the title associated with the control’s current state. For states that do not have a custom title string associated with them, this method returns the attributed title that is currently displayed, which is typically the one associated with the NORMAL state.
 */
@property(nonatomic, readonly, strong) NSAttributedString *currentAttributedTitle NS_AVAILABLE_IOS(6_0);

/**The color used to display the title. (read-only)
 
 This value is guaranteed not to be nil. The default value is C4GREY.
 */
@property(nonatomic, readonly, strong) UIColor *currentTitleColor;

/**The color of the title’s shadow. (read-only)
 
 The default value is white.
 */
@property(nonatomic, readonly, strong) UIColor *currentTitleShadowColor;

/**The current image displayed on the button. (read-only)
 
 This value can be nil.
 */
@property(nonatomic, readonly, weak) C4Image *currentImage;

/**The current background image displayed on the button. (read-only)
 
 This value can be nil.
 */
@property(nonatomic, readonly, strong) C4Image *currentBackgroundImage;

#pragma mark - Accessing the UIButton
///@name Accessing the UIButton

/**The encapsulated UIButton object.
 
 This method returns the UIButton object that is the subview of the C4Button's view.
 */
@property(nonatomic, readonly, strong) UIButton *UIButton;

@end
