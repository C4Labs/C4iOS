//
//  C4Image.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-09.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Control.h"

@interface C4Image : C4Control {
    @private
    UIImage *_uiImage;
    CIImage *_ciImage, *_filteredImage;
    CIContext *filterContext;
}

+(C4Image *)imageNamed:(NSString *)name;
+(C4Image *)imageWithImage:(C4Image *)image;

-(id)initWithImage:(C4Image *)image;
-(id)initWithImageName:(NSString *)name;
-(void)setImage:(C4Image *)image;
-(void)invert;
/**The image displayed in the image view.
 
 The initial value of this property is the image passed into the initWithImage: method or nil if you initialized the receiver using a different method.
  */
-(UIImage *)UIImage;

/**Returns a Core Image representation of the current image.

 If the image data has been purged because of memory constraints, invoking this method forces that data to be loaded back into memory. Reloading the image data may incur a performance penalty.
 */
-(CIImage *)CIImage;

/**The underlying Core Image data. (read-only)
  */
-(CGImageRef)CGImage;

#pragma mark Properties
/// @name Properties
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

@end