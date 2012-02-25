//
//  C4View.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C4View : UIView <C4CommonMethods> {
}

-(void)addShape:(C4Shape *)aShape;

@property CGFloat animationDuration, animationDelay;
@property (nonatomic) NSUInteger animationOptions;
@property (nonatomic) CGFloat repeatCount;
@property (readonly, nonatomic) BOOL isAnimating;
@end
