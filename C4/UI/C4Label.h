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

/** The C4Label class implements a read-only text view. You can use this class to draw one or multiple lines of static text, such as those you might use to identify other parts of your user interface. The base C4Label class provides control over the appearance of your text, including whether it uses a shadow or draws with a highlight. If needed, you can customize the appearance of your text further by subclassing.
 
 C4Label is a subclass of C4Control, and so inherits all the functionality of animation and interaction provided by C4Control. It encapsulates a UILabel and provides all the necessary methods to access and manipulate its label.
 
 Unlike [C4Shape](C4Shape), which has an underlying backing layer, C4Label adds its encapsulated UILabel as a subview.
 */
@interface C4Label : C4Control

#pragma mark - Creating Labels
///@name Creating Labels

/**Creates and returns a new label with the specified text, using the default font.
 
 The default font is your base System Font 24pt.
 
 @param text An NSString that will make up the text for the label.
 @return A new C4Label.
 */
+ (instancetype)labelWithText:(NSString *)text;

/**Creates and returns a new label with the specified text, using the specified font.
 
 @param text An NSString that will make up the text for the label.
 @param font A C4Font that will be used to render the label's text.
 @return A new C4Label.
 */
+ (instancetype)labelWithText:(NSString *)text font:(C4Font *)font;

/**Creates and returns a new label with the specified text, using the specified font.
 
 @param text An NSString that will make up the text for the label.
 @param font A C4Font that will be used to render the label's text.
 @param frame A CGRect that will make up the size of the view for the label.
 @return A new C4Label.
 */
+ (instancetype)labelWithText:(NSString *)text font:(C4Font *)font frame:(CGRect)frame;

/**Initializes and returns a new label with the specified text, using the default font.
 
 The default font is your base System Font 24pt.
 
 @param text An NSString that will make up the text for the label.
 @return A new C4Label.
 */
-(id)initWithText:(NSString *)text;

/**Initializes and returns a new label with the specified text, using the specified font.
 
 @param text An NSString that will make up the text for the label.
 @param font A C4Font that will be used to render the label's text.
 @return A new C4Label.
 */
-(id)initWithText:(NSString *)text font:(C4Font *)font;

/**Initializes and returns a new label with the specified text, using the specified font.
 
 @param text An NSString that will make up the text for the label.
 @param font A C4Font that will be used to render the label's text.
 @param frame A CGRect that will make up the size of the view for the label.
 @return A new C4Label.
 */
-(id)initWithText:(NSString *)text font:(C4Font *)font frame:(CGRect)frame;

/// @name Fitting the label's size to its text
#pragma mark Fitting the label's size to its text

/**Resizes the label's view so that it just fits its text.
 
 Call this method when you want to tightly the label's view so that it uses the most appropriate amount of space for its text.
 */
-(void)sizeToFit;

/// @name Properties
#pragma mark Properties

/**The text displayed by the label.
 */
@property(nonatomic, strong) NSString *text;

/**The font for the label.
 
 This property applies to the entire text string. The default value for this property is the system font at a size of 17 points (using the systemFontOfSize: class method of C4Font). The value for the property can only be set to a non-nil value; setting this property to nil raises an exception.
 */
@property(nonatomic, strong) C4Font *font;

/**A Boolean value indicating whether the font size should be reduced in order to fit the title string into the label’s bounding rectangle.
 
 Normally, the label text is drawn with the font you specify in the font property. If this property is set to YES, however, and the text in the text property exceeds the label’s bounding rectangle, the receiver starts reducing the font size until the string fits or the minimum font size is reached. This property is effective only when the numberOfLines property is set to 1.
 
 The default value for this property is NO. If you change it to YES, you should also set an appropriate minimum font size by modifying the minimumFontSize property.
 */
@property(nonatomic) BOOL adjustsFontSizeToFitWidth;

/**Controls how text baselines are adjusted when text needs to shrink to fit in the label.
 
 If the adjustsFontSizeToFitWidth property is set to YES, this property controls the behavior of the text baselines in situations where adjustment of the font size is required. The default value of this property is ALIGNBASELINES. This property is effective only when the numberOfLines property is set to 1.
 */
@property(nonatomic) C4BaselineAdjustment baselineAdjustment;

/**A Boolean value indicating whether the receiver should be drawn with a highlight.
 
 Setting this property causes the receiver to redraw with the appropriate highlight state. A subclass implementing a text button might set this property to YES when the user presses the button and set it to NO at other times. In order for the highlight to be drawn, the highlightedTextColor property must contain a non-nil value.
 
 The default value of this property is NO.
 */
@property(nonatomic, getter=isHighlighted) BOOL highlighted;

/**The color of the text.
 
 This property applies to the entire text string. The default value for this property is a black color (set through the blackColor class method of UIColor). The value for the property can only be set to a non-nil value; setting this property to nil raises an exception.
 */
@property(nonatomic, strong) UIColor *textColor;

/**The technique to use for aligning the text.
 
 This property applies to the entire text string. The default value of this property is ALIGNTEXTLEFT.
 */
@property(nonatomic) C4TextAlignment textAlignment;

/**The technique to use for wrapping and truncating the label’s text.
 
 This property is in effect both during normal drawing and in cases where the font size must be reduced to fit the label’s text in its bounding box. For label objects, this property is set to TRUNCATEEND by default.
 */
@property(nonatomic) C4LineBreakMode lineBreakMode;

/**The size of the smallest permissible font with which to draw the label’s text.
 
 When drawing text that might not fit within the bounding rectangle of the label, you can use this property to prevent the receiver from reducing the font size to the point where it is no longer legible.
 
 The default value for this property is 0.0. If you enable font adjustment for the label, you should always increase this value. This property is effective only when the numberOfLines property is set to 1.
 */
@property(nonatomic) CGFloat minimumFontSize;

/**The maximum number of lines to use for rendering text.
 
 This property controls the maximum number of lines to use in order to fit the label’s text into its bounding rectangle. The default value for this property is 1. To remove any maximum limit, and use as many lines as needed, set the value of this property to 0.
 
 If you constrain your text using this property, any text that does not fit within the maximum number of lines and inside the bounding rectangle of the label is truncated using the appropriate line break mode.
 
 When the receiver is resized using the sizeToFit method, resizing takes into account the value stored in this property. For example, if this property is set to 3, the sizeToFit method resizes the receiver so that it is big enough to display three lines of text.
 */
@property(nonatomic) NSUInteger numberOfLines;

/**The highlight color applied to the label’s text.
 
 Subclasses that use labels to implement a type of text button can use the value in this property when drawing the pressed state for the button. This color is applied to the label automatically whenever the highlighted property is set to YES.
 
 The default value of this property is nil .
 */
@property(nonatomic, strong) UIColor *highlightedTextColor;

/**The shadow color of the text.
 
 The default value for this property is nil, which indicates that no shadow is drawn. In addition to this property, you may also want to change the default shadow offset by modifying the shadowOffset property. Text shadows are drawn with the specified offset and color and no blurring.
 
 */
@property(nonatomic, strong) UIColor *textShadowColor;

/**The shadow offset (measured in points) for the text.
 
 The shadow color must be non-nil for this property to have any effect. The default offset size is (0, -1), which indicates a shadow one point above the text. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property(nonatomic) CGSize textShadowOffset;

#pragma mark C4Layer-backed object properties

/**The backing layer of the C4Label object.
 
 This property accessor provides access to the backing layer which is cast to a C4Layer.
 
 @warning *Note:* Instead of calling label.layer, call label.backingLayer
 */
@property(nonatomic, readonly, strong) C4Layer *backingLayer;

/**Specifies the height of the label. Animatable.

 Setting this property will actually change the frame of the object.
 */
@property(nonatomic) CGFloat height;

/**Specifies the width of the label. Animatable.

 Setting this property will actually change the frame of the object.
 */
@property(nonatomic) CGFloat width;
//
///**Specifies the size of the image. Animatable.
//
// Setting this property will actually change the frame of the object.
// */
//@property(nonatomic) CGSize size;

/**The UILabel which is the subview off the receiver.
 */
@property(nonatomic, readonly, strong) UILabel *label;

@end
