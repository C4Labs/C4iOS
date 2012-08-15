//
//  C4LayerAnimation.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-06.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>

/** C4LayerAnimation protocol groups methods and properties that are fundamental to basic interaction with all C4Layer objects. Any C4Layer object, such as C4ShapeLayer or C4TextLayer, will conform to this protocol.
 
 If an object conforms to this protocol, it can be considered as an animatable object.
 
 The C4 Framework is built with the idea that all visible objects should be animatable to as much a degree as the Core Animation frameworks allow.
 
 @warning *Note:* For the current version of C4 you should NEVER have to deal with any kind of C4Layer because any instance of this kind of layer will be instantiated as the backing layer of a specific view. You should interact only with the layer's superview. For instance, work with C4Shape objects and NOT C4ShapeLayer objects (C4Shape is backed by C4ShapeLayer).
 */
@protocol C4LayerAnimation <NSObject>
#pragma mark Animation Methods
/// @name Animation Methods

/** Animates the layer's shadowColor from it's current color to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowColor The color to which will be animated
 */
-(void)animateShadowColor:(CGColorRef)shadowColor;

/** Animates the layer's shadowOpacity from it's current opacity to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowOpacity The opacity to which will be animated
 */
-(void)animateShadowOpacity:(CGFloat)shadowOpacity;

/** Animates the layer's shadowRadius from it's current radius to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowRadius The radius to which will be animated
 */
-(void)animateShadowRadius:(CGFloat)shadowRadius;

/** Animates the layer's shadowOffset from it's current offset size to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowOffset The offset size to which will be animated
 */
-(void)animateShadowOffset:(CGSize)shadowOffset;

/** Animates the layer's shadowPath from it's current path to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowPath The path to which will be animated
 */
-(void)animateShadowPath:(CGPathRef)shadowPath;

/** Animates the layer's backgroundFilters from it's current set of background filters to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param backgroundFilters The set of filters to which will be animated
 */
-(void)animateBackgroundFilters:(NSArray *)backgroundFilters;

/** Animates the layer's contents.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param image The new image to set as the layer's contents
 */
-(void)animateContents:(CGImageRef)image;

/** Animates the layer's compositingFilters from it's current set of compositing filters to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param compositingFilter The set of compositing filters to which will be animated
 */
-(void)animateCompositingFilter:(id)compositingFilter;

/** Animates the layer's background color from it's current color to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it.
 
 @param backgroundColor A CGColorRef to which the background color will animate
 */
-(void)animateBackgroundColor:(CGColorRef)backgroundColor;

/** Animates the layer's border color from it's current color to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it.
 
 @param borderColor A CGColorRef to which the border color will animate
 */
-(void)animateBorderColor:(CGColorRef)borderColor;

/** Animates the layer's border width from it's current width to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it.
 
 @param borderWidth A CGFloat to which the border width will animate
 */
-(void)animateBorderWidth:(CGFloat)borderWidth;

/** Animates the layer's corner radius from it's current width to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it.
 
 @param cornerRadius A CGFloat to which the corner radius width will animate
 */
-(void)animateCornerRadius:(CGFloat)cornerRadius;

/** Animates the layer's z-position from it's current width to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it.
 
 @param zPosition A CGFloat to which the z-position will animate
 */
-(void)animateZPosition:(CGFloat)zPosition;

/** Animates the layer's rotation angle (z-axis) from it's current width to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it.
 
 @param rotationAngle A CGFloat to which the z-axis rotation angle will animate
 */
-(void)animateRotation:(CGFloat)rotationAngle;

/** Animates the layer's rotation angle (x-axis) from it's current width to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it.
 
 @param rotationAngle A CGFloat to which the x-axis rotation angle will animate
 */
-(void)animateRotationX:(CGFloat)rotationAngle;

/** Animates the layer's rotation angle (y-axis) from it's current width to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it.
 
 @param rotationAngle A CGFloat to which the y-axis rotation angle will animate
 */
-(void)animateRotationY:(CGFloat)rotationAngle;

/** Animates the layer's sublayer transform from it's current value to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it.
 
 @param layerTransform A CATransform3D structure to which the sublayer transform will animate
 */
-(void)animateLayerTransform:(CATransform3D)layerTransform;

/** Convenience method for creating a CABasicAnimation.
 
 @warning *Note:* You should never call this method directly, it is included in this protocol because all layers need to have the corresponding method for setting up their animations.
 
 @param keyPath A string representation of an animatable property (e.g. @"path", @"fillColor", etc..)
 */
-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath;

#pragma mark Properties
/// @name Properties

/** The duration of the layer's animations.
 
 All animations that occur will use this value as their duration.
 
 For immediate animations set this property to 0.0f;
 
 Defaults to 0.0f;
 */
@property (nonatomic) CGFloat animationDuration;

/** The options for which the layer should use in its animations.
 
 The available animation options are a limited subset of UIViewAnimationOptions and include:
 - ALLOWSINTERACTION
 - BEGINCURRENT (default)
 - REPEAT
 - AUTOREVERSE
 - EASEINOUT
 - EASEIN
 - EASEOUT
 - LINEAR
 
 This value can have a variety of options attached to it by using integer bitmasks. For example, to set an animation which will auto reverse and repeat:
 layer.animationOptions = AUTOREVERSE | REPEAT;
 
 @warning *Note:* All animation options should be set at the same time using the | operator. Animation options should never be set in the following way:
 layer.animationOptions = AUTOREVERSE;
 layer.animationOptions = REPEAT;
 */
@property (nonatomic) NSUInteger animationOptions;

/** The number of times an animation autorepeats.
 
 @warning *Note:* This parameter is currently unused.
 */
@property (nonatomic) CGFloat repeatCount;

/** Type of easing that an animation will use.
 */
@property (readonly, atomic, strong) NSString *currentAnimationEasing;

/** The interaction state.

 @return BOOL YES if the layer allows interaction, NO otherwise.
 */
@property (readonly, nonatomic) BOOL allowsInteraction;

/** The repeat state.
 
 @return BOOL YES if the layer's animations will repeat, NO otherwise.
 */
@property (readonly, nonatomic) BOOL repeats;

/**Specifies the perspective distance for x and y axis rotations.
 
 Technically, this will set the perspective transform component of the receiver's transform to 1/value (i.e. the new value that is set). It will perform the following action:
 
 `CATransform3D t = self.transform;
 if(perspectiveDistance != 0.0f) t.m34 = 1/self.perspectiveDistance;
 else t.m34 = 0.0f;
 self.transform = t;`
 
 Defaults to 0.
 */
@property (readwrite, nonatomic) CGFloat perspectiveDistance;

@end
