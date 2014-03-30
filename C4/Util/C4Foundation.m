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

#import "C4Foundation.h"
#import <sys/utsname.h>

@interface C4Foundation (private)
NSInteger numSort(id num1, id num2, void *context);
NSInteger strSort(id str1, id str2, void *context);
NSInteger floatSort(id obj1, id obj2, void *context);
@end

@implementation C4Foundation

void C4Log(NSString *logString,...) {
    va_list args;
    
    va_start (args, logString);
    NSString *finalString = [[NSString alloc] initWithFormat:
                             [logString stringByAppendingString: @"\n"] arguments:args];
    va_end (args);
    
    fprintf(stderr,"[C4Log] %s",[finalString UTF8String]);
}

NSInteger basicSort(id obj1, id obj2, void *context) {
    if([obj1 class] == [NSNumber class]){
        return numSort(obj1, obj2, context);
    }
    
    if([obj1 class] == [@"" class] || [obj1 class] == [NSString class]){
        return strSort(obj1, obj2, context);
    }
    return floatSort(obj1, obj2, context);
}

NSInteger numSort(id num1, id num2, void *context) {
    context = context;
    return [(NSNumber *)num1 compare:(NSNumber *)num2];
}

NSInteger strSort(id str1, id str2, void *context) {
    context = context;
    return [str1 localizedStandardCompare:str2];
}

NSInteger floatSort(id obj1, id obj2, void *context) {
    context = context;
    float flt1 = [obj1 floatValue];
    float flt2 = [obj2 floatValue];
    if (flt1 < flt2)
        return NSOrderedAscending;
    else if (flt1 > flt2)
        return NSOrderedDescending;
    else
        return NSOrderedSame;
}

+ (NSComparator)floatComparator {
    static NSComparator floatSortComparator = ^(id obj1, id obj2) {
        float flt1 = [obj1 floatValue];
        float flt2 = [obj2 floatValue];
        if (flt1 < flt2)
            return NSOrderedAscending;
        else if (flt1 > flt2)
            return NSOrderedDescending;
        else
            return NSOrderedSame;
    };
    return floatSortComparator;
}


#pragma mark New Stuff
CGRect CGRectMakeFromPointArray(CGPoint *pointArray, int pointCount) {
    //iterate and add the points into a mutable path
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, pointArray[0].x, pointArray[0].y);
    for(int i = 1; i < pointCount; i++) {
        CGPathAddLineToPoint(newPath, nil, pointArray[i].x, pointArray[i].y);
    }
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    CGPathRelease(newPath);
    return pathRect;
}

CGRect CGRectMakeFromArcComponents(CGPoint centerPoint, CGFloat radius, CGFloat startAngle, CGFloat endAngle, BOOL clockwise) {
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathAddArc(arcPath, nil, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, clockwise);
    CGRect arcRect = CGPathGetBoundingBox(arcPath);
    CGPathRelease(arcPath);
    return arcRect;
}

CGRect CGRectMakeFromWedgeComponents(CGPoint centerPoint, CGFloat radius, CGFloat startAngle, CGFloat endAngle, BOOL clockwise) {
    CGMutablePathRef arcPath = CGPathCreateMutable();
    CGPathAddArc(arcPath, nil, centerPoint.x, centerPoint.y, radius, startAngle, endAngle, !clockwise);
    CGPathAddLineToPoint(arcPath, nil, centerPoint.x, centerPoint.y);
    CGRect arcRect = CGPathGetBoundingBox(arcPath);
    CGPathRelease(arcPath);
    return arcRect;
}

+(NSString *)currentDeviceModel {
    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}
@end
