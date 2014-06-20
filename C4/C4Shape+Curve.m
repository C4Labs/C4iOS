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

#import "C4Shape_Private.h"
#import "C4Shape+Curve.h"

NSString* const C4ShapeCurveType = @"curve";
NSString* const C4ShapeCurvePointsKey = @"curvePoints";

@implementation C4Shape (Curve)

+ (instancetype)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray{
    C4Shape *newShape = [[C4Shape alloc] init];
    [newShape curve:beginEndPointArray controlPoints:controlPointArray];
    return newShape;
}

- (void)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray {
    NSArray* points = @[
        [NSValue valueWithCGPoint:beginEndPointArray[0]],
        [NSValue valueWithCGPoint:controlPointArray[0]],
        [NSValue valueWithCGPoint:controlPointArray[1]],
        [NSValue valueWithCGPoint:beginEndPointArray[1]]
    ];
    [self curve:points];
}

- (void)curve:(NSArray *)points {
    self.shapeData = @{
        C4ShapeTypeKey: C4ShapeCurveType,
        C4ShapeCurvePointsKey: points
    };
    
    CGPoint po = [points[0] CGPointValue];
    CGPoint c1 = [points[1] CGPointValue];
    CGPoint c2 = [points[2] CGPointValue];
    CGPoint pe = [points[3] CGPointValue];
    
    // Determine path bounding box
    CGMutablePathRef tmpPath = CGPathCreateMutable();
    CGPathMoveToPoint(tmpPath, NULL, po.x, po.y);
    CGPathAddCurveToPoint(tmpPath, NULL, c1.x, c1.y, c2.x, c2.y, pe.x, pe.y);
    CGRect newFrame = CGPathGetPathBoundingBox(tmpPath);
    CGPathRelease(tmpPath);
    
    // Transform points to the new frame
    CGPoint origin = newFrame.origin;
    CGAffineTransform t = CGAffineTransformMakeTranslation(-origin.x, -origin.y);
    
    // Set new path and frame
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, &t, po.x, po.y);
    CGPathAddCurveToPoint(tmpPath, &t, c1.x, c1.y, c2.x, c2.y, pe.x, pe.y);
    self.path = newPath;
    self.frame = newFrame;
    CGPathRelease(newPath);
    
    self.initialized = YES;
}

- (BOOL)isBezierCurve {
    return [[self.shapeData objectForKey:C4ShapeTypeKey] isEqualToString:C4ShapeCurveType];
}

- (CGPoint)pointA {
    NSArray* points = self.shapeData[C4ShapeCurvePointsKey];
    C4Assert(points, @"You tried to access pointA from a shape that isn't a curve");
    return [points[0] CGPointValue];
}

- (void)setPointA:(CGPoint)pointA {
    NSMutableArray* points = [self.shapeData[C4ShapeCurvePointsKey] mutableCopy];
    C4Assert(points, @"You tried to access pointA from a shape that isn't a curve");
    
    [points replaceObjectAtIndex:0 withObject:[NSValue valueWithCGPoint:pointA]];
    [self curve:points];
}

- (CGPoint)pointB {
    NSArray* points = self.shapeData[C4ShapeCurvePointsKey];
    C4Assert(points, @"You tried to access pointA from a shape that isn't a curve");
    return [points[3] CGPointValue];
}

- (void)setPointB:(CGPoint)pointB {
    NSMutableArray* points = [self.shapeData[C4ShapeCurvePointsKey] mutableCopy];
    C4Assert(points, @"You tried to access pointA from a shape that isn't a curve");
    
    [points replaceObjectAtIndex:3 withObject:[NSValue valueWithCGPoint:pointB]];
    [self curve:points];
}

- (CGPoint)controlPointA {
    NSArray* points = self.shapeData[C4ShapeCurvePointsKey];
    C4Assert(points, @"You tried to access pointA from a shape that isn't a curve");
    return [points[1] CGPointValue];
}

- (void)setControlPointA:(CGPoint)controlPointA {
    NSMutableArray* points = [self.shapeData[C4ShapeCurvePointsKey] mutableCopy];
    C4Assert(points, @"You tried to access pointA from a shape that isn't a curve");
    
    [points replaceObjectAtIndex:1 withObject:[NSValue valueWithCGPoint:controlPointA]];
    [self curve:points];
}

- (CGPoint)controlPointB {
    NSArray* points = self.shapeData[C4ShapeCurvePointsKey];
    C4Assert(points, @"You tried to access pointA from a shape that isn't a curve");
    return [points[2] CGPointValue];
}

- (void)setControlPointB:(CGPoint)controlPointB {
    NSMutableArray* points = [self.shapeData[C4ShapeCurvePointsKey] mutableCopy];
    C4Assert(points, @"You tried to access pointA from a shape that isn't a curve");
    
    [points replaceObjectAtIndex:2 withObject:[NSValue valueWithCGPoint:controlPointB]];
    [self curve:points];
}

- (void)setCenter:(CGPoint)center {
    CGFloat dx = center.x - self.center.x;
    CGFloat dy = center.y - self.center.y;
    
    NSArray* points = [self.shapeData[C4ShapeCurvePointsKey] mutableCopy];
    NSMutableArray* newPoints = [NSMutableArray arrayWithCapacity:4];
    for (NSValue* value in points) {
        CGPoint point = [value CGPointValue];
        point.x += dx;
        point.y += dy;
        [newPoints addObject:[NSValue valueWithCGPoint:point]];
    }
    
    [super setCenter:center];
}

@end
