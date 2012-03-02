//
//  C4ShapeLayer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

@interface C4ShapeLayer : CAShapeLayer {
    NSString *currentAnimationEasing;
}
-(void)test;
-(void)animatePath:(CGPathRef)_path;
-(void)animateFillColor:(CGColorRef)_fillColor;
-(void)animateLineWidth:(CGFloat)_lineWidth;
-(void)animateMiterLimit:(CGFloat)_miterLimit;
-(void)animateStrokeColor:(CGColorRef)_strokeColor;
-(void)animateStrokeEnd:(CGFloat)_strokeEnd;
-(void)animateStrokeStart:(CGFloat)_strokeStart;
-(void)animateShadowOpacity:(CGFloat)_shadowOpacity;
-(void)animateShadowRadius:(CGFloat)_shadowRadius;
-(void)animateShadowOffset:(CGSize)_shadowOffset;
-(void)animateShadowPath:(CGPathRef)_shadowPath;
-(void)animateBackgroundFilters:(NSArray *)_backgroundFilters;
-(void)animateCompositingFilter:(id)_compositingFilter;

@property (readonly) BOOL isShapeLayer;
@property (nonatomic) NSUInteger animationOptions;
@property (nonatomic) CGFloat repeatCount, animationDuration;
@property (readonly, strong) NSString *currentAnimationEasing;
@property (readonly, nonatomic) BOOL allowsInteraction, repeats;
@end
