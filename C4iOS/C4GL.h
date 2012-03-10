//
//  C4GL.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Control.h"

/**The C4GL class implements a modifiable view that handles OpenGL ES rendering.
 
 C4GL is a subclass of C4Control and inherits all its gesture, animation and notification abilities.
 
 This is the class that you should use for adding any OpenGL drawing to C4's canvas.
 
 In C4, the main role of C4GL is to provide a simple interactive object which encapsulates OpenGL rendering ability. C4GL is similar to other subclasses of C4Control, but is limited in some ways:
 
 - You can add shadows to C4GL objects in the same way as other C4Control subclasses... but that's about it for changing the style of the object.
 - You cannot specify the background color of a C4GL object, instead you should do this in your rendering object by calling glClearColor() with the specific background color you wish to use
 */

@interface C4GL : C4Control {    
}

/**Initializes a C4GL object with a specific renderer.
 @param renderer A rendering object which conforms to the C4EAGLESRenderer protocol.
 */
-(id)initWithRenderer:(id <C4EAGLESRenderer>)renderer;

/**Starts rendering
 */
-(void)startAnimation;

/**Stops rendering.
 */
-(void)stopAnimation;

#pragma mark Properties
/// @name Properties
/**Specifies the renderer to be used for drawing.
 
 If you don't specify a renderer, any C4GL object will set itself up with a default that draws the C4 logo.
 
 @warning In the current version of C4 the only kind of renderer is [C4GL1Renderer](C4GL1Renderer) which only allows you to draw with OpenGL ES 1.x function calls.
 */
@property (readwrite, strong, nonatomic) id <C4EAGLESRenderer> renderer;

/**Specifies a readonly variable used to determine if the renderer is currently animating.
 */
@property (readonly, nonatomic, getter=isAnimating) BOOL animating;

/**Specifies an interval which determines how often frames are rendered.
 
 Frame interval defines how many display frames must pass between each time the
 display link fires. The display link will only fire 30 times a second when the
 frame internal is two on a display that refreshes 60 times a second. The default
 frame interval setting of one will fire 60 times a second when the display refreshes
 at 60 times a second. A frame interval setting of less than one results in undefined
 behavior, and is prevented from being set.
 */
@property (nonatomic) NSInteger animationFrameInterval;

/**Specifies that drawing should happen only one time.
 
 If drawOnce is set to YES, when the startAnimation method is called rendering will happen one time. At the end of the rendering method the animation will be automatically stopped.
 
 Set this property to YES if you want to draw something but aren't animating its contents. If you are not animating and this property is set to NO the rendering call will be made at the specified frame rate (default 60fps) and you'll be wasting a lot of resources.
 */
@property BOOL drawOnce;

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
