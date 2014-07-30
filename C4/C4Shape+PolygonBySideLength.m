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

@implementation C4Shape (PolygonBySideLength)

+ (instancetype)polygonBySideLength:(float)length center:(CGPoint)center numberOfSides:(int)numberOfSides optionalStarArm:(float)optionalStarArm{
    //math to set polygon to draw around the center point
    double angle = 180.0f/numberOfSides;
    double radius = length/(2 * sin(DegreesToRadians(angle)));
    center.y = center.y - radius;
    
    //add two points to properly join our end of path and set up star geometry if needed
    int pointCount;
    double starSide;
    double starBaseAngle;
    double starPointAngle;
    if (optionalStarArm > 0) {
        pointCount = (2 * numberOfSides) + 2;
        starSide = sqrt(pow(length*0.5f, 2.0) + pow(optionalStarArm, 2.0));
        starBaseAngle = (asin(optionalStarArm/starSide) * 180) / PI;
        starPointAngle = (180.0f - (starBaseAngle + 90.0f)) * 2;
    }
    else
        pointCount = numberOfSides + 2;
    
    //math for mapping our equilateral polygon
    CGPoint pointArray[pointCount];
    CGPoint next = center;
    pointArray[0] = center;
    for (NSInteger i = 1; i <= pointCount - 1; i += 1){
        if (i == 1)
            angle = (360.0f/numberOfSides)/2;
        
        //do simple loop for non-star polygons
        if (optionalStarArm == 0) {
            angle = angle + (360.0/numberOfSides);
            next.x = next.x  + length * cos(DegreesToRadians(angle));
            next.y = next.y  + length * sin(DegreesToRadians(angle));
        }
        
        //alternate inward points and outward points for star polygons
        else {
            if (i % 2 == 0) {
                next.x = (double)(next.x  + starSide * cos(((180.0 + angle - starPointAngle- starBaseAngle)*PI)/180));
                next.y = (double)(next.y  + starSide * sin(((180.0 + angle - starPointAngle- starBaseAngle)*PI)/180));
            }
            
            else {
                angle = angle + (360.0/numberOfSides);
                next.x = (double)(next.x  + starSide * cos(((angle - starBaseAngle)*PI)/180));
                next.y = (double)(next.y  + starSide * sin(((angle - starBaseAngle)*PI)/180));
            }
        }
        pointArray[i] = next;
    }

    C4Shape *newShape = [[C4Shape alloc] init];
    [newShape polygon:(CGPoint*)pointArray pointCount:pointCount];
    return newShape;
}

- (void)polygonBySideLength:(CGPoint *)points pointCount:(int)pointCount{
    // This is a special case of a polygon
    [self polygon:points pointCount:pointCount];
}

@end