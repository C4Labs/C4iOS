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

@interface C4EAGLES1Renderer : C4Object <C4EAGLESRenderer> {
}

-(void)setup;
-(void)render;

@property (readonly) GLint width, height;
@property (readonly) GLuint frameBuffer, renderBuffer;
@property (readwrite, strong) EAGLContext *eaglContext;
@end
