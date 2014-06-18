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

@interface C4Shape (Polygon)

/**Creates and returns an instance of C4Shape, whose path is a polygon.
 
 This method requires a secondary variable, called pointCount, because the length of the C-Array is unknown once it is passed to the method.
 
 @param pointArray A C-Array containing any number of CGPoints like: {CGpoint, .. , CGPoint}.
 @param pointCount The number of points in the array.
 @return The initialized C4Shape object created with a polygon path or nil if initialization is not successful.
 */
+ (instancetype)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount;

/**Changes the object's current shape to a polygon
 
 The change will happen based on the shape's current animation options, duration and delay.
 
 @param pointArray A C-Array containing any number of CGPoints like: {CGpoint, .. , CGPoint}.
 @param pointCount The number of points in the array.
 */
- (void)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount;

- (void)polygon:(NSArray*)points;

/**Specifies whether the given shape is a polygon.
 */
@property(nonatomic, readonly, getter = isPolygon) BOOL polygon;

@end
