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

/**This document describes the C4Image class. A C4Image object provides access for creating, showing, interacting and manipulating images. C4Image is a subclass of C4Control and so inherits its animation, gesture and notification abilities.
 
 C4Image also takes advantage of its underlying C4Layer to allow for filtering the content of an image. You can apply filters that affect only the image (e.g. hueAdjust, vibranceAdjust, etc.) or use another image as the background for a particular blend or composite filter (e.g. additionComposite:, overlayBlend:, etc).
 
 When working with blends and composite methods, it is recommended that the images you use are of the same size.
 
 */
@interface C4Image : C4Control

#pragma mark - Creating Images
///@name Creating Images
/**Creates and returns a new image using a file with the given name.
 
 @param name A string representation of the file name (e.g. photo.jpg, image.png, etc.)
 */
+ (instancetype)imageNamed:(NSString *)name;

/**Creates and returns a new image using a pre-existing C4Image object.
 
 @param image A C4Image whose contents will be used to create a new C4Image object.
 */
+ (instancetype)imageWithImage:(C4Image *)image;

/**Creates and returns a new image using an NSData object.
 
 @param imageData An NSData object.
 */
+ (instancetype)imageWithData:(NSData *)imageData;

/**Creates and returns a new image using an UIImage object.
 
 @param image a UIImage used to create the C4Image.
 */
+ (instancetype)imageWithUIImage:(UIImage *)image;

/**Creates and returns a new image using an URL.
 
 The URL should point directly to an image resource  (PNG, JPEG, etc..), this URL can be online or somewhere else on the system. If the URL is online make sure that the device is connected to a wifi network.
 
 @param imageURL the URL for the file used to create the image.
 */
+ (instancetype)imageWithURL:(NSString *)imageURL;

/**Creates and returns a new animated image from an array of image file names.
 
 @param imageNames An NSArray of image names (e.g. C4Sky, C4Table@2x.png, etc.) used to construct the images for the animation.
 @return a new animatable image.
 */
+ (instancetype)animatedImageWithNames:(NSArray *)imageNames;

/**Initializes an image using a file with the given name.
 
 This method will look for a file with the given name in the application's local directory. If it cannot find the image it will cause an assertion error.
 
 @param name A string representation of the file name (e.g. photo.jpg, image.png, etc.)
 */
-(id)initWithImageName:(NSString *)name;

/**Initializes a C4Image using the contents of another C4Image
 
 @param image A C4Image whose contents will be used to create a new C4Image object.
 */
-(id)initWithImage:(C4Image *)image;

/**Initializes a C4Image using an NSData object
 
 @param imageData an NSData object
 */
-(id)initWithData:(NSData *)imageData;

/**Initializes a C4Image using an array of raw data.
 
 The raw data is assumed to be RGBA with 8 bits per component.
 
 @param data An `unsigned char` data array of values
 @param width The width of the image to create
 @param height The height of the image to create
 */
-(id)initWithRawData:(unsigned char *)data width:(NSInteger)width height:(NSInteger)height;

/**Initializes a C4Image using a CGImageRef object
 
 @param image A CGImageRef whose contents will be used to create a new C4Image object.
 */
-(id)initWithCGImage:(CGImageRef)image;

/**Initializes a C4Image using a UIImage object
 
 @param image A UIImage whose contents will be used to create a new C4Image object.
 */
-(id)initWithUIImage:(UIImage *)image;

/**Initializes and returns a new image using an URL.
 
 The URL should point directly to an image resource  (PNG, JPEG, etc..), this URL can be online or somewhere else on the system. If the URL is online make sure that the device is connected to a wifi network.
 
 @param imageURL the URL for the file used to create the image.
 */
-(id)initWithURL:(NSURL *)imageURL;

/**Initializes and returns a new animated image from an array of image file names.
 
 @param imageNames An NSArray of image names (e.g. C4Sky, C4Table@2x.png, etc.) used to construct the images for the animation.
 @return a new animatable image.
 */
-(id)initAnimatedImageWithNames:(NSArray *)imageNames;

#pragma mark - Animated Images
///@name Animated Images
/**Specifies the array of images used for animating.
 
 This array is filled when the animatedImage is created using the appropriate constructor.
 */
@property(nonatomic, copy) NSArray *animationImages;

/**Specifies the duration for the entire animation.
 
 Setting this value, the animatedImage will automatically calculate how long each image in its array will be visible.
 
 The duration for each image is consistent, for example a 2-second animation consisting of 10 frames will display each image for 0.2 seconds.
 */
@property(nonatomic) CGFloat animatedImageDuration;

/**Specifies the number of times to repeat the animation.
 The default value is 0, which specifies to repeat the animation indefinitely.
 */
@property(nonatomic) NSInteger animationRepeatCount;

/**Starts animating the images in the receiver.
 
 This method always starts the animation from the first image in the list.
 */
-(void)play;

/**Stops animating the images in the receiver.
 */
-(void)pause;

/**Returns a Boolean value indicating whether the animation is running.
 
 YES if the animation is running; otherwise, NO.
 */
@property(nonatomic, readonly, getter = isAnimating) BOOL animating;

#pragma mark - Set Image
///@name Set Image
/**Sets the current visible representation of a C4Image to that of another image.
 
 @param image A C4Image whose contents will be used to set the visible representation of the receiver.
 */
-(void)setImage:(C4Image *)image;

#pragma mark - Pixels & Colors
///@name Pixels & Colors
/**Loads a raw character array with color data.
 
 This will load the array one time, and must be called before colorAt: or rgbVectorAt:
 */
-(void)loadPixelData;

/**Creates and returns a UIColor object from the specified coordinate in the image.
 
 @param point The coordinate in the image from which to pull color values
 */
-(UIColor *)colorAt:(CGPoint)point;

/**Creates and returns a C4Vector object containing 4 points mapping to the RGBA value from the specified coordinate in the image.
 
 @param point The coordinate in the image from which to pull color values
 */
-(C4Vector *)rgbVectorAt:(CGPoint)point;

#pragma mark - Properties
/// @name Properties
/**The image displayed in the image view.
 
 The initial value of this property is the image passed into the initWithImage: method or nil if you initialized the receiver using a different method.
 
 @warning The object returned from this property was made with a CIImage, so calling returnedUIImage.CGImage on the returned object will return NULL.
 */
@property(nonatomic, readonly, strong) UIImage *UIImage;

/**Returns a Core Image representation of the current image.
 
 If the image data has been purged because of memory constraints, invoking this method forces that data to be loaded back into memory. Reloading the image data may incur a performance penalty.
 
 @warning: The CIImage is the object off of which we base all other image manipulations and returns.
 */
@property(nonatomic, readonly, strong) CIImage *CIImage;

/**The underlying Core Image data. (read-only)
 */
@property(nonatomic, readonly) CGImageRef CGImage;

/**Specifies the height of the image. Animatable.
 
 Setting this property will actually change the frame of the object.
 */
@property(nonatomic) CGFloat height;

/**Specifies the width of the image. Animatable.
 
 Setting this property will actually change the frame of the object.
 */
@property(nonatomic) CGFloat width;

/**Specifies the size of the image. Animatable.
 
 Setting this property will actually change the frame of the object.
 */
@property(nonatomic) CGSize size;

/**Specifies the original size of the of the image.
 */
@property(nonatomic, readonly) CGSize originalSize;

/**Specifies the original ratio (width / height) of the image.
 */
@property(nonatomic, readonly) CGFloat originalRatio;

/**Specifies whether or not the image has loaded its pixel data.
 */
@property(nonatomic, readonly) BOOL pixelDataLoaded;

/**Specifies whether or not the image will maintain its current proportions when scaling either its width or height values.
 */
@property(nonatomic) BOOL constrainsProportions;

/**The contets of the image's layer (i.e. the visible image as a CGImageRef).
 */
@property(nonatomic) CGImageRef contents;

#pragma mark - Working With Filters
/// @name Working With Filters

/**A list of all availble filters using the CI prefix.
 
 This method creates an array of all filters available on iOS. It does this by calling filterNamesInCategory: on a list of all available filter categories. Each entry is returned as the actual Core Image reference name, for example the boxBlur filter is called CIBoxBlur.
 
 The array of filters is sorted alphabetically.
 
 @return An array of available filters, by name.
 */
+(NSArray *)availableFilters;

/**Specifies whether or not an image will process one or many filters at a time.
 
 If NO, then running a filter method on an image will render it immediately.
 
 If YES, then you must wrap your filter calls in calls to startFiltering, and renderFilteredImage like so:
 
 img.multipleFilterEnabled = YES;
 [img startFiltering];
 [img filter1];
 [img filter2];
 [img filter3];
 [img renderFilteredImage];
 */
@property(nonatomic, readonly, getter = isMultipleFilterEnabled) BOOL multipleFilterEnabled;

/**Sets the receiver to allow multiple filters before rendering.
 
 Essentially, this method prevents automatic render after individual filters have completed.
 */
-(void)startFiltering;

/**Renders the current image's filter stack.
 
 Calling this method will composite all previously called filters and then switch the reciever's contents to the new filtered image.
 */
-(void)renderFilteredImage;

/**Specifies whether the activity indicator for this image should show.
 
 Filtering can take some time and it happens on the background thread so it sometimes looks like nothing is happening after a call to render filters is executed. By default, the reciever will show a spinning activity indicator for the duration that the filter takes to render before switching its own contents.
 */
@property(nonatomic) BOOL showsActivityIndicator;

#pragma mark - Filters By Task
/// @name Filters By Task
/**Please note that as of June 2013, we have implemented the following filters but have not had the opportunity to fully test them all. Some behaviours may be unpredictable.
 
 Bugs can be submitted to the C4iOS project on GitHub:
 https://github.com/C4framework/C4iOS/issues
 */

#pragma mark - Blurs
/// @name Blurs
/**Blurs an image using a box-shaped convolution kernel.
 
 @param radius a CGFloat representing the length of the radius for the blur. Default value: 10.00
 */
-(void)boxBlur:(CGFloat)radius;

/**Blurs an image using a disc-shaped convolution kernel.
 
 @param radius a CGFloat representing the length of the radius for the blur. Default value: 8.00
 */
-(void)discBlur:(CGFloat)radius;

/**Spreads source pixels by an amount specified by a Gaussian distribution.
 
 @param radius a CGFloat representing the length of the radius for the blur. Default value: 10.00
 */
-(void)gaussianBlur:(CGFloat)radius;

/**Computes the median value for a group of neighboring pixels and replaces each pixel value with the median.
 
 The effect is to reduce noise.
 */
-(void)medianFilter;

/**Blurs an image to simulate the effect of using a camera that moves a specified angle and distance while capturing the image.
 
 @param radius a CGFloat representing the length of the radius for the blur. Default value: 20.00
 @param angle a CGFloat representing the angle of the blur (in radians).
 */
-(void)motionBlur:(CGFloat)radius angle:(CGFloat)angle;

/**Reduces noise using a threshold value to define what is considered noise.
 
 Small changes in luminance below that value are considered noise and get a noise reduction treatment, which is a local blur. Changes above the threshold value are considered edges, so they are sharpened.
 
 @param level A CGFloat representing the threshold to use for determining noise. Default value: 0.02
 @param sharpness A CGFloat representing the sharpness to apply to the filter. Default value: 0.40
 */
-(void)noiseRedution:(CGFloat)level sharpness:(CGFloat)sharpness;

/**Simulates the effect of zooming the camera while capturing the image.
 
 @param center A CGPoint representing the center of the zoom. Default value {150,150}
 @param amount The amount of zoom to apply. Default value 20.0
 */
-(void)zoomBlur:(CGPoint)center amount:(CGFloat)amount;

#pragma mark - Color Adjustments
/// @name Color Adjustments
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
-(void)colorControlSaturation:(CGFloat)saturation brightness:(CGFloat)brightness contrast:(CGFloat)contrast  NS_AVAILABLE_IOS(5_0);

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

/**Exposure adjustment filter
 Adjusts the exposure setting for an image similar to the way you control exposure for a camera when you change the F-stop.
 
 This filter multiplies the color values, as follows, to simulate exposure change by the specified F-stops:
 
 s.rgb * pow(2.0, ev)
 
 @param adjustment The level of exposure adjustment, defaults to 0.5, minimum -10.0, maximum 10.0
 */
-(void)exposureAdjust:(CGFloat)adjustment;

/**Gamma adjustment filter
 Adjusts midtone brightness.
 
 This filter is typically used to compensate for nonlinear effects of displays. Adjusting the gamma effectively changes the slope of the transition between black and white. It uses the following formula:
 
 pow(s.rgb, vec3(power))
 
 @param adjustment The level of gamma adjustment, defaults to 0.75, minimum 0.10, maximum 3.0
 */
-(void)gammaAdjustment:(CGFloat)adjustment;

/**Hue adjustment filter
 Changes the overall hue, or tint, of the source pixels.
 
 This filter essentially rotates the color cube around the neutral axis.
 
 @param angle The angular value to calculate the adjustment, defaults to 0.0, minimum -PI, maximum PI
 */
-(void)hueAdjust:(CGFloat)angle;

/**Temperature and tint filter
 Adapts the reference white point for an image.
 
 @param neutral An offset value, defaults to {6500,0}
 @param targetNeutral An target offset value, defaults to {6500,0}
 */
-(void)temperatureAndTint:(CGSize)neutral target:(CGSize)targetNeutral;

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

#pragma mark - Color Effects
///@name Color Effects
/**Uses a three-dimensional color table to transform the source image pixels.
 
 This filter applies a mapping from RGB space to new color values that are defined in inputCubeData. For each RGBA pixel in inputImage the filter uses the R,G and B values to index into a thee dimensional texture represented by inputCubeData. inputCubeData contains floating point RGBA cells that contain linear premultiplied values. The data is organized into inputCubeDimension number of xy planes, with each plane of size inputCubeDimension by inputCubeDimension. Input pixel components R and G are used to index the data in x and y respectively, and B is used to index in z. In inputCubeData the R component varies fastest, followed by G, then B.
 
 @param dimension A CGFloat representing the number of XY planes used to create the resulting image. The size of the planes are dimension x dimension. Default value: 2.00
 @param data An NSData object that represents a three-dimensional texture.
 */
-(void)colorCube:(CGFloat)dimension cubeData:(NSData *)data;

/**Color invert filter.
 
 Inverts the colors in an image.
 */
-(void)colorInvert;

/**Performs a nonlinear transformation of source color values using mapping values provided in a table.
 
 @param gradientImage The image that provides the basis for the color map transformation.
 */
-(void)colorMap:(C4Image *)gradientImage;

/**Color monochrome filter.
 Remaps colors so they fall within shades of a single color.
 
 @param color The color to which the image will be mapped.
 @param intensity The intensity of the mapping, defaults to 1.0f, minimum 0.0f, maximum 1.0f
 */
-(void)colorMonochrome:(UIColor *)color inputIntensity:(CGFloat)intensity;

/**Remaps red, green, and blue color components to the number of brightness values you specify for each color component.
 
 This filter flattens colors to achieve a look similar to that of a silk-screened poster.
 
 @param levels A CGFloat representing the level of posterize effect to be applied to the image. Default value: 6.00
 */
-(void)colorPosterize:(CGFloat)levels;

/**False color filter
 Maps luminance to a color ramp of two colors.
 
 False color is often used to process astronomical and other scientific data, such as ultraviolet and x-ray images.
 
 @param color1 A UIColor.
 @param color2 A UIColor.
 */
-(void)falseColor:(UIColor *)color1 color2:(UIColor *)color2;

/**Converts a grayscale image to a white image that is masked by alpha.
 
 The white values from the source image produce the inside of the mask; the black values become completely transparent.
 
 To use this method you would take a black and white image, apply this filter to it, and then use the results as the mask for another object.
 */
-(void)maskToAlpha;

/**Returns a grayscale image from max(r,g,b).
 */
-(void)maximumComponent;

/**Returns a grayscale image from min(r,g,b).
 */
-(void)minimumComponent;

/**Sepia tone filter
 Maps the colors of an image to various shades of brown.
 
 @param intensity The level of intensity for which to apply the sepia tone, defaults to 1.0, minimum 0.0, maximum 1.0
 */
-(void)sepiaTone:(CGFloat)intensity;

/**Reduces the brightness of an image at the periphery.
 
 @param radius A CGFloat representing the radius for the vignette.
 @param intensity A CGFloat representing the intensity of the vignette.
 */
-(void)vignette:(CGFloat)radius intensity:(CGFloat)intensity;

#pragma mark - Composite Operations
/// @name Composite Operations
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

/**Color dodge filter.
 
 Brightens the background image samples to reflect the source image samples.
 
 Source image sample values that specify black do not produce a change. The formula used to create this filter is described in the PDF specification, which is available online from the Adobe Developer Center.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)colorDodge:(C4Image *)backgroundImage;

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

/**Hard light blend filter
 Either multiplies or screens colors, depending on the source image sample color.
 
 @param backgroundImage The image that will provide the background for this filter.
 */
-(void)hardLightBlend:(C4Image *)backgroundImage;

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

#pragma mark - Distortion Effects
/// @name Distortion Effects
/**Creates a bump that originates at a specified point in the image.
 
 The bump can be concave or convex.
 
 @param center A CGPoint marking the center of the bump.
 @param radius A CGFloat specifying the radius of the bump.
 @param scale A CGFloat marking the positive or negative scale of the bump.
 */
-(void)bumpDistortion:(CGPoint)center radius:(CGFloat)radius scale:(CGFloat)scale;

/**Creates a concave or convex distortion that originates from a line in the image.
 
 @param center A CGPoint marking the center of the bump.
 @param radius A CGFloat specifying the radius of the bump.
 @param angle A GFloat specifying the angle of the line, in radians.
 @param scale A CGFloat marking the positive or negative scale of the bump.
 */
-(void)bumpDistortionLinear:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle scale:(CGFloat)scale;

/**Distorts the pixels starting at the circumference of a circle and emanating outward.
 
 @param center A CGPoint marking the center of the circle.
 @param radius A CGFloat specifying the radius of the circle.
 */
-(void)circleSplashDistortion:(CGPoint)center radius:(CGFloat)radius;

/**Recursively draws a portion of an image in imitation of an M. C. Escher drawing.
 
 @param inset1 The top-left corner of the portion of the image to repeat.
 @param inset2 The bottom-right corner of the portion of the image to repeat.
 @param radius The radius of the repetition.
 @param periodicity The period of the repetition.
 @param rotation The rotation angle of the portion of the image to be repeated.
 @param zoom The zoom level for the repetition.
 */
-(void)droste:(CGPoint)inset1 inset2:(CGPoint)inset2 strandRadius:(CGFloat)radius periodicity:(CGFloat)periodicity rotation:(CGFloat)rotation zoom:(CGFloat)zoom;

/**Applies the grayscale values of the second image to the first image.
 
 The output image has a texture defined by the grayscale values.
 
 @param displacementImage The second image to use as the basis for distortion the receiver.
 @param scale The scale of the effect on the receiver's image.
 */
-(void)displacementDistortion:(C4Image *)displacementImage scale:(CGFloat)scale;

/**Creates a circular area that pushes the image pixels outward, distorting those pixels closest to the circle the most
 
 @param center The center point of the hole.
 @param radius The radius of the hole.
 */
-(void)holeDistortion:(CGPoint)center radius:(CGFloat)radius;

/**Rotates a portion of the input image specified by the center and radius parameters to give a tunneling effect.
 
 @param center The center point of the light tunnel distortion.
 @param rotation The rotation angle of the distortion.
 @param radius The radius of the invisible circle around which the distortion will be stretched.
 */
-(void)lightTunnel:(CGPoint)center rotation:(CGFloat)rotation radius:(CGFloat)radius;

/**Creates a rectangular-shaped area that pinches source pixels inward, distorting those pixels closest to the rectangle the most.
 
 @param center The center point of the pinch distortion.
 @param radius The radius of the pinch.
 @param scale The scale of the pinch. This value must greater than 0.0 and less than 2.0
 */
-(void)pinchDistortion:(CGPoint)center radius:(CGFloat)radius scale:(CGFloat)scale;

/**Creates a torus-shaped lens and distorts the portion of the image over which the lens is placed.
 
 @param center The center of the torus.
 @param radius The radius of the torus.
 @param width The width of the band of the torus.
 @param refraction The level of refraction seen through the torus.
 */
-(void)torusLensDistortion:(CGPoint)center radius:(CGFloat)radius width:(CGFloat)width refraction:(CGFloat)refraction;

/**Rotates pixels around a point to give a twirling effect.
 
 @param center A CGPoint marking the center of the twirl.
 @param radius A CGFloat specifying the radius of the twirl.
 @param angle A GFloat specifying the number of rotations that the twirl will do.
 */
-(void)twirlDistortion:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle;

/**Rotates pixels around a point to simulate a vortex.
 
 @param center A CGPoint marking the center of the vortex.
 @param radius A CGFloat specifying the radius of the vortex.
 @param angle A GFloat specifying the number of rotations that the vortex will do.
 */
-(void)vortexDistortion:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle;

#pragma mark - Generators
/// @name Generators
/**Generates a checkerboard pattern.
 
 You can specify the checkerboard size and colors, and the sharpness of the pattern.
 
 @param size The size of the resulting image, this should be greater than CGPointZero.
 @param center The center of the checkerboard pattern.
 @param color1 The first color of the pattern.
 @param color2 The second color of the pattern.
 @param width The width (and height) of the pattern's squares.
 @param sharpness The sharpness of the edges between the squares.
 
 @return A new C4Image whose contents are a checkerboard pattern of two colors.
 */
+ (instancetype)checkerboard:(CGSize)size center:(CGPoint)center color1:(UIColor *)color1 color2:(UIColor *)color2 squareWidth:(CGFloat)width sharpness:(CGFloat)sharpness;

/**Generates a solid color.
 
 @param size The size of the resulting image, this shold be greater than CGPointZero.
 @param color The color used to generate the image.
 @return A new C4Image whose contents are a solid color.
 */
+ (instancetype)constantColor:(CGSize)size color:(UIColor *)color;
//
///**Simulates a lens flare.
//
// @param size The size of the resulting image, this should be greater than CGPointZero.
// @param center The center of the halo pattern.
// @param color Controls the proportion of red, green, and blue halos.
// @param radius Controls the size of the lens flare.
// @param width Controls the width of the lens flare, that is, the distance between the inner flare and the outer flare.
// @param overlap Controls how much the red, green, and blue halos overlap. A value of 0 means no overlap (a lot of separation). A value of 1 means full overlap (white halos).
// @param strength Controls the brightness of the rainbow-colored halo area.
// @param contrast Controls the contrast of the rainbow-colored halo area.
// @param time Adds a randomness to the lens flare; it causes the flare to "sparkle" as it changes through various time values.
// */
//+ (instancetype)lenticularHalo:(CGSize)size center:(CGPoint)center color:(UIColor *)color haloRadius:(CGFloat)radius haloWidth:(CGFloat)haloWidth haloOverlap:(CGFloat)overlap striationStrength:(CGFloat)strength striationContrast:(CGFloat)contrast time:(CGFloat)time;

/**Generates an image of infinite extent whose pixel values are made up of four independent, uniformly-distributed random numbers in the 0 to 1 range.
 
 @param size The size of the resulting image, this should be greater than CGPointZero.
 */
+ (instancetype)random:(CGSize)size;

#pragma mark - Geometry Adjustments
/// @name Geometry Adjustments
/**Applies an affine transform to an image.
 
 You can scale, translate, or rotate the input image. You can also apply a combination of these operations:
 
 - CGAffineTransformMake
 - CGAffineTransformMakeRotation
 - CGAffineTransformMakeScale
 - CGAffineTransformMakeTranslation
 
 Have a look at the CGAffineTransform Reference in the Organizer for more information.
 
 @param transform A CGAffineTransform.
 */
-(void)affineTransform:(CGAffineTransform)transform;

/**Applies a crop to an image.
 
 The size and shape of the cropped image depend on the rectangle you specify.
 
 @param area A CGRect defined in the receiver's coordinates to which its image will be cropped.
 */
-(void)crop:(CGRect)area;

/**Produces a high-quality, scaled version of a source image.
 
 You typically use this filter to scale down an image.
 
 @param scale A CGFloat specifying the scale you want to which the receiver should downsize.
 @param ratio A CGFloat specifying the new width : height ratio.
 */
-(void)lanczosScaleTransform:(CGFloat)scale aspectRatio:(CGFloat)ratio;

/**Alters the geometry of an image to simulate the observer changing viewing position.
 
 You can use the perspective filter to skew an image.
 
 @param points An array of 4 CGPoints to use for the transform.
 */
-(void)perspectiveTransform:(CGPoint *)points;

/**Straighten filter
 Rotates the source image by the specified angle in radians.
 
 The image is scaled and cropped so that the rotated image fits the extent of the source image.
 
 @param angle The angular value to calculate the adjustment, defaults to 0.0, minimum -PI, maximum PI
 */
-(void)straighten:(CGFloat)angle;


#pragma mark - Gradients
/// @name Gradients
/**Generates a gradient that varies from one color to another using a Gaussian distribution.
 
 @param size The size of the output image.
 @param center The center of the gradient.
 @param innerColor The inner color of the gradient.
 @param outerColor The outer color of the gradient.
 @param radius The radius of the gradient.
 */
+ (instancetype)gaussianGradient:(CGSize)size center:(CGPoint)center innerColor:(UIColor *)innerColor outerColor:(UIColor *)outerColor radius:(CGFloat)radius;

/**Generates a gradient that varies along a linear axis between two defined endpoints.
 
 @param size The size of the output image.
 @param startPoint The start point of the gradient.
 @param endPoint The end point of the gradient.
 @param startColor The start color of the gradient.
 @param endColor The end color of the gradient.
 */
+ (instancetype)linearGradient:(CGSize)size startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint startColor:(UIColor *)startColor endColor:(UIColor *)endColor;

/**Generates a gradient that varies radially between two circles having the same center.
 
 @param size The size of the output image.
 @param center The center of the gradient.
 @param innerRadius The inner radius of the gradient.
 @param outerRadius The outer radius of the gradient.
 @param innerColor The inner color of the gradient.
 @param outerColor The outer color of the gradient.
 */
+ (instancetype)radialGradient:(CGSize)size center:(CGPoint)center innerRadius:(CGFloat)innerRadius outerRadius:(CGFloat)outerRadius innerColor:(UIColor *)innerColor outerColor:(UIColor *)outerColor;

#pragma mark - Halftone Effects
/// @name Halftone Effects
/**Simulates a circular-shaped halftone screen.
 
 @param center The center of the circular screen effect.
 @param width The width of the bands in the effect.
 @param sharpness The sharpness of the edges of the bands in the effect (values from 0.0 to 1.0)
 */
-(void)circularScreen:(CGPoint)center width:(CGFloat)width sharpness:(CGFloat)sharpness;

///**Creates a color, halftoned rendition of the source image, using cyan, magenta, yellow, and black inks over a white page.
// */
//-(void)halftoneCMYK:(CGPoint)center radius:(CGFloat)radius angle:(CGFloat)angle sharpness:(CGFloat)sharpness gcr:(CGFloat)gcr ucr:(CGFloat)ucr;

/**Simulates the dot patterns of a halftone screen.
 
 @param center The center of the dot pattern.
 @param angle The angle of the bands of dots in the effect.
 @param width The width of the dots in the effect.
 @param sharpness The sharpness of the edges of the dots in the effect (values from 0.0 to 1.0)
 */
-(void)dotScreen:(CGPoint)center angle:(CGFloat)angle width:(CGFloat)width sharpness:(CGFloat)sharpness;

/**Simulates the hatched pattern of a halftone screen.
 
 @param center The center of the hatch pattern.
 @param angle The angle of the bands of hatches in the effect.
 @param width The width of the hatches in the effect.
 @param sharpness The sharpness of the edges of the hatches in the effect (values from 0.0 to 1.0)
 */
-(void)hatchedScreen:(CGPoint)center angle:(CGFloat)angle width:(CGFloat)width sharpness:(CGFloat)sharpness;

/**Simulates the line pattern of a halftone screen.
 @param center The center of the line pattern.
 @param angle The angle of the bands of line in the effect.
 @param width The width of the lines in the effect.
 @param sharpness The sharpness of the edges of the lines in the effect (values from 0.0 to 1.0)
 */
-(void)lineScreen:(CGPoint)center angle:(CGFloat)angle width:(CGFloat)width sharpness:(CGFloat)sharpness;

#pragma mark - Sharpen
/// @name Sharpen
/**Increases image detail by sharpening.
 
 It operates on the luminance of the image; the chrominance of the pixels remains unaffected.
 
 @param sharpness The level of sharpness for the filter's effect.
 */
-(void)sharpenLuminance:(CGFloat)sharpness;

/**Increases the contrast of the edges between pixels of different colors in an image.
 
 @param radius The radius of the blending area.
 @param intensity The intensity of the filter's effect.
 */
-(void)unsharpMask:(CGFloat)radius intensity:(CGFloat)intensity;

#pragma mark - Stylize
/// @name Stylize
/**Uses values from a grayscale mask to interpolate between an image and the background.
 
 When a mask value is 0.0, the result is the background. When the mask value is 1.0, the result is the image.
 
 @param backgroundImage The background image that will be revealed by the mask.
 @param maskImage The image to use as the mask (should be black and white).
 */
-(void)blendWithMask:(C4Image *)backgroundImage mask:(C4Image *)maskImage;

/**Softens edges and applies a pleasant glow to an image.
 
 @param radius The radius of the area, per pixel, to which the bloom filter is applied.
 @param intensity The intensity of the filter's effect.
 */
-(void)bloom:(CGFloat)radius intensity:(CGFloat)intensity;

/**Dulls the highlights of an image.
 
 @param radius The radius of the area, per pixel, to which the bloom filter is applied.
 @param intensity The intensity of the filter's effect.
 */
-(void)gloom:(CGFloat)radius intensity:(CGFloat)intensity;

/**Highlight and shadow adjustment filter
 Adjust the tonal mapping of an image while preserving spatial detail.
 
 @param highlightAmount The adjustment value for image highlights, defaults to 1.0, minimum 0.0, maximum 1.0
 @param shadowAmount The adjustment value for image shadows, defaults to 0.0, minimum -1.0, maximum 1.0
 */
-(void)highlightShadowAdjust:(CGFloat)highlightAmount shadowAmount:(CGFloat)shadowAmount;

/**Makes an image blocky by mapping the image to colored squares whose color is defined by the replaced pixels.
 
 @param center The center of the effect.
 @param scale The scale of the pixel sizes after the effect has been applied.
 */
-(void)pixellate:(CGPoint)center scale:(CGFloat)scale;

#pragma mark - Tile Effects
/// @name Tile Effects
/**Performs an affine transform on a source image and then clamps the pixels at the edge of the transformed image, extending them outwards.
 
 This filter performs similarly to the CIAffineTransform filter except that it produces an image with infinite extent. You can use this filter when you need to blur an image but you want to avoid a soft, black fringe along the edges.
 
 @param transform The affine transform you wish to apply prior to clamping the outer edge pixels.
 */
-(void)affineClamp:(CGAffineTransform)transform;

/**Applies an affine transform to an image and then tiles the transformed image.
 
 @param transform The affine transform you wish to apply prior to tiling the transformed image.
 */
-(void)affineTile:(CGAffineTransform)transform;

/**Produces a tiled image from a source image by applying an 8-way reflected symmetry.
 
 @param center The center point of the effect within the image.
 @param angle The angle of the effect.
 @param width The width, along with the center parameter, defines the portion of the image to tile.
 */
-(void)eightFoldReflectedTile:(CGPoint)center angle:(CGFloat)angle width:(CGFloat)width;

/**Produces a tiled image from a source image by applying a 4-way reflected symmetry.
 
 @param center The center point of the effect within the image.
 @param angle The angle of the effect.
 @param acuteAngle The acute angle of the effect.
 @param width The width, along with the center parameter, defines the portion of the image to tile.
 */
-(void)fourFoldReflectedTile:(CGPoint)center angle:(CGFloat)angle acuteAngle:(CGFloat)acuteAngle width:(CGFloat)width;

/**Produces a tiled image from a source image by rotating the source image at increments of 90 degrees.
 
 @param center The center point of the effect within the image.
 @param angle The angle of the effect.
 @param width The width, along with the center parameter, defines the portion of the image to tile.
 */
-(void)fourFoldRotatedTile:(CGPoint)center angle:(CGFloat)angle width:(CGFloat)width;

/**Produces a tiled image from a source image by applying 4 translation operations.
 
 @param center The center point of the effect within the image.
 @param angle The angle of the effect.
 @param acuteAngle The acute angle of the effect.
 @param width The width, along with the center parameter, defines the portion of the image to tile.
 */
-(void)fourFoldTranslatedTile:(CGPoint)center angle:(CGFloat)angle acuteAngle:(CGFloat)acuteAngle width:(CGFloat)width;

/**Produces a tiled image from a source image by translating and smearing the image.
 
 @param center The center point of the effect within the image.
 @param angle The angle of the effect.
 @param width The width, along with the center parameter, defines the portion of the image to tile.
 */
-(void)glideReflectedTile:(CGPoint)center angle:(CGFloat)angle width:(CGFloat)width;

/**Applies a perspective transform to an image and then tiles the result.
 
 @param points A CGPoint array of 4 points defining the space into which the image will be transformed prior to tiling.
 */
-(void)perspectiveTile:(CGPoint *)points;

/**Produces a tiled image from a source image by applying a 6-way reflected symmetry.
 
 @param center The center point of the effect within the image.
 @param angle The angle of the effect.
 @param width The width, along with the center parameter, defines the portion of the image to tile.
 */
-(void)sixFoldReflectedTile:(CGPoint)center angle:(CGFloat)angle width:(CGFloat)width;

/**Produces a tiled image from a source image by rotating the source image at increments of 60 degrees.
 
 @param center The center point of the effect within the image.
 @param angle The angle of the effect.
 @param width The width, along with the center parameter, defines the portion of the image to tile.
 */
-(void)sixFoldRotatedTile:(CGPoint)center angle:(CGFloat)angle width:(CGFloat)width;

/**Maps a triangular portion of an input image to create a kaleidoscope effect.
 
 @param point The point of interest around which the effect will be rendered.
 @param size The size of the triangle that will be select.
 @param rotation The rotation of the effect's space.
 @param decay The decay of the effect.
 */
-(void)triangleKaleidescope:(CGPoint)point size:(CGFloat)size rotation:(CGFloat)rotation decay:(CGFloat)decay;

/**Produces a tiled image from a source image by rotating the source image at increments of 30 degrees.
 
 @param center The center point of the effect within the image.
 @param angle The angle of the effect.
 @param width The width, along with the center parameter, defines the portion of the image to tile.
 */
-(void)twelveFoldReflectedTile:(CGPoint)center angle:(CGFloat)angle width:(CGFloat)width;

#pragma mark new filters
-(void)blendWithAlphaMask:(C4Image *)backgroundImage mask:(C4Image *)maskImage;
@end
