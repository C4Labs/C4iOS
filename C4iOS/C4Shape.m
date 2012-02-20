//
//  C4ShapeView.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Shape.h"

@interface C4Shape()
//-(void)animateWithBlock:(void (^)(void))blockAnimation completion:(void (^)(BOOL completed))blockCompletion;
@end

@implementation C4Shape
@synthesize animationDuration = _animationDuration;
@synthesize isLine =_isLine, shapeLayer, pointA = _pointA, pointB = _pointB;
@synthesize fillColor, fillRule, lineCap, lineDashPattern, lineDashPhase, lineJoin, lineWidth, mitreLimit, strokeColor, strokeEnd, strokeStart;
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.animationDuration = 0.0f;
        self.shapeLayer = [[C4ShapeLayer alloc] init];
        self.strokeColor = [UIColor redColor];
        self.fillColor = [UIColor blueColor];
        self.lineWidth = 20.0f;
        _isLine = NO;
        [self.layer addSublayer:shapeLayer];
    }
    return self;
}

+(C4Shape *)ellipse:(CGRect)aRect {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:aRect];
    [newShape ellipse:aRect];
    return newShape;
}

+(C4Shape *)rect:(CGRect)aRect {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:aRect];
    [newShape rect:aRect];
    return newShape;
}

+(C4Shape *)line:(CGPoint *)pointArray {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectZero];
    [newShape line:pointArray];
    return newShape;
}

+(C4Shape *)triangle:(CGPoint *)pointArray {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectZero];
    [newShape triangle:pointArray];
    return newShape;
}

+(C4Shape *)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectZero];
    [newShape polygon:pointArray pointCount:pointCount];
    return newShape;
}

/* the technique in both the following methods allows me to change the shape of a shape and change the shape of their view's frame automatically */
-(void)ellipse:(CGRect)aRect {
    _isLine = NO;
    CGMutablePathRef newPath = CGPathCreateMutable();//(self.shapeLayer.path);
    CGRect newPathRect = CGRectMake(0, 0, aRect.size.width, aRect.size.height);
    CGPathAddEllipseInRect(newPath, nil, newPathRect);
    self.shapeLayer.path = newPath;
    self.frame = aRect;
}

-(void)rect:(CGRect)aRect {
    _isLine = NO;
    CGMutablePathRef newPath = CGPathCreateMutable();//(self.shapeLayer.path);
    CGRect newPathRect = CGRectMake(0, 0, aRect.size.width, aRect.size.height);
    CGPathAddRect(newPath, nil, newPathRect);
    self.shapeLayer.path = newPath;
    self.frame = aRect;
    CGPathRelease(newPath);
}

-(void)line:(CGPoint *)pointArray {
    _isLine = YES;
    [self polygon:pointArray pointCount:2];
}

-(void)triangle:(CGPoint *)pointArray {
    _isLine = NO;
    [self polygon:pointArray pointCount:3];
    [self closeShape];
}

/* 
 for polygons, you're not given a rect right away
 so, i create a path, get the bounding box, then shift all the points to CGPointZero
 and recreate the path so that it sits at CGPointZero in its superview
 and then i move the superview to the right position and size
 */

/*
 
 */
-(void)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount {
    CGMutablePathRef newPath = CGPathCreateMutable();//(self.shapeLayer.path);
    CGPathMoveToPoint(newPath, nil, pointArray[0].x, pointArray[0].y);
    for(int i = 1; i < pointCount; i++) {
        CGPathAddLineToPoint(newPath, nil, pointArray[i].x, pointArray[i].y);
    }
    if(self.isLine) {
        _pointA = CGPointMake(pointArray[0].x, pointArray[0].y);
        _pointB = CGPointMake(pointArray[1].x, pointArray[1].y);
    }
    CGRect shapeRect = CGPathGetBoundingBox(newPath);
    CGPoint origin = shapeRect.origin;
    for(int i = 0; i < pointCount; i++) {
        pointArray[i].x -= origin.x;
        pointArray[i].y -= origin.y;
    }
    CGPathRelease(newPath);
    newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, pointArray[0].x, pointArray[0].y);
    for(int i = 1; i < pointCount; i++) {
        CGPathAddLineToPoint(newPath, nil, pointArray[i].x, pointArray[i].y);
    }
    self.shapeLayer.path = newPath;
    self.frame = shapeRect;
    CGPathRelease(newPath);
}

-(void)addShape {
    CGMutablePathRef newPath = CGPathCreateMutable();//(self.shapeLayer.path);
    CGPathAddEllipseInRect(newPath, nil, CGRectMake(0, 0, 200, 100));
    CGMutablePathRef shapeLayerPathCopy = CGPathCreateMutableCopy(self.shapeLayer.path);
    CGPathAddPath(shapeLayerPathCopy, nil, newPath);
    self.shapeLayer.path = shapeLayerPathCopy;
    CGRect bounds = CGPathGetBoundingBox(self.shapeLayer.path);
    bounds.origin = self.frame.origin;
    self.frame = bounds;
}

-(void)addAnotherShape {
    CGMutablePathRef newPath = CGPathCreateMutable();//(self.shapeLayer.path);
    CGPathAddEllipseInRect(newPath, nil, CGRectMake(0, 100, 200, 100));
    CGMutablePathRef shapeLayerPathCopy = CGPathCreateMutableCopy(self.shapeLayer.path);
    CGPathAddPath(shapeLayerPathCopy, nil, newPath);
    self.shapeLayer.path = shapeLayerPathCopy;
    CGRect bounds = CGPathGetBoundingBox(self.shapeLayer.path);
    bounds.origin = self.frame.origin;
    self.frame = bounds;
    CGPathRelease(newPath);
}

-(void)closeShape {
    CGFloat tempDuration = self.animationDuration;
    self.animationDuration = 0.0f;
    CGMutablePathRef newPath = CGPathCreateMutableCopy(self.shapeLayer.path);
    CGPathCloseSubpath(newPath);
    self.shapeLayer.path = newPath;
    CGPathRelease(newPath);
    self.animationDuration = tempDuration;
}

-(CGPoint)pointA {
    if (self.isLine == YES) {
        return _pointA;
    }
    return CGPointZero;
}

-(CGPoint)pointB {
    if (self.isLine == YES) {
        return _pointB;
    }
    return CGPointZero;
}

-(void)test {
    C4Log(@"(%4.2f,%4.2f) (%4.2f,%4.2f)",_pointA.x,_pointA.y,_pointB.x,_pointB.y);
}

-(void)setPointA:(CGPoint)pointA {
    /* there should be some option to deal with points in lines if the view has already been transformed */
    if(self.isLine == YES) {
        _pointA = pointA;
        CGPoint points[2] = {_pointA, _pointB};
        [self line:points];
    }
}

-(void)setPointB:(CGPoint)pointB {
    if(self.isLine == YES) {
        _pointB = pointB;
        CGPoint points[2] = {_pointA, _pointB};
        [self line:points];
    }
}

-(void)setFillColor:(UIColor *)_fillColor {   
    self.shapeLayer.fillColor = _fillColor.CGColor;
}

-(void)setFillRule:(NSString *)_fillRule {
    self.shapeLayer.fillRule = _fillRule;
}

-(void)setLineCap:(NSString *)_lineCap {
    self.shapeLayer.lineCap = _lineCap;
}

-(void)setDashPattern:(CGFloat *)dashPattern pointCount:(NSUInteger)pointCount {
    NSMutableArray *patternArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < pointCount; i++) [patternArray addObject:[NSNumber numberWithFloat:dashPattern[i]]];
    self.lineDashPattern = patternArray;
}
-(void)setLineDashPattern:(NSArray *)_lineDashPattern {
//    NSArray *array = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:5], nil]; 
    self.shapeLayer.lineDashPattern = _lineDashPattern;
}

-(void)setLineDashPhase:(CGFloat)_lineDashPhase {
    self.shapeLayer.lineDashPhase = _lineDashPhase;
}

-(void)setLineJoin:(NSString *)_lineJoin {
    self.shapeLayer.lineJoin = _lineJoin;
}

-(void)setLineWidth:(CGFloat)_lineWidth {
    self.shapeLayer.lineWidth = _lineWidth;
}

-(void)setMitreLimit:(CGFloat)_mitreLimit {
    self.shapeLayer.miterLimit = _mitreLimit;
}

-(void)setStrokeColor:(UIColor *)_strokeColor {
    self.shapeLayer.strokeColor = _strokeColor.CGColor;
}

-(void)setStrokeEnd:(CGFloat)_strokeEnd {
    self.shapeLayer.strokeEnd = _strokeEnd;
}

-(void)setStrokeStart:(CGFloat)_strokeStart {
    self.shapeLayer.strokeStart = _strokeStart;
}

-(void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
    [self.shapeLayer setAnimationDurationValue:animationDuration];
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    [super setAnimationOptions:animationOptions];
    self.shapeLayer.animationOptions = animationOptions;
}

/* leaving out repeat count for now... it's a bit awkward */
-(void)setRepeatCount:(CGFloat)repeatCount {
//    [super setRepeatCount:repeatCount];
//    self.shapeLayer.repeatCount = repeatCount;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    C4Log(@"hi");
}

-(BOOL)isAnimating {
    NSInteger animationKeyCount = [self.shapeLayer.animationKeys count];
    return animationKeyCount != 0 ? YES : NO;
}
//-(void)animateWithBlock:(void (^)(void))blockAnimation completion:(void (^)(BOOL completed))blockCompletion{
//    [UIView animateWithDuration:self.animationDuration
//                          delay:(NSTimeInterval)self.animationDelay
//                        options:self.animationOptions
//                     animations:blockAnimation
//                     completion:blockCompletion];
//};

@end
