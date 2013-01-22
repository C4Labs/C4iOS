//
//  C4EAGLRenderer.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  A modified version of Apple's GLES2Sample project.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4GL1Renderer.h"
#import "C4EAGLLayer.h"

@implementation C4EAGLES1Renderer

// Create an ES 1.1 context
- (id <C4EAGLESRenderer>) init
{
	if (self = [super init])
	{
		_eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        if (nil == _eaglContext || NO == [EAGLContext setCurrentContext:_eaglContext]) return nil;
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &_frameBuffer);
		glGenRenderbuffersOES(1, &_renderBuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, _frameBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, _renderBuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, _renderBuffer);
        [self setup];
	}
	return self;
}


-(void)setup {
    
}

- (void) render {
}

- (BOOL) resizeFromLayer:(C4EAGLLayer *)layer{
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, _renderBuffer);
    [_eaglContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &_width);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &_height);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void) dealloc
{
	if (_frameBuffer) {
		glDeleteFramebuffersOES(1, &_frameBuffer);
		_frameBuffer = 0;
	}
	
	if (_renderBuffer) {
		glDeleteRenderbuffersOES(1, &_renderBuffer);
		_renderBuffer = 0;
	}
	
	if ([EAGLContext currentContext] == _eaglContext)
        [EAGLContext setCurrentContext:nil];
	_eaglContext = nil;
}
@end
