//
//  C4ShapeLayer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

@interface C4ShapeLayer : CAShapeLayer <C4LayerAnimation> {
//    NSString *currentAnimationEasing;
}

#pragma mark C4ShapeLayer animation methods
-(void)animatePath:(CGPathRef)_path;
-(void)animateFillColor:(CGColorRef)_fillColor;
-(void)animateLineWidth:(CGFloat)_lineWidth;
-(void)animateMiterLimit:(CGFloat)_miterLimit;
-(void)animateStrokeColor:(CGColorRef)_strokeColor;
-(void)animateStrokeEnd:(CGFloat)_strokeEnd;
-(void)animateStrokeStart:(CGFloat)_strokeStart;

#pragma mark Test
-(void)test;
@property (readonly) BOOL isShapeLayer;
@end
