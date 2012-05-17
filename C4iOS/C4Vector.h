//
//  C4Vector.h
//  vectors
//
//  Created by Travis Kirton on 12-05-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"
#import <Accelerate/Accelerate.h>

@interface C4Vector : C4Object

+(CGFloat)distanceBetweenA:(CGPoint)pointA andB:(CGPoint)pointB;
+(CGFloat)angleBetweenA:(CGPoint)pointA andB:(CGPoint)pointB;

+(id)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

-(id)initWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
-(void)setX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;
-(void)add:(C4Vector *)aVec;
-(void)addScalar:(float)scalar;
-(void)divide:(C4Vector *)aVec;
-(void)divideScalar:(float)scalar;
-(void)multiply:(C4Vector *)aVec;
-(void)multiplyScalar:(float)scalar;
-(void)subtract:(C4Vector *)aVec;
-(void)subtractScalar:(float)scalar;
-(CGFloat)distance:(C4Vector *)aVec;
-(CGFloat)dot:(C4Vector *)aVec;
-(CGFloat)angleBetween:(C4Vector *)aVec;
-(void)cross:(C4Vector *)aVec;
-(void)normalize;
-(void)limit:(CGFloat)max;
-(CGFloat)headingBasedOn:(CGPoint)p;

@property (readonly) float *vec;
@property (readwrite, nonatomic) CGFloat x, y, z;
@property (readonly, nonatomic) CGFloat magnitude, heading, displacedHeading;
@property (readonly, nonatomic) CGPoint CGPoint;
@end
