//
//  C4Math.m
//  C4Core
//
//  Created by Travis Kirton on 12-02-07.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Math.h"

static C4Math *sharedC4Math = nil;

@implementation C4Math
#pragma mark Singleton

+ (C4Math*)sharedManager
{
    if (sharedC4Math == nil) {
        static dispatch_once_t once;
        dispatch_once(&once, ^ { sharedC4Math = [[super allocWithZone:NULL] init]; 
        });
        return sharedC4Math;
    }
    return sharedC4Math;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedManager];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

#pragma mark Initialization

+(void)load {
	if(VERBOSELOAD) printf("C4Math\n");
}

#pragma mark Calculation
+(NSInteger)abs:(NSInteger)value {
	return abs((int)value);
}

+(CGFloat)absf:(CGFloat)value {
	return fabsf(value);
}

+(NSInteger)ceil:(CGFloat)value {
	return (NSInteger)ceilf(value);
}

+(NSInteger)constrain:(NSInteger)value min:(NSInteger)min max:(NSInteger)max {
	return (NSInteger)[self constrainf:value min:min max:max];
}

+(CGFloat)constrainf:(CGFloat)value min:(CGFloat)min max:(CGFloat)max {
	if (min < value && value < max) return value;
	else if (value <= min) return min;
	else return max;
}

+(CGFloat)exp:(CGFloat)value {
	return [self pow:E raisedTo:value];
}

+(NSInteger)floor:(CGFloat)value {
	return floor((double)value);
}

+(CGFloat)lerpBetweenA:(CGFloat)a B:(CGFloat)b byAmount:(CGFloat)amount {
    CGFloat range = b-a;
	return a+range*amount;
}

+(CGFloat)log:(CGFloat)value {
	return logf(value);
}

+(CGFloat)map:(CGFloat)value fromMin:(CGFloat)min1 max:(CGFloat)max1 toMin:(CGFloat)min2 max:(CGFloat)max2 {
	float rangeLength1 = max1-min1;
	float rangeLength2 = max2-min2;
	float multiplier = (value-min1)/rangeLength1;
	return multiplier*rangeLength2+min2;
}

+(CGFloat)maxOfA:(CGFloat)a B:(CGFloat)b {
	float max = a > b ? a : b;
	return max;
}

+(CGFloat)maxOfA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c {
	return [self maxOfA:[self maxOfA:a B:b] B:c];
}


+(CGFloat)minOfA:(CGFloat)a B:(CGFloat)b {
	float min = a < b ? a : b;
	return min;
}

+(CGFloat)minOfA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c {
	return [self minOfA:[self minOfA:a B:b] B:c];
}

+(CGFloat)norm:(CGFloat)value fromMin:(CGFloat)min toMax:(CGFloat)max {
	return 0;
}

+(CGFloat)pow:(CGFloat)value raisedTo:(CGFloat)degree {
	return powf(value,degree);
}

+(CGFloat)round:(CGFloat)value {
	return roundf(value);
}

+(CGFloat)square:(CGFloat)value {
	return powf(value, 2);
}

+(CGFloat)sqrt:(CGFloat)value {
	return sqrtf(value);
}

#pragma mark Trigonometry
+(CGFloat)acos:(CGFloat)value {
	return acosf(value);
}

+(CGFloat)asin:(CGFloat)value {
	return asinf(value);
}

+(CGFloat)atan:(CGFloat)value {
	return atanf(value);
}

+(CGFloat)atan2Y:(CGFloat)y X:(CGFloat)x {
	return atan2f(y,x);
}

+(CGFloat)cos:(CGFloat)value {
	return cosf(value);
}
+(CGFloat)sin:(CGFloat)value {
	return sinf(value);
}

+(CGFloat)tan:(CGFloat)value {
	return tanf(value);
}
#pragma mark Random
+(NSInteger)randomInt:(NSInteger)value {
	srandomdev();
	return ((NSInteger)random())%value;
}

+(NSInteger)randomIntBetweenA:(NSInteger)a andB:(NSInteger)b{
    NSInteger returnVal;
	if (a == b) {
        returnVal = a;
    }
    else {
        NSInteger max = a > b ? a : b;
        NSInteger min = a < b ? a : b;
        NSAssert(max-min > 0, @"Your expression returned true for max-min <= 0 for some reason");
        srandomdev();
        returnVal = (((NSInteger)random())%(max-min) + min);
    }
    return returnVal;
}

#pragma mark Math Conversion Functions
NSInteger RadiansToDegrees(CGFloat radianValue) {
    NSInteger degreeValue = ((radianValue) * 180.0f / PI);
    return degreeValue;
}

CGFloat DegreesToRadians(NSInteger degreeValue) {
    CGFloat radianValue = degreeValue * PI / 180.0f;
    return radianValue;
}

NSInteger FloatToRGB(CGFloat floatValue) {
    NSInteger rgbValue = floatValue > 1.0f ? 255 : floatValue * 255.0f;
    return rgbValue;
}

CGFloat RGBToFloat(NSInteger rgbValue) {
    if(rgbValue < 0) rgbValue = 0;
    CGFloat floatValue = ((CGFloat)rgbValue) / 255.0f;
    return floatValue;
}

@end
