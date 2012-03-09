//
//  C4EAGLESRenderer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/EAGLDrawable.h>

/**This document describes required methods for all opengl renderers.
 */
@protocol C4EAGLESRenderer <NSObject>

/**The method within which all drawing code should be written.
 */
- (void)render;

/**The method within which custom allocation of variables can be made. It should be called at the end of an object's initialization method, before the object is returned.
 */
- (void)setup;

/**Default method for handling layer size changes.
 */
- (BOOL)resizeFromLayer:(CAEAGLLayer*)layer;

@end