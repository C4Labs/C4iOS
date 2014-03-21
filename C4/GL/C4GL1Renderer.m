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
    
    
    
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, self.renderBuffer);
    [self.eaglContext presentRenderbuffer:GL_RENDERBUFFER_OES];
    
    glFinish();
    startPoint+=4;
    if(startPoint >= 96) startPoint = 0;
}

@end
