//
//  UITouch+C4Touch.h
//  C4iOS
//
//  Created by Travis Kirton on 11-10-08.
//  Copyright (c) 2011 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This document describes a category for UITouch that makes available an otherwise hidden variable.
 */
@interface UITouch (C4Touch)
/// @name Accessors
/** Provides access to the value of the largest radius of a touch;
 
 @return majorRadius A float value measuring the larger radius (generally in a non-circular ellipse).
 */
-(CGFloat)majorRadius;
@end