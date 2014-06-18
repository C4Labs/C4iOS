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

#import "C4Shape.h"

@interface C4Shape (Curve)

/**Creates and returns an instance of C4Shape, whose path is a bezier curve.
 
 @param beginEndPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the beginning and end of the curve.
 @param controlPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the control points that distort the curve.
 @return The initialized C4Shape object created with a curve path or nil if initialization is not successful.
 */
+ (instancetype)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;

/**Changes the object's current shape to a curve
 
 The change will happen based on the shape's current animation options, duration and delay.
 
 @param beginEndPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the beginning and end of the curve.
 @param controlPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the control points that distort the curve.
 */
- (void)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;

- (void)curve:(NSArray *)points;


/**Specifies whether the given shape is a bezier curve.
 
 This property is specifically used in the `pointA` and `pointB` methods to determine if the current object is capable of setting them. In particular, only lines, beziers and quadratic curves should be able to acces the `pointA` and `pointB` properties of the `C4Shape` class.
 */
@property(nonatomic, readonly, getter = isBezierCurve) BOOL bezierCurve;

/**Specifies the origin point of a line. Animatable.
 */
@property(nonatomic) CGPoint pointA;

/**Specifies the end point of a line. Animatable.
 */
@property(nonatomic) CGPoint pointB;

/**Specifies the first control point of a curve, both bezier and quad curves. Animatable.
 */
@property(nonatomic) CGPoint controlPointA;

/**Specifies the second control point (bezier curves only). Animatable.
 */
@property(nonatomic) CGPoint controlPointB;

@end
