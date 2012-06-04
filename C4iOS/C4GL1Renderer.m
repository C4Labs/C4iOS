//
//  C4GL1Renderer.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4GL1Renderer.h"

@implementation C4GL1Renderer

-(void)setup {
}

-(void)render {
    const GLfloat vertices[] = {
        -1.0, -1.0,
        -1.0,  1.0,
        -0.33f, 1.0,
        0.0, 1.0,
        0.0, 0.5,
        0.0, 0.0,
        0.33f, 0.0,
        0.33f, 1.0,
        0.66f, 1.0,
        0.66f, 0.0,
        1.0, 0.0,
        1.0, -0.5,
        0.66f, -0.5,
        0.66f, -1.0,
        0.33f, -1.0,
        0.33f, -0.5,
        -0.33f, -0.5,
        -0.33f, 0.0,
        -0.33f, 0.5,
        -0.66f, 0.5,
        -0.66f, -0.5,
        0.0,-0.5,
        0.0,-1.0,
        -1.0,-1.0
    };
    /* number of colors should match the number of vertices, otherwise will create an alpha color to fill in */
    const GLubyte colors[] = {
        255, 51, 51, 255,
        255, 51, 51, 255,
        255, 51, 51, 255,
        51, 51, 51, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 102, 255, 255,
        51, 51, 51, 255,
        255, 51, 51, 255,
        255, 51, 51, 255,
        255, 51, 51, 255,
        255, 51, 51, 255,
        255, 51, 51, 255
};
    
    [EAGLContext setCurrentContext:self.eaglContext];
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, self.frameBuffer);
    glViewport(0, 0, self.width, self.height);
	
    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    glOrthof(-1.0f, 1.0f, -1.0f, 1.0f, -1.0f, 1.0f);
	glMatrixMode(GL_MODELVIEW);
    
    glClearColor(0,0,0,0);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glVertexPointer(2, GL_FLOAT, 0, vertices);
    glEnableClientState(GL_VERTEX_ARRAY);
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, colors);
    glEnableClientState(GL_COLOR_ARRAY);

    glDrawArrays(GL_LINE_LOOP, 0, 24);
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.renderBuffer);
    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER_OES];
}
@end
