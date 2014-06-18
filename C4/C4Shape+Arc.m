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
#import "C4Shape+Arc.h"

NSString* const C4ShapeArcType = @"arc";


@implementation C4Shape (Arc)

+ (instancetype)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    //I'm not sure what's going on here, but i have to invert clockwise to get the
    CGRect arcRect = CGRectMakeFromArcComponents(centerPoint,radius,startAngle,endAngle,!clockwise);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:arcRect];
    [newShape arcWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    return newShape;
}

- (void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    self.shapeData = @{
        C4ShapeTypeKey: C4ShapeArcType
    };
    
    CGMutablePathRef newPath = CGPathCreateMutable();
    //strage, i have to invert the Bool value for clockwise
    CGPathAddArc(newPath, nil, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, !clockwise);
    CGRect arcRect = CGPathGetBoundingBox(newPath);
    
    const CGAffineTransform translation = CGAffineTransformMakeTranslation(arcRect.origin.x *-1, arcRect.origin.y *-1);
    CGMutablePathRef translatedPath = CGPathCreateMutableCopyByTransformingPath(newPath, &translation);
    CGPathRelease(newPath);
    
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)translatedPath];
    CGRect pathRect = CGPathGetPathBoundingBox(translatedPath);
    self.bounds = pathRect;
    CGPathRelease(translatedPath);
    
    self.initialized = YES;
}

- (BOOL)isArc {
    return [[self.shapeData objectForKey:C4ShapeTypeKey] isEqualToString:C4ShapeArcType];
}

@end
