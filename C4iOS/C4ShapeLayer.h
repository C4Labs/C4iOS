//
//  C4ShapeLayer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

/** This document describes the C4ShapeLayer, a subclass of CAShapeLayer which conforms to the C4LayerAnimation protocol.
 
 It is rare that you will need to directly use C4ShapeLayers when working with C4. By conforming to the C4LayerAnimation protocol, this class makes it possible to animate basic properties of the layer such as color.
 
 In essence, each C4Shape is a view (sublcass of UIView) and the C4ShapeLayer is its Core Animation backing layer. 
 
 In C4 all visible objects have properties that are animatable, and this layer provides some overrides that allow for the flexibility of getting around Core Animation's implicit actions. So, instead of having overridden properties there are methods that setup basic animations based on the object's properties and commit them by calling the layer's animatable properties from within a custom CATransaction block.
 
 *To understand the animatable properties of a C4ShapeLayer please see the documentation for the [C4LayerAnimation](C4LayerAnimation) protocol.*
 
 @warning *Note:* With the current implementation of C4 you shouldn't ever have to access or use this class.
 */

@interface C4ShapeLayer : CAShapeLayer <C4LayerAnimation> {
//    NSString *currentAnimationEasing;
}

#pragma mark Animation Methods

/// @name Animation Methods

/**Changes the current path to a new path.
 
 This method takes as its argument a CGPathRef and builds an animation that will change its current path to the new one. Core animation will interpolate between both shapes to the best of its ability (but often it isn't perfect).
 
 @param path The new path to which this shape will change.
 */
-(void)animatePath:(CGPathRef)path;

/**Changes the fillColor to a new color.
 
 This method takes as its argument a CGColorRef and builds an animation that will change its current fill color to the new one. Core animation will interpolate between both colors to the best of its ability.
 
 @param fillColor The new color to which this shape will change its fillColor.
 */
-(void)animateFillColor:(CGColorRef)fillColor;

/**Changes the lineWidth to a new thickness.
 
 This method takes as its argument a CGFloat and builds an animation that will change its current line width to the new value. Core animation will interpolate between both widths to the best of its ability.
 
 @param lineWidth The new value to which this shape will change its lineWidth.
 */
-(void)animateLineWidth:(CGFloat)lineWidth;

/**Changes the miterLimit to a new value.
 
 This method takes as its argument a CGFloat and builds an animation that will change its current miter limit to the new value. Core animation will interpolate between both limits to the best of its ability.
 
 @param miterLimit The new value to which this shape will change its miterLimit.
 */
-(void)animateMiterLimit:(CGFloat)miterLimit;

/**Changes the strokeColor to a new color.
 
 This method takes as its argument a CGColorRef and builds an animation that will change its current stroke color to the new one. Core animation will interpolate between both colors to the best of its ability.
 
 @param strokeColor The new color to which this shape will change its strokeColor.
 */
-(void)animateStrokeColor:(CGColorRef)strokeColor;

/**Changes the strokeEnd to a new position.
 
 This method takes as its argument a CGFloat (from 0.0f to 1.0f) and builds an animation that will change the current visible end position of its path calculated against the length of its entire path. Core animation will interpolate between both end values to the best of its ability.
 
 @param strokeEnd The new value to which this shape will change its strokeEnd.
 */
-(void)animateStrokeEnd:(CGFloat)strokeEnd;

/**Changes the strokeStart to a new position.
 
 This method takes as its argument a CGFloat (from 0.0f to 1.0f) and builds an animation that will change the current visible start position of its path calculated against the length of its entire path. Core animation will interpolate between both start values to the best of its ability.
 
 @param strokeStart The new value to which this shape will change its strokeStart.
 */
-(void)animateStrokeStart:(CGFloat)strokeStart;
@end
