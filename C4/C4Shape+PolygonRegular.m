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

#import "C4Shape+PolygonRegular.h"
#import "C4Shape_Private.h"
#import "C4Shape+Polygon.h"

NSString* const C4ShapePolygonRegularType = @"polygon";

@implementation C4Shape (PolygonRegular)

+ (instancetype)polygonRegularWithCenter:(CGPoint)c sideLength:(float)l numberOfSides:(int)n eulerAnglePolyIsRotated:(float)e
{
    // This is a special case of a polygon.
    float r = l/(2 * sin(DegreesToRadians(180.0f)/n));
    if (n < 3)
        n = 3;
    if (n > 2048)
        n = 2048;
    CGPoint pointArray[n];
    CGPoint start;
    CGPoint next;
    e = e + ((360.0f/n)/2);
    start.x = c.x - r * cos(DegreesToRadians(e));
    start.y = c.y + r * sin(DegreesToRadians(e));
    pointArray[0] = start;
    for (NSInteger i = 1; i < n; i += 1)
    {
        if (i == 1 )
        {
            e = e + 180.0f - ((360.0f/n)/2);
            next.x = start.x - l * cos(DegreesToRadians(e));
            next.y = start.y + l * sin(DegreesToRadians(e));
        }
        if (i != 1 )
        {
            e = e + (360.0f/n);
            next.x = next.x - l * cos(DegreesToRadians(e));
            next.y = next.y + l * sin(DegreesToRadians(e));
        }
        pointArray[i] = next;
    }
    C4Shape *newShape = [[C4Shape alloc] init];
    [newShape polygonRegular:(CGPoint*)pointArray pointCount:n];
    return newShape;
}

- (void)polygonRegular:(CGPoint *)points pointCount:(int)n
{
    [self polygon:points pointCount:n];
    [self closeShape];
    NSMutableDictionary* data = [self.shapeData mutableCopy];
    [data setObject:C4ShapePolygonRegularType forKey:C4ShapeTypeKey];
    self.shapeData = data;
}

@end
