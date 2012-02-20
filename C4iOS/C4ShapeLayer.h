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
-(void)setAnimationDurationValue:(CGFloat)duration;
-(CGFloat)animationDurationValue;
-(void)test;

@property (nonatomic) NSUInteger animationOptions;
@property (nonatomic) CGFloat repeatCount;
@property (readonly, strong) NSString *currentAnimationEasing;
@property (readonly, nonatomic) BOOL allowsInteraction, repeats;
@end
