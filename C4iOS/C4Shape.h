//
//  C4ShapeView.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4ShapeLayer.h"

@interface C4Shape : C4Control {
}

/*
 should add adding shapes to shapes
 */

+(C4Shape *)ellipse:(CGRect)aRect;
+(C4Shape *)rect:(CGRect)aRect;
+(C4Shape *)line:(CGPoint *)pointArray;
+(C4Shape *)triangle:(CGPoint *)pointArray;
+(C4Shape *)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount;
+(C4Shape *)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
+(C4Shape *)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;
+(C4Shape *)shapeFromString:(NSString *)string withFont:(C4Font *)font;

-(void)closeShape;
-(void)ellipse:(CGRect)aRect;
-(void)rect:(CGRect)aRect;
-(void)line:(CGPoint *)pointArray;
-(void)triangle:(CGPoint *)pointArray;
-(void)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount;
-(void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
-(void)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;
-(void)shapeFromString:(NSString *)string withFont:(C4Font *)font;

-(void)setDashPattern:(CGFloat *)dashPattern pointCount:(NSUInteger)pointCount;
-(void)test;

@property (readonly, weak) C4ShapeLayer *shapeLayer;
@property (readonly) BOOL isLine;
@property (readwrite, nonatomic) CGPoint pointA, pointB, origin;
@property (readwrite, strong, nonatomic) UIColor *fillColor, *strokeColor;
@property (readwrite, nonatomic) CGFloat lineDashPhase, lineWidth, miterLimit, strokeEnd, strokeStart;
@property (readwrite, nonatomic) CGFloat shadowOpacity, shadowRadius;
@property (readwrite, nonatomic) CGSize shadowOffset;
@property (readwrite, strong, nonatomic) NSArray *lineDashPattern;
@property (readwrite, strong, nonatomic) NSString *fillRule, *lineCap, *lineJoin;


@end
