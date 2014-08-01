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
#import "C4Shape+Polygon.h"

NSString* const C4ShapePolygonType = @"polygon";
NSString* const C4ShapePolygonPointsKey = @"polygonPoints";
NSString* const C4ShapePolygonClosedKey = @"polygonClosed";

@implementation C4Shape (Polygon)

+ (instancetype)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount closed:(BOOL)closed {
    C4Shape *newShape = [[C4Shape alloc] init];
    [newShape polygon:pointArray pointCount:pointCount closed:closed];
    return newShape;
}

- (void)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount closed:(BOOL)closed {
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:pointCount];
    for (NSInteger i = 0; i < pointCount; i += 1) {
        [array addObject:[NSValue valueWithCGPoint:pointArray[i]]];
    }
    [self polygon:array closed:closed];
}

- (void)polygon:(NSArray*)points closed:(BOOL)closed {
    self.shapeData = @{
        C4ShapeTypeKey: C4ShapePolygonType,
        C4ShapePolygonPointsKey: points,
        C4ShapePolygonClosedKey: @(closed)
    };
    
    [self updatePathWithPoints:points];
    self.initialized = YES;
}

- (CGPathRef)createPathWithPoints:(NSArray*)points closed:(BOOL)closed transform:(CGAffineTransform*)t {
    CGMutablePathRef newPath = CGPathCreateMutable();
    if (points.count > 0) {
        CGPoint point = [points[0] CGPointValue];
        CGPathMoveToPoint(newPath, t, point.x, point.y);
    }
    
    for (NSUInteger i = 1; i < points.count; i++) {
        CGPoint point = [points[i] CGPointValue];
        CGPathAddLineToPoint(newPath, t, point.x, point.y);
    }
    
    if (closed)
        CGPathCloseSubpath(newPath);
    
    return newPath;
}

- (BOOL)isPolygon {
    return [[self.shapeData objectForKey:C4ShapeTypeKey] isEqualToString:C4ShapePolygonType];
}

- (BOOL)isClosed {
    return [[self.shapeData objectForKey:C4ShapePolygonClosedKey] boolValue];
}

- (NSArray*)points {
    NSArray* points = self.shapeData[C4ShapePolygonPointsKey];
    C4Assert(points, @"You tried to access the points from a shape that isn't a polygon");
    return points;
}

- (CGPoint)firstPoint {
    NSValue* value = [self.points firstObject];
    return [value CGPointValue];
}

- (CGPoint)lastPoint {
    NSValue* value = [self.points lastObject];
    return [value CGPointValue];
}

- (CGPoint)pointAtIndex:(NSUInteger)index {
    NSValue* value = [self.points objectAtIndex:index];
    return [value CGPointValue];
}

- (void)setPoint:(CGPoint)point atIndex:(NSUInteger)index {
    NSMutableArray* points = [self.points mutableCopy];
    [points replaceObjectAtIndex:index withObject:[NSValue valueWithCGPoint:point]];
    
    NSMutableDictionary* data = [self.shapeData mutableCopy];
    [data setObject:points forKey:C4ShapePolygonPointsKey];
    self.shapeData = data;
    
    [self updatePathWithPoints:points];
}

- (void)updatePathWithPoints:(NSArray*)points {
    BOOL closed = self.isClosed;
    
    // Determine path bounding box
    CGPathRef tmpPath = [self createPathWithPoints:points closed:closed transform:NULL];
    CGRect newFrame = CGPathGetPathBoundingBox(tmpPath);
    CGPathRelease(tmpPath);
    
    // Transform points to the new frame
    CGPoint origin = newFrame.origin;
    CGAffineTransform t = CGAffineTransformMakeTranslation(-origin.x, -origin.y);
    
    // Set new path and frame
    CGPathRef newPath = [self createPathWithPoints:points closed:closed transform:&t];
    self.path = newPath;
    self.frame = newFrame;
    CGPathRelease(newPath);
}

@end
