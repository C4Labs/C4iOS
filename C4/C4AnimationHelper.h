// Copyright © 2012 Travis Kirton, Alejandro Isaza
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

#import <Foundation/Foundation.h>


/** C4AnimationHelper stores animation properties and has helper methods to create CAAnimations. You shouldn't need to use this class directly, instead use the animation features of C4Control.
 */
@interface C4AnimationHelper : NSObject

- (id)initWithLayer:(CALayer *)layer;

/** The layer on which to apply the animations.
 */
@property(nonatomic, readonly, strong) CALayer *layer;

/** The duration of the animations.
 
 For immediate animations set this property to 0.
 
 Defaults to 0.
 */
@property(nonatomic) CGFloat animationDuration;

/** The time to wait before the view's animations begin, measured in seconds.
 
 All animations that occur will use this value as their delay.
 
 For immediate animations set this property to 0.0f;
 
 Defaults to 0.0f
 */
@property(nonatomic) CGFloat animationDelay;

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
@property(nonatomic) NSUInteger animationOptions;

/** Type of easing that an animation will use.
 */
@property(nonatomic, strong) NSString *currentAnimationEasing;

/** The autoreverse state. YES if the animation autoreverses, NO otherwise.
 */
@property(nonatomic) BOOL autoreverses;

/** The repeat state. YES if the layer's animations will repeat, NO otherwise.
 */
@property(nonatomic) BOOL repeats;

/** Create a new animation object based on the current properties.
 */
- (CABasicAnimation *)animation;

/** Animate a property on the layer to a specific value based on the current properties.
 
 @param keyPath The kay path to property to animate.
 @param toValue The target value for the animation.
 */
- (void)animateKeyPath:(NSString *)keyPath toValue:(id)toValue;

/** Animate a property on the layer to a specific value based on the current properties.
 
 @param keyPath The kay path to property to animate.
 @param toValue The target value for the animation.
 @param completion The block to invoke when the animation completes.
 */
- (void)animateKeyPath:(NSString *)keyPath toValue:(id)toValue completion:(void (^)())completion;

/** Pause all animations happening on the layer.
 */
- (void)pause;

/** Resume all animations happening on the layer.
 */
- (void)resume;

@end
