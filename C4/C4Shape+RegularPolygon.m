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

#import "C4Shape+RegularPolygon.h"
#import "C4Shape_Private.h"
#import "C4Shape+Polygon.h"

@implementation C4Shape (PolygonBySideLength)

+ (instancetype)regularPolygonWithNumberOfSides:(NSUInteger)numberOfSides sideLength:(CGFloat)length center:(CGPoint)center {
    C4Shape* shape = [[C4Shape alloc] init];
    [shape regularPolygonWithNumberOfSides:numberOfSides sideLength:length center:center];
    return shape;
}

- (void)regularPolygonWithNumberOfSides:(NSUInteger)numberOfSides sideLength:(CGFloat)length center:(CGPoint)center {
    NSParameterAssert(numberOfSides > 2);
    NSParameterAssert(length > 0.0);
    
    const CGFloat wedgeAngle = 2.0*M_PI / numberOfSides;
    const CGFloat radius = length / (2.0 * sin(wedgeAngle/2.0));
    
    CGFloat angle = 0;
    CGPoint pointArray[numberOfSides];
    for (NSUInteger side = 0; side < numberOfSides; side += 1) {
        pointArray[side] = CGPointMake(center.x + radius * cos(angle), center.y + radius * sin(angle));
        angle += wedgeAngle;
    }
    
    [self polygon:pointArray pointCount:numberOfSides closed:YES];
}

@end