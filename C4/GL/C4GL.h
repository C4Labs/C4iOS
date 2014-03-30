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

/**The C4GL class implements a modifiable view that handles OpenGL ES rendering.
 
 C4GL is a subclass of C4Control and inherits all its gesture, animation and notification abilities.
 
 This is the class that you should use for adding any OpenGL drawing to C4's canvas.
 
 In C4, the main role of C4GL is to provide a simple interactive object which encapsulates OpenGL rendering ability. C4GL is similar to other subclasses of C4Control, but is limited in some ways:
 
 - You can add shadows to C4GL objects in the same way as other C4Control subclasses... but that's about it for changing the style of the object.
 - You cannot specify the background color of a C4GL object, instead you should do this in your rendering object by calling glClearColor() with the specific background color you wish to use
 */

@interface C4GL : C4Control {
}
#pragma mark - Creating C4GL Objects
///@name Creating C4GL Objects
/**Creates and returns a new C4GL object with a specified frame.
 
 This method creates a new C4GL object sized and positioned based on the specified frame, and initialized the default renderer
 
 @param frame the frame for building the new C4GL object's view.
 @return a new C4GL object.
 */

+ (instancetype)glWithFrame:(CGRect)frame;

/**Initializes a C4GL object with a specific renderer.
 
 @param renderer A rendering object which conforms to the C4EAGLESRenderer protocol.
 */
-(id)initWithRenderer:(id <C4EAGLESRenderer>)renderer;

#pragma mark Animation Control
///@name Animation Control
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
@property(nonatomic, strong) id <C4EAGLESRenderer> renderer;

/**Specifies a readonly variable used to determine if the renderer is currently animating.
 */
@property(nonatomic, readonly, getter=isAnimating) BOOL animating;

/**Specifies an interval which determines how often frames are rendered.
 
 Frame interval defines how many display frames must pass between each time the
 display link fires. The display link will only fire 30 times a second when the
 frame internal is two on a display that refreshes 60 times a second. The default
 frame interval setting of one will fire 60 times a second when the display refreshes
 at 60 times a second. A frame interval setting of less than one results in undefined
 behavior, and is prevented from being set.
 */
@property(nonatomic) NSInteger animationFrameInterval;

/**Specifies that drawing should happen only one time.
 
 If drawOnce is set to YES, when the startAnimation method is called rendering will happen one time. At the end of the rendering method the animation will be automatically stopped.
 
 Set this property to YES if you want to draw something but aren't animating its contents. If you are not animating and this property is set to NO the rendering call will be made at the specified frame rate (default 60fps) and you'll be wasting a lot of resources.
 */
@property(nonatomic) BOOL drawOnce;

@end
