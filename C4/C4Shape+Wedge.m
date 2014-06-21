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
#import "C4Shape+Wedge.h"

NSString* const C4ShapeWedgeType = @"wedge";

@implementation C4Shape (Wedge)

+ (instancetype)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    C4Shape *newShape = [[C4Shape alloc] init];
    [newShape wedgeWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    return newShape;
}

-(void)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    self.shapeData = @{
        C4ShapeTypeKey: C4ShapeWedgeType
    };
    
    // Determine path bounding box
    CGPathRef tmpPath = [self createPathWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise transform:NULL];
    CGRect newFrame = CGPathGetPathBoundingBox(tmpPath);
    CGPathRelease(tmpPath);
    
    // Transform points to the new frame
    CGPoint origin = newFrame.origin;
    CGAffineTransform t = CGAffineTransformMakeTranslation(-origin.x, -origin.y);
    
    // Set new path and frame
    CGPathRef newPath = [self createPathWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise transform:&t];
    self.path = newPath;
    self.frame = newFrame;
    CGPathRelease(newPath);
    
    self.initialized = YES;
}

- (CGMutablePathRef)createPathWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise transform:(CGAffineTransform*)t {
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathAddArc(newPath, t, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, !clockwise);
    CGPathAddLineToPoint(newPath, t, centerPoint.x, centerPoint.y);
    CGPathCloseSubpath(newPath);
    return newPath;
}

- (BOOL)isWedge {
    return [[self.shapeData objectForKey:C4ShapeTypeKey] isEqualToString:C4ShapeWedgeType];
}

@end
