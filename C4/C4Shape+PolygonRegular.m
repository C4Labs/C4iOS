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

+ (instancetype)polygonRegularWithCenter:(CGPoint)center sideLength:(float)length numberOfSides:(int)numberOfSides eulerAnglePolyIsRotated:(float)euler{
    //establish radius measurement to begin drawing polygon
    float radius = length/(2 * sin(DegreesToRadians(180.0f)/numberOfSides));
    //limit minimum to create real polygons and limit maximum for memory considerations
    if (numberOfSides < 3)
        numberOfSides = 3;
    if (numberOfSides > 2048)
        numberOfSides = 2048;
    CGPoint pointArray[numberOfSides];
    //set up the start point to begin drawing
    CGPoint start;
    CGPoint next;
    euler = euler + ((360.0f/numberOfSides)/2);
    start.x = center.x - radius * cos(DegreesToRadians(euler));
    start.y = center.y + radius * sin(DegreesToRadians(euler));
    pointArray[0] = start;
    //draw the rest of the polygon looping back to start point
    for (NSInteger i = 1; i < numberOfSides; i += 1){
        if (i == 1 ){
            euler = euler + 180.0f - ((360.0f/numberOfSides)/2);
            next.x = start.x - length * cos(DegreesToRadians(euler));
            next.y = start.y + length * sin(DegreesToRadians(euler));
        }
        else{
            euler = euler + (360.0f/numberOfSides);
            next.x = next.x - length * cos(DegreesToRadians(euler));
            next.y = next.y + length * sin(DegreesToRadians(euler));
        }
        pointArray[i] = next;
    }
    C4Shape *newShape = [[C4Shape alloc] init];
    [newShape polygonRegular:(CGPoint*)pointArray pointCount:numberOfSides];
    return newShape;
}

- (void)polygonRegular:(CGPoint *)points pointCount:(int)numberOfSides{
    [self polygon:points pointCount:numberOfSides];
    [self closeShape];
    NSMutableDictionary* data = [self.shapeData mutableCopy];
    [data setObject:C4ShapePolygonRegularType forKey:C4ShapeTypeKey];
    self.shapeData = data;
}

@end
