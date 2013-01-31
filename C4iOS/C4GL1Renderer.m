//
//  C4GL1Renderer.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4GL1Renderer.h"

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

const GLubyte colors[] = {
    50, 55, 60, 255,
    50, 55, 60, 255,
    50, 55, 60, 255,
    12, 160, 230, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    255, 26, 26, 255,
    12, 160, 230, 255,
    50, 55, 60, 255,
    50, 55, 60, 255,
    50, 55, 60, 255,
    50, 55, 60, 255,
    50, 55, 60, 255,
};

@implementation C4GL1Renderer {
    int startPoint;
}

-(void)setup {
    startPoint = 0;
}

-(void)render {

    GLfloat currentVerts[48];
    for(int i = 0; i < 48; i++){
//        currentVerts[i] = vertices[i];
        currentVerts[i] = 0.99f * vertices[i];
    }
    
    GLubyte currentColors[96];
    int j = startPoint;
    for (int i = 0; i < 96; i++, j++) {
        currentColors[i] = colors[j];
        if(j == 96) j = 0;
    }

    [EAGLContext setCurrentContext:self.eaglContext];

    glMatrixMode(GL_PROJECTION);
    glLoadIdentity();
    //reigns in the drawing area because the layer will clip to its viewport
    glOrthof(-1.03f, 1.03f, -1.03f, 1.03f, -1.0f, 1.0f);
    glMatrixMode(GL_MODELVIEW);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, self.frameBuffer);
    glViewport(0, 0, self.width, self.height);
    
    glVertexPointer(2, GL_FLOAT, 0, currentVerts);
    glEnableClientState(GL_VERTEX_ARRAY);
    
    glColorPointer(4, GL_UNSIGNED_BYTE, 0, currentColors);
    glEnableClientState(GL_COLOR_ARRAY);
    
    glLineWidth(20.0f);
    glDrawArrays(GL_LINE_LOOP, 0, 24);
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.renderBuffer);
    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER_OES];
    
    glFinish();
    startPoint+=4;
    if(startPoint >= 96) startPoint = 0;
}

-(C4GL1Renderer *)copyWithZone:(NSZone *)zone {
    return [[C4GL1Renderer allocWithZone:zone] init];
}

@end
