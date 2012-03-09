//
//  C4OpenGLLayer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

/**This document describes the C4EAGLLayer class.
 
 C4EAGLLayer is a subclass of CAEAGLLayer and conforms to the C4LayerAnimation protocol. It is the default backing layer for a C4GL object.
 
 @warning You should never have to access this object directly.
 */

@interface C4EAGLLayer : CAEAGLLayer <C4LayerAnimation>

@end
