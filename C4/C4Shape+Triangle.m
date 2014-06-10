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
#import "C4Shape+Triangle.h"
#import "C4Shape+Polygon.h"

NSString* const C4ShapeTriangleType = @"curve";

@implementation C4Shape (Triangle)

+ (instancetype)triangle:(CGPoint *)pointArray {
    C4Shape *newShape = [[C4Shape alloc] init];
    [newShape triangle:pointArray];
    return newShape;
}

- (void)triangle:(CGPoint *)points {
    // This is a special case of a polygon
    [self polygon:points pointCount:3];
    
    NSMutableDictionary* data = [self.shapeData mutableCopy];
    [data setObject:C4ShapeTriangleType forKey:C4ShapeTypeKey];
    self.shapeData = data;
}

- (BOOL)isTriangle {
    return [[self.shapeData objectForKey:C4ShapeTypeKey] isEqualToString:C4ShapeTriangleType];
}

@end
