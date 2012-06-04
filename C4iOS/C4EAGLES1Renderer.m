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
@interface C4EAGLES1Renderer ()

-(BOOL)resizeFromLayer:(C4EAGLLayer*)layer;

@end

@implementation C4EAGLES1Renderer
@synthesize width, height, frameBuffer, renderBuffer;
@synthesize eaglContext;

// Create an ES 1.1 context
- (id <C4EAGLESRenderer>) init
{
	if (self = [super init])
	{
		eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        if (nil == eaglContext || NO == [EAGLContext setCurrentContext:eaglContext]) return nil;
		
		// Create default framebuffer object. The backing will be allocated for the current layer in -resizeFromLayer
		glGenFramebuffersOES(1, &frameBuffer);
		glGenRenderbuffersOES(1, &renderBuffer);
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, frameBuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, renderBuffer);
        [self setup];
	}
	return self;
}


-(void)setup {
    
}

- (void) render {
}

- (BOOL) resizeFromLayer:(C4EAGLLayer *)layer{
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderBuffer);
    [eaglContext renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:layer];
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &width);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &height);
	
    if (glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
		NSLog(@"Failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}

- (void) dealloc
{
	if (frameBuffer) {
		glDeleteFramebuffersOES(1, &frameBuffer);
		frameBuffer = 0;
	}
	
	if (renderBuffer) {
		glDeleteRenderbuffersOES(1, &renderBuffer);
		renderBuffer = 0;
	}
	
	if ([EAGLContext currentContext] == eaglContext)
        [EAGLContext setCurrentContext:nil];
	self.eaglContext = nil;
}
@end
