//
//  C4Foundation.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4Foundation.h"

static C4Foundation *sharedC4Foundation = nil;

@interface C4Foundation (private)
NSInteger numSort(id num1, id num2, void *context);
NSInteger strSort(id str1, id str2, void *context);
NSInteger floatSort(id obj1, id obj2, void *context);	
@end

@implementation C4Foundation

- (id)init
{
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
	return [num1 compare:num2];
}

NSInteger strSort(id str1, id str2, void *context) {
	return [str1 localizedStandardCompare:str2];
}

NSInteger floatSort(id obj1, id obj2, void *context) {
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

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
