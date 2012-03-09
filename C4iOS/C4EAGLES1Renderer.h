//
//  C4EAGLRenderer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//
#import "C4EAGLLayer.h"
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

/**This document describes the C4EAGLES1Renderer class, which is the default rendering class to use when working with OpenGL ES 1.x
 
 This class represents a rendering object which allows you to work with OpenGL ES 1.x, and provides simple functionality for setting up and rendering.
 
 This class has a simple interface, which includes a render and setup method.
 
 @warning You should never have to use this object directly. Instead, you should work with your own subclasses of [C4GL1Renderer](C4GL1Renderer) which hides some of the more complicated setup and teardown functionality available in this class.
 */
@interface C4EAGLES1Renderer : C4Object <C4EAGLESRenderer> {
}

/**The method used for adding additional variable setup, outside of the main initialization methods.
  */
-(void)setup;

/**The method used for rendering OpenGL animations.
 */
-(void)render;

/**The width of the layer.

 This property is used in the resizeFromLayer: method 
 */
@property (readonly) GLint width;

/**The height of the layer.
 
 This property is used in the resizeFromLayer: method 
 */
@property (readonly) GLint height;

/**The frame buffer.
 
 Framebuffer Objects are a mechanism for rendering to images other than the default OpenGL Default Framebuffer. They are OpenGL Objects that allow you to render directly to textures.
 
 For more see: [Frame Buffer Object](http://www.opengl.org/wiki/Framebuffer_Object )
 */
@property (readonly) GLuint frameBuffer;

/**The render buffer.

 Renderbuffer Objects are OpenGL Objects that contain images. They are created and used specifically with Framebuffer Objects. They are optimized for being used as render targets, while Textures may not be.
 
 For more see: [Render Buffer Object](http://www.opengl.org/wiki/Renderbuffer_Object )
 */
@property (readonly) GLuint renderBuffer;

/** The EAGLContext into which the renderer should draw.
 */
@property (readwrite, strong) EAGLContext *eaglContext;
@end
