//
//  C4Foundation.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4Foundation.h"
#import <sys/utsname.h>

static C4Foundation *sharedC4Foundation = nil;

@interface C4Foundation (private)
NSInteger numSort(id num1, id num2, void *context);
NSInteger strSort(id str1, id str2, void *context);
NSInteger floatSort(id obj1, id obj2, void *context);	
@end

@implementation C4Foundation

- (id)init {
    self = [super init];
    if (self) {
#ifdef VERBOSE
        C4Log(@"%@ init",[self class]);
#endif
        floatSortComparator = ^(id obj1, id obj2) {
            float flt1 = [obj1 floatValue];
            float flt2 = [obj2 floatValue];
            if (flt1 < flt2)
                return NSOrderedAscending;
            else if (flt1 > flt2)
                return NSOrderedDescending;
            else
                return NSOrderedSame;
        };
    }
    
    return self;
}

+(C4Foundation *)sharedManager {
    if (sharedC4Foundation == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^ { sharedC4Foundation = [[super allocWithZone:NULL] init]; 
        });
        return sharedC4Foundation;
    }
    return sharedC4Foundation;
}

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

-(NSComparator) floatComparator {
    return floatSortComparator;
}
+(NSComparator) floatComparator {
    return [[self sharedManager] floatComparator];
}

+(id)allocWithZone:(NSZone *)zone {
    zone = zone;
    return [self sharedManager];
}

-(id)copyWithZone:(NSZone *)zone {
    zone = zone;
    return self;
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
