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

#import "C4Shape+PolygonBySideLength.h"
#import "C4Shape_Private.h"
#import "C4Shape+Polygon.h"

NSString* const C4ShapePolygonBySideLengthType = @"equilateralPolygon";

@implementation C4Shape (PolygonBySideLength)

+ (instancetype)polygonBySideLength:(float)length center:(CGPoint)center numberOfSides:(int)numberOfSides{
    //enforce minimum sides to avoid exception cases
    if (numberOfSides < 2)
        numberOfSides = 2;
    //begin math to draw the equilateral polygon
    CGPoint pointArray[numberOfSides];
    float angle;
    CGPoint next = center;
    for (NSInteger i = 0; i < numberOfSides; i += 1){
        if (i == 1)
            angle = (360.0f/numberOfSides)/2;
        else
            angle = angle + (360.0f/numberOfSides);
        next.x = next.x + length * cos(DegreesToRadians(angle));
        next.y = next.y + length * sin(DegreesToRadians(angle));
        pointArray[i] = next;
    }
    C4Shape *newShape = [[C4Shape alloc] init];
    [newShape polygonBySideLength:(CGPoint*)pointArray pointCount:numberOfSides];
    return newShape;
}

- (void)polygonBySideLength:(CGPoint *)points pointCount:(int)numberOfSides{
    [self polygon:points pointCount:numberOfSides];
    [self closeShape];
    NSMutableDictionary* data = [self.shapeData mutableCopy];
    [data setObject:C4ShapePolygonBySideLengthType forKey:C4ShapeTypeKey];
    self.shapeData = data;
}

@end