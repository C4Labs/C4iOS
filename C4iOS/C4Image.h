//
//  C4Image.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-09.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

/* Filters
 For now I am leaving out the following filters:
 - affineTransform -> easy to put in at a later date, i don't want to bother with semantics of naming the filter method so that it's distinct from image.transform, and i'm lazy today
 - checkerBoardGenerator -> easy to put in at a later date, creating images isn't something i'm interested in atm
 - cicolorcube -> unnecessary for now
 - ciconstantcolorgenerator -> not interested in generators
 - cicrop -> not interested in dealing with cropping and resizing an image right now...
 - cigaussiangradient -> not interested in dealing with generators
 - cilineargradient -> not interested in dealing with generators
 - ciradialgradient -> not interested in dealing with generators
 - cistripesgenerator -> not interested in dealing with generators
 - civignette -> currently undocumented in the ios Core Image Filter Reference
 */

#import "C4Control.h"

/**This document describes the C4Image class. A C4Image object provides access for creating, showing, interacting and manipulating images. C4Image is a subclass of C4Control and so inherits its animation, gesture and notification abilities.
  
 C4Image also takes advantage of its underlying C4Layer to allow for filtering the content of an image. You can apply filters that affect only the image (e.g. hueAdjust, vibranceAdjust, etc.) or use another image as the background for a particular blend or composite filter (e.g. additionComposite:, overlayBlend:, etc). 
 
 When working with blends and composite methods, it is recommended that the images you use are of the same size.
 
*/
@interface C4Image : C4Control {
}

/**Creates and returns a new image using a file with the given name.
 
 @param name A string representation of the file name (e.g. photo.jpg, image.png, etc.)
  */
+(C4Image *)imageNamed:(NSString *)name;

/**Creates and returns a new image using a pre-existing C4Image object.

 @param image A C4Image whose contents will be used to create a new C4Image object.
 */
+(C4Image *)imageWithImage:(C4Image *)image;

/**Initializes an image using a file with the given name.
 
 This method will look for a file with the given name in the application's local directory. If it cannot find the image it will cause an assertion error.

 @param name A string representation of the file name (e.g. photo.jpg, image.png, etc.)
*/
-(id)initWithImageName:(NSString *)name;

/**Initializes a C4Image using the contents of another C4Image

 @param image A C4Image whose contents will be used to create a new C4Image object.
 */
-(id)initWithImage:(C4Image *)image;

/**Sets the current visible representation of a C4Image to that of another image.

 @param image A C4Image whose contents will be used to set the visible representation of the receiver.
 */
-(void)setImage:(C4Image *)image;

#pragma mark Filters
/// @name Filters
/**Addition composite filter
 
 This filter is typically used to add highlights and lens flare effects. The formula used to create this filter is described in Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
 
 @param backgroundImage The image that will provide the background for this filter.
*/
-(void)additionComposite:(C4Image *)backgroundImage;

/**Color blend filter
 Uses the luminance values of the background with the hue and saturation values of the source image.
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)colorBlend:(C4Image *)backgroundImage;

/**Color burn filter
 Darkens the background image samples to reflect the source image samples.
 
 Source image sample values that specify white do not produce a change. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.

 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)colorBurn:(C4Image *)backgroundImage;

/**Color control filter.
 Adjusts saturation, brightness, and contrast values.

 To calculate saturation, this filter linearly interpolates between a grayscale image (saturation = 0.0) and the original image (saturation = 1.0). The filter supports extrapolation: For values large than 1.0, it increases saturation.
 
 To calculate contrast, this filter uses the following formula:
 
 (color.rgb - vec3(0.5)) * contrast + vec3(0.5)
 
 This filter calculates brightness by adding a bias value:
 
 color.rgb + vec3(brightness)

 @param saturation Saturation value defaults to 1.0f, minimum 0.0f, maximum 2.0f
 @param brightness Brightness value defaults to 0.0f, minimum -1.0f, maximum 1.0f
 @param contrast Contrast value defaults to 1.0f, minimum 0.0f, maximum 4.0f
 */
-(void)colorControlSaturation:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast;

/**Color dodge filter.
 
 Brightens the background image samples to reflect the source image samples.
 
 Source image sample values that specify black do not produce a change. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center.

 @param backgroundImage The image that will provide the background for this filter.
*/
-(void)colorDodge:(C4Image *)backgroundImage;

/**Color invert filter.
 Inverts the colors in an image.
 */
-(void)colorInvert;

/**Color matrix filter
 Multiplies source color values and adds a bias factor to each color component.
 
 Given colors are translated to corresponding vectors.
 
 This filter performs a matrix multiplication, as follows, to transform the color vector:
 
 s.r = dot(s, redVector)
 s.g = dot(s, greenVector)
 s.b = dot(s, blueVector)
 s.a = dot(s, alphaVector)
 s = s + bias

 @param color The color whose components will be used in the matrix multiplication
 @param bias The bias value to be used in the matrix multiplication
 */
-(void)colorMatrix:(UIColor *)color bias:(CGFloat)bias;

/**Color monochrome filter.
 Remaps colors so they fall within shades of a single color.

 @param color The color to which the image will be mapped.
 @param intensity The intensity of the mapping, defaults to 1.0f, minimum 0.0f, maximum 1.0f
 */
-(void)colorMonochrome:(UIColor *)color inputIntensity:(CGFloat)intensity;

/**Darken blend filter
 Creates composite image samples by choosing the darker samples (from either the source image or the background).

 The result is that the background image samples are replaced by any source image samples that are darker. Otherwise, the background image samples are left unchanged. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.

 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)darkenBlend:(C4Image *)backgroundImage;

/**Difference blend filter
 Subtracts either the source image sample color from the background image sample color, or the reverse, depending on which sample has the greater brightness value.
 
 Source image sample values that are black produce no change; white inverts the background color values. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.

 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)differenceBlend:(C4Image *)backgroundImage;

/**Exclusion blend filter
 Produces an effect similar to that produced by the Difference Blend filter but with lower contrast.

 Source image sample values that are black do not produce a change; white inverts the background color values. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.

 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)exclusionBlend:(C4Image *)backgroundImage;

/**Exposure adjustment filter
 Adjusts the exposure setting for an image similar to the way you control exposure for a camera when you change the F-stop.

 This filter multiplies the color values, as follows, to simulate exposure change by the specified F-stops:
 
 s.rgb * pow(2.0, ev)

 @param adjustment The level of exposure adjustment, defaults to 0.5, minimum -10.0, maximum 10.0
*/
-(void)exposureAdjust:(CGFloat)adjustment;

/**False color filter
 Maps luminance to a color ramp of two colors.

 False color is often used to process astronomical and other scientific data, such as ultraviolet and x-ray images.
 
 @param color1 A UIColor.
 @param color2 A UIColor.
 */
-(void)falseColor:(UIColor *)color1 color2:(UIColor *)color2;

/**Gamma adjustment filter
 Adjusts midtone brightness.

 This filter is typically used to compensate for nonlinear effects of displays. Adjusting the gamma effectively changes the slope of the transition between black and white. It uses the following formula:
 
 pow(s.rgb, vec3(power))
 
 @param adjustment The level of gamma adjustment, defaults to 0.75, minimum 0.10, maximum 3.0
 */
-(void)gammaAdjustment:(CGFloat)adjustment;

/**Hard light blend filter
 Either multiplies or screens colors, depending on the source image sample color.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)hardLightBlend:(C4Image *)backgroundImage;

/**Highlight and shadow adjustment filter
 Adjust the tonal mapping of an image while preserving spatial detail.

 @param highlightAmount The adjustment value for image highlights, defaults to 1.0, minimum 0.0, maximum 1.0
 @param shadowAmount The adjustment value for image shadows, defaults to 0.0, minimum -1.0, maximum 1.0
 */
-(void)highlightShadowAdjust:(CGFloat)highlightAmount shadowAmount:(CGFloat)shadowAmount;

/**Hue adjustment filter
 Changes the overall hue, or tint, of the source pixels.

 This filter essentially rotates the color cube around the neutral axis.
 
 @param angle The angular value to calculate the adjustment, defaults to 0.0, minimum -PI, maximum PI
 */
-(void)hueAdjust:(CGFloat)angle;

/**Hue blend filter
 Uses the luminance and saturation values of the background with the hue of the source image.
 
 The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification. 
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)hueBlend:(C4Image *)backgroundImage;

/**Lighten blend filter
 Creates composite image samples by choosing the lighter samples (either from the source image or the background).
 
 The result is that the background image samples are replaced by any source image samples that are lighter. Otherwise, the background image samples are left unchanged. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)lightenBlend:(C4Image *)backgroundImage;

/**Luminosity blend filter
 Uses the hue and saturation of the background with the luminance of the source image.
 
 This mode creates an effect that is inverse to the effect created by the CIColorBlendMode filter. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)luminosityBlend:(C4Image *)backgroundImage;

/**Maximum compositing filter
 Computes the maximum value, by color component, of two input images and creates an output image using the maximum values.
 
 This is similar to dodging. The formula used to create this filter is described in Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)maximumComposite:(C4Image *)backgroundImage;

/**Minimum compositing filter
 Computes the minimum value, by color component, of two input images and creates an output image using the minimum values.
 
 This is similar to burning. The formula used to create this filter is described in Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)minimumComposite:(C4Image *)backgroundImage;

/**Multiply blend filter
 Multiplies the source image samples with the background image samples.
 
 This results in colors that are at least as dark as either of the two contributing sample colors. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)multiplyBlend:(C4Image *)backgroundImage;

/**Multiply compositing filter
 Multiplies the color component of two input images and creates an output image using the multiplied values.
 
 This filter is typically used to add a spotlight or similar lighting effect to an image. The formula used to create this filter is described in Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)multiplyComposite:(C4Image *)backgroundImage;

/**Overlay blend filter
 Either multiplies or screens the source image samples with the background image samples, depending on the background color.
 
 The result is to overlay the existing image samples while preserving the highlights and shadows of the background. The background color mixes with the source image to reflect the lightness or darkness of the background. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)overlayBlend:(C4Image *)backgroundImage;

/**Saturation blend filter
 Uses the luminance and hue values of the background with the saturation of the source image.
 
 Areas of the background that have no saturation (that is, pure gray areas) do not produce a change. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)saturationBlend:(C4Image *)backgroundImage;

/**Screen blend filter
 Multiplies the inverse of the source image samples with the inverse of the background image samples.
 
 This results in colors that are at least as light as either of the two contributing sample colors. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)screenBlend:(C4Image *)backgroundImage;

/**Sepia tone filter
 Maps the colors of an image to various shades of brown.

 @param intensity The level of intensity for which to apply the sepia tone, defaults to 1.0, minimum 0.0, maximum 1.0 
 */
-(void)sepiaTone:(CGFloat)intensity;

/**Soft light blend filter
 Either darkens or lightens colors, depending on the source image sample color.
 
 If the source image sample color is lighter than 50% gray, the background is lightened, similar to dodging. If the source image sample color is darker than 50% gray, the background is darkened, similar to burning. If the source image sample color is equal to 50% gray, the background is not changed. Image samples that are equal to pure black or pure white produce darker or lighter areas, but do not result in pure black or white. The overall effect is similar to what you would achieve by shining a diffuse spotlight on the source image. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center. See PDF Reference and Adobe Extensions to the PDF Specification.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)softLightBlend:(C4Image *)backgroundImage;

/**Source-atop compositing filter
 Places the source image over the background image, then uses the luminance of the background image to determine what to show.
 
 The composite shows the background image and only those portions of the source image that are over visible parts of the background. The formula used to create this filter is described in Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)sourceAtopComposite:(C4Image *)backgroundImage;

/**Source-in compositing filter
 Uses the background image to define what to leave in the source image, effectively cropping the image.
 
 The formula used to create this filter is described in Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)sourceInComposite:(C4Image *)backgroundImage;

/**Source-out compositing filter
 Uses the background image to define what to take out of the first image.
 
 The formula used to create this filter is described in Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)sourceOutComposite:(C4Image *)backgroundImage;

/**Source-over compositing filter
 Places the background image over the source image.
 
 The formula used to create this filter is described in Thomas Porter and Tom Duff. 1984. Compositing Digital Images. Computer Graphics, 18 (3): 253-259.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)sourceOverComposite:(C4Image *)backgroundImage;

/**Straighten filter
 Rotates the source image by the specified angle in radians.

 The image is scaled and cropped so that the rotated image fits the extent of the source image.

 @param angle The angular value to calculate the adjustment, defaults to 0.0, minimum -PI, maximum PI
*/
-(void)straighten:(CGFloat)angle;

/**Temperature and tint filter 
 Adapts the reference white point for an image.
 
 @param neutral An offset value, defaults to {6500,0}
 @param targetNeutral An target offset value, defaults to {6500,0}
 */
-(void)tempartureAndTint:(CGSize)neutral target:(CGSize)targetNeutral;

/**Tone curve filter
 Adjusts tone response of the R, G, and B channels of an image.
 
 The input points are five x,y values that are interpolated using a spline curve. The curve is applied in a perceptual (gamma 2) version of the working space.

 An example of how to construct the point array : CGPoint *pointArray = {CGPointMake(),CGPointMake(),CGPointMake(),CGPointMake(),CGPointMake()};
 
 The five points default to the following:

 - point1: { 0.0, 0.0}
 - point2: {0.25, 0.25}
 - point3: { 0.5, 0.5};
 - point4: {0.75, 0.75};
 - point5: { 1.0, 1.0};
 
 @param pointArray A C-Array of CGPoints which will be used to construct the tone curve
 */
 -(void)toneCurve:(CGPoint *)pointArray;

/**Vibrance adjustment filter
 Adjusts the saturation of an image while keeping pleasing skin tones.

 @param amount The amount to adjust the image's vibrance, defaults to 0.0, minimum -1.0, maximum 1.0
 */
-(void)vibranceAdjust:(CGFloat)amount;

/*White point adjustment filter
 Adjusts the reference white point for an image and maps all colors in the source using the new reference.

 @param color The reference color for the new mapping.
 */
-(void)whitePointAdjust:(UIColor *)color;

#pragma mark Properties
/// @name Properties
/**The image displayed in the image view.
 
 The initial value of this property is the image passed into the initWithImage: method or nil if you initialized the receiver using a different method.
 
 @warning The object returned from this property was made with a CIImage, so calling returnedUIImage.CGImage on the returned object will return NULL.
  */
@property (readonly, weak, nonatomic) UIImage *UIImage;

/**Returns a Core Image representation of the current image.

 If the image data has been purged because of memory constraints, invoking this method forces that data to be loaded back into memory. Reloading the image data may incur a performance penalty.
 
 @warning: The CIImage is the object off of which we base all other image manipulations and returns.
 */
@property (readonly, weak, nonatomic) CIImage *CIImage;

/**The underlying Core Image data. (read-only)
  */
@property (readonly, nonatomic) CGImageRef CGImage;

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