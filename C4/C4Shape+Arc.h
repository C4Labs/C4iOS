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

@interface C4Shape (Arc)

/**Creates and returns an instance of C4Shape, whose path is an arc.
 
 @param centerPoint The center point of the arc.
 @param radius The radius of the arc.
 @param startAngle The starting angle of the arc, in radians in the range of (0 .. 2*PI)
 @param endAngle The ending angle of the arc, in radians in the range of (0 .. 2*PI)
 @param clockwise A Boolean value specifying whether or not the arc will draw in a clockwise direction from the start to end angle
 @return The initialized C4Shape object created with an arc path or nil if initialization is not successful.
 */
+ (instancetype)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

/**Changes the object's current shape to an arc
 
 The change will happen based on the shape's current animation options, duration and delay.
 
 @param centerPoint The center point of the arc.
 @param radius The radius of the arc.
 @param startAngle The starting angle of the arc, in radians in the range of (0 .. 2*PI)
 @param clockwise A Boolean value specifying whether or not the arc will draw in a clockwise direction from the start to end angle
 @param endAngle The ending angle of the arc, in radians in the range of (0 .. 2*PI)
 */
- (void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

/**Specifies whether or not the shape is an arc.
 */
@property(nonatomic, readonly, getter = isArc) BOOL arc;

@end
