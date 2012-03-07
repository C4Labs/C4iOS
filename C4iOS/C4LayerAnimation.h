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
 
 @warning *NOTE:* For the current version of C4 you should NEVER have to deal with any kind of C4Layer because any instance of this kind of layer will be instantiated as the backing layer of a specific view. You should interact only with the layer's superview. For instance, work with C4Shape objects and NOT C4ShapeLayer objects (C4Shape is backed by C4ShapeLayer).
 */
@protocol C4LayerAnimation <NSObject>
///---------------------------------------------------------------------------------------
/// @name Animation Methods
///---------------------------------------------------------------------------------------
#pragma mark Animation Methods

/** Animates the layer's shadowColor from it's current color to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowColor The color to which will be animated;
 */
-(void)animateShadowColor:(CGColorRef)shadowColor;

/** Animates the layer's shadowOpacity from it's current opacity to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowOpacity The opacity to which will be animated;
 */
-(void)animateShadowOpacity:(CGFloat)shadowOpacity;

/** Animates the layer's shadowRadius from it's current radius to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowRadius The radius to which will be animated;
 */
-(void)animateShadowRadius:(CGFloat)shadowRadius;

/** Animates the layer's shadowOffset from it's current offset size to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowOffset The offset size to which will be animated;
 */
-(void)animateShadowOffset:(CGSize)shadowOffset;

/** Animates the layer's shadowPath from it's current path to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param shadowPath The path to which will be animated;
 */
-(void)animateShadowPath:(CGPathRef)shadowPath;

/** Animates the layer's backgroundFilters from it's current set of background filters to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param backgroundFilters The set of filters to which will be animated;
 */
-(void)animateBackgroundFilters:(NSArray *)backgroundFilters;

/** Animates the layer's compositingFilters from it's current set of compositing filters to a new one.
 
 Creates a CABasicAnimation contained within a CATransaction. This method also handles setting a completion block if the animation needs it. 
 
 @param compositingFilters The set of compositing filters to which will be animated;
 */
-(void)animateCompositingFilter:(id)compositingFilter;

-(void)test;
-(BOOL)isOpaque;
-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath;

///---------------------------------------------------------------------------------------
/// @name Properties
///---------------------------------------------------------------------------------------
#pragma mark Properties

/** Sets the duration of the layer's animations.
 
 All animations that occur will use this value as their duration.
 
 For immediate animations set this property to 0.0f;
 
 Defaults to 0.0f;
 
 @param CGFloat A value in seconds for the length that a layer should set for its animations.
 */
@property (nonatomic) CGFloat animationDuration;

/** Sets the options for which the layer should use in its animations.
 
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
 
 @warning *NOTE:* All animation options should be set at the same time using the | bitmask operator. Animation options should never be set in the following way:
 layer.animationOptions = AUTOREVERSE;
 layer.animationOptions = REPEAT;
 
 @param NSUInteger An integer which can be constructed from bitmasked values.
 */
@property (nonatomic) NSUInteger animationOptions;

/** Sets the number of times an animation autorepeats.
 
 @warning *NOTE:* This parameter is currently unused.
 
 @param CGFloat The number of times an animation should repeat.
 */
@property (nonatomic) CGFloat repeatCount;

@property (readonly, strong) NSString *currentAnimationEasing;
@property (readonly, nonatomic) BOOL allowsInteraction, repeats;
@end
