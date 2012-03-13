//
//  C4Label.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

/** The C4Label class implements a read-only text view. You can use this class to draw one or multiple lines of static text, such as those you might use to identify other parts of your user interface. The base C4Label class provides control over the appearance of your text, including whether it uses a shadow or draws with a highlight. If needed, you can customize the appearance of your text further by subclassing.
 
 C4Label is a subclass of C4Control, and so inherits all the functionality of animation and interaction provided by C4Control. It encapsulates a UILabel and provides all the necessary methods to access and manipulate its label. 
 
 Unlike [C4Shape](C4Shape), which has an underlying backing layer, C4Label adds its encapsulated UILabel as a subview.
 */
@interface C4Label : C4Control {
}

+(C4Label *)labelWithText:(NSString *)text;
+(C4Label *)labelWithText:(NSString *)text andFont:(C4Font *)font;

-(id)initWithText:(NSString *)text;
-(id)initWithText:(NSString *)text andFont:(C4Font *)font;

/// @name Custom
#pragma mark Custom
-(void)sizeToFit;

/// @name Properties
#pragma mark Properties
@property (readonly, strong, nonatomic) UILabel *label;
/**The text displayed by the label.
 
 This string is nil by default.
 */
@property (readwrite, strong, nonatomic) NSString *text;

/**The font of the text.
 
 This property applies to the entire text string. The default value for this property is the system font at a size of 17 points (using the systemFontOfSize: class method of C4Font). The value for the property can only be set to a non-nil value; setting this property to nil raises an exception.
 */
@property (readwrite, strong, nonatomic) C4Font *font;

/**A Boolean value indicating whether the font size should be reduced in order to fit the title string into the label’s bounding rectangle.
 
 Normally, the label text is drawn with the font you specify in the font property. If this property is set to YES, however, and the text in the text property exceeds the label’s bounding rectangle, the receiver starts reducing the font size until the string fits or the minimum font size is reached. This property is effective only when the numberOfLines property is set to 1.
 
 The default value for this property is NO. If you change it to YES, you should also set an appropriate minimum font size by modifying the minimumFontSize property.
*/
@property (readwrite, nonatomic) BOOL adjustsFontSizeToFitWidth;

/**Controls how text baselines are adjusted when text needs to shrink to fit in the label.

 If the adjustsFontSizeToFitWidth property is set to YES, this property controls the behavior of the text baselines in situations where adjustment of the font size is required. The default value of this property is ALIGNBASELINES. This property is effective only when the numberOfLines property is set to 1.
 */
@property (readwrite, nonatomic) C4BaselineAdjustment baselineAdjustment;

/**A Boolean value indicating whether the receiver should be drawn with a highlight.
 
 Setting this property causes the receiver to redraw with the appropriate highlight state. A subclass implementing a text button might set this property to YES when the user presses the button and set it to NO at other times. In order for the highlight to be drawn, the highlightedTextColor property must contain a non-nil value.
 
 The default value of this property is NO.
 */
@property (nonatomic, getter=isHighlighted) BOOL highlighted;

/**The color of the text.
 
 This property applies to the entire text string. The default value for this property is a black color (set through the blackColor class method of UIColor). The value for the property can only be set to a non-nil value; setting this property to nil raises an exception.
 */
@property (readwrite, strong, nonatomic) UIColor *textColor;

/**The technique to use for aligning the text.
 
 This property applies to the entire text string. The default value of this property is ALIGNTEXTLEFT.
 */
@property (readwrite, nonatomic) C4TextAlignment textAlignment;

/**The technique to use for wrapping and truncating the label’s text.
 
 This property is in effect both during normal drawing and in cases where the font size must be reduced to fit the label’s text in its bounding box. For label objects, this property is set to TRUNCATEEND by default.
 */
@property (readwrite, nonatomic) C4LineBreakMode lineBreakMode;

/**The size of the smallest permissible font with which to draw the label’s text.
 
 When drawing text that might not fit within the bounding rectangle of the label, you can use this property to prevent the receiver from reducing the font size to the point where it is no longer legible.
 
 The default value for this property is 0.0. If you enable font adjustment for the label, you should always increase this value. This property is effective only when the numberOfLines property is set to 1.
 */
@property (readwrite, nonatomic) CGFloat minimumFontSize;

/**The maximum number of lines to use for rendering text.
 
 This property controls the maximum number of lines to use in order to fit the label’s text into its bounding rectangle. The default value for this property is 1. To remove any maximum limit, and use as many lines as needed, set the value of this property to 0.
 
 If you constrain your text using this property, any text that does not fit within the maximum number of lines and inside the bounding rectangle of the label is truncated using the appropriate line break mode.
 
 When the receiver is resized using the sizeToFit method, resizing takes into account the value stored in this property. For example, if this property is set to 3, the sizeToFit method resizes the receiver so that it is big enough to display three lines of text.
 */
@property (readwrite, nonatomic) NSUInteger numberOfLines;

/**The highlight color applied to the label’s text.
 
 Subclasses that use labels to implement a type of text button can use the value in this property when drawing the pressed state for the button. This color is applied to the label automatically whenever the highlighted property is set to YES.
 
 The default value of this property is nil .
 */
@property (readwrite, strong, nonatomic) UIColor *highlightedTextColor;

/**The shadow color of the text.
 
 The default value for this property is nil, which indicates that no shadow is drawn. In addition to this property, you may also want to change the default shadow offset by modifying the shadowOffset property. Text shadows are drawn with the specified offset and color and no blurring.
 
 */
@property (readwrite, strong, nonatomic) UIColor *textShadowColor;

/**The shadow offset (measured in points) for the text.
 
 The shadow color must be non-nil for this property to have any effect. The default offset size is (0, -1), which indicates a shadow one point above the text. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property (readwrite, nonatomic) CGSize textShadowOffset;

/**Specifies the blur radius used to render the receiver’s shadow. 
 
 This applies to the shadow of the contents of the layer, and not specifically the text.
 */
@property (readwrite, nonatomic) CGFloat shadowRadius;

/**Specifies the opacity of the receiver’s shadow. Animatable.
 
 This applies to the shadow of the contents of the layer, and not specifically the text.
 */
@property (readwrite, nonatomic) CGFloat shadowOpacity;
/**The shadow color of the text.
 
 The default value for this property is nil, which indicates that no shadow is drawn. In addition to this property, you may also want to change the default shadow offset by modifying the shadowOffset property. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property (readwrite, strong, nonatomic) UIColor *shadowColor;

/**The shadow offset (measured in points) for the text.
 
 The shadow color must be non-nil for this property to have any effect. The default offset size is (0, -1), which indicates a shadow one point above the text. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property (readwrite, nonatomic) CGSize shadowOffset;

/**Defines the shape of the shadow. Animatable.
 
 Unlike most animatable properties, shadowPath does not support implicit animation. 
 
 If the value in this property is non-nil, the shadow is created using the specified path instead of the layer’s composited alpha channel. The path defines the outline of the shadow. It is filled using the non-zero winding rule and the current shadow color, opacity, and blur radius.
 
 Specifying an explicit path usually improves rendering performance.
 
 The default value of this property is NULL.
 */
@property (readwrite, nonatomic) CGPathRef shadowPath;

#pragma mark C4Layer-backed object properties

/**The backing layer of the C4Label object.
 
 This property accessor provides access to the backing layer which is cast to a C4Layer.
 
 @warning *Note:* Instead of calling label.layer, call label.backingLayer
 */
@property (readonly, weak, nonatomic) C4Layer *backingLayer;

@end