//
//  C4Layer.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface C4Layer : CALayer {
}
#pragma mark C4Layer Animation Methods
-(CABasicAnimation *)setupBasicAnimationWithKeyPath:(NSString *)keyPath;
-(void)setAnimationOptions:(NSUInteger)animationOptions;

#pragma mark C4Layer methods
-(void)animateShadowColor:(CGColorRef)shadowColor;
-(void)animateShadowOpacity:(CGFloat)shadowOpacity;
-(void)animateShadowRadius:(CGFloat)shadowRadius;
-(void)animateShadowOffset:(CGSize)shadowOffset;
-(void)animateShadowPath:(CGPathRef)shadowPath;
-(void)animateBackgroundFilters:(NSArray *)backgroundFilters;
-(void)animateCompositingFilter:(id)compositingFilter;
-(void)test;

-(BOOL)isOpaque;

#pragma mark C4Layer properties
@property (nonatomic) NSUInteger animationOptions;
@property (nonatomic) CGFloat repeatCount, animationDuration;
@property (readonly, strong) NSString *currentAnimationEasing;
@property (readonly, nonatomic) BOOL allowsInteraction, repeats;
@end