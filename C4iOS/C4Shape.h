//
//  C4ShapeView.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4View.h"
#import "C4ShapeLayer.h"

@interface C4Shape : C4View {
    @private
    C4ShapeLayer *shapeLayer;
}

+(C4Shape *)ellipse:(CGRect)aRect;
+(C4Shape *)rect:(CGRect)aRect;
+(C4Shape *)line:(CGPoint *)pointArray;
+(C4Shape *)triangle:(CGPoint *)pointArray;
+(C4Shape *)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount;
+(C4Shape *)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;
+(C4Shape *)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;
-(void)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;
/* 
 add curves and arcs
 */

-(void)closeShape;
-(void)ellipse:(CGRect)aRect;
-(void)rect:(CGRect)aRect;
-(void)line:(CGPoint *)pointArray;
-(void)triangle:(CGPoint *)pointArray;
-(void)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount;
-(void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;

-(void)setDashPattern:(CGFloat *)dashPattern pointCount:(NSUInteger)pointCount;
-(void)test;

@property (readwrite, strong) C4ShapeLayer *shapeLayer;
@property (readonly) BOOL isLine;
@property (readwrite, nonatomic) CGPoint pointA, pointB;
@property (readwrite, strong, nonatomic) UIColor *fillColor, *strokeColor;
@property (readwrite, nonatomic) CGFloat lineDashPhase, lineWidth, miterLimit, strokeEnd, strokeStart, shadowOpacity, shadowRadius;
@property (readwrite, strong, nonatomic) NSArray *lineDashPattern;
@property (readwrite, strong, nonatomic) NSString *fillRule, *lineCap, *lineJoin;
@property (readwrite, nonatomic) CGSize shadowOffset;

@end
