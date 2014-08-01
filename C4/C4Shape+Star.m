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

#import "C4Shape+Star.h"
#import "C4Shape_Private.h"
#import "C4Shape+Polygon.h"

@implementation C4Shape (Star)

+ (instancetype)starWithNumberOfPoints:(int)numberOfPoints innerRadius:(float)innerRadius outerRadius:(float)outerRadius center:(CGPoint)center {
    C4Shape* shape = [[C4Shape alloc] init];
    [shape starWithNumberOfPoints:numberOfPoints innerRadius:innerRadius outerRadius:outerRadius center:center];
    return shape;
}

- (void)starWithNumberOfPoints:(NSUInteger)numberOfPoints innerRadius:(float)innerRadius outerRadius:(float)outerRadius center:(CGPoint)center {
    NSParameterAssert(numberOfPoints > 2);
    
    double length = 2*innerRadius * sin(DegreesToRadians(180/numberOfPoints));
    
    NSParameterAssert(length > 0.0);
    
    const CGFloat wedgeAngle = 2.0*M_PI / numberOfPoints;
    
    CGFloat angle = 0.5*M_PI;
    CGPoint pointArray[numberOfPoints*2];
    for (NSUInteger side = 0; side < numberOfPoints*2; side += 1) {
        angle += wedgeAngle*0.5;
        if (side % 2 != 0) {
            pointArray[side] = CGPointMake(center.x + innerRadius * cos(angle), center.y + innerRadius * sin(angle));
        }
        else {
            pointArray[side] = CGPointMake(center.x + outerRadius * cos(angle), center.y + outerRadius * sin(angle));
        }
    }
    
    [self polygon:pointArray pointCount:numberOfPoints*2 closed:YES];
}

@end