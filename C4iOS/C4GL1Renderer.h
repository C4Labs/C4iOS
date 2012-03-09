//
//  C4GL1Renderer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4EAGLES1Renderer.h"
/**This document describes the C4GL1Renderer class which should be used / subclassed to create your own rendering algorithms for a [C4GL](C4GL) object.
 
 Instead of manipulating this object's initialization methods, you can instantiate variables using the setup method. The setup method gets called at the end of the init method executed by the superclass [C4EAGLES1Renderer](C4EAGLES1Renderer).
 */
@interface C4GL1Renderer : C4EAGLES1Renderer

/**The method to override for adding additional variable setup.
 
 This method gets called automatically at the end of the object's initialization.
 
 @warning Do NOT override initialization methods such as -(id)init, instead override this method.
 */
-(void)setup;

/**The method to override for adding custom drawing calls.
  */
-(void)render;
@end
