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

#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

/**This document describes the C4EAGLES1Renderer class, which is the default rendering class to use when working with OpenGL ES 1.x
 
 This class represents a rendering object which allows you to work with OpenGL ES 1.x, and provides simple functionality for setting up and rendering.
 
 This class has a simple interface, which includes a render and setup method.
 
 @warning You should never have to use this object directly. Instead, you should work with your own subclasses of [C4GL1Renderer](C4GL1Renderer) which hides some of the more complicated setup and teardown functionality available in this class.
 */
@interface C4EAGLES1Renderer : C4Object <C4EAGLESRenderer> {
}

#pragma mark - Setup & Render
///@name Setup & Render
/**The method used for adding additional variable setup, outside of the main initialization methods.
 */
-(void)setup;

/**The method used for rendering OpenGL animations.
 */
-(void)render;

#pragma mark - Width & Height
///@name Width & Height
/**The width of the layer.
 
 This property is used in the resizeFromLayer: method
 */
@property(nonatomic, readonly) GLint width;

/**The height of the layer.
 
 This property is used in the resizeFromLayer: method
 */
@property(nonatomic, readonly) GLint height;

#pragma mark - Buffers
///@name Buffers
/**The frame buffer.
 
 Framebuffer Objects are a mechanism for rendering to images other than the default OpenGL Default Framebuffer. They are OpenGL Objects that allow you to render directly to textures.
 
 For more see: [Frame Buffer Object](http://www.opengl.org/wiki/Framebuffer_Object )
 */
@property(nonatomic, readonly) GLuint frameBuffer;

/**The render buffer.
 
 Renderbuffer Objects are OpenGL Objects that contain images. They are created and used specifically with Framebuffer Objects. They are optimized for being used as render targets, while Textures may not be.
 
 For more see: [Render Buffer Object](http://www.opengl.org/wiki/Renderbuffer_Object )
 */
@property(nonatomic, readonly) GLuint renderBuffer;

/** The EAGLContext into which the renderer should draw.
 */
@property(nonatomic, strong) EAGLContext *eaglContext;

@end
