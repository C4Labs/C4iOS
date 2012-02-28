//
//  TestView.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-25.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "TestView.h"

@implementation TestView
-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
    NSArray *array = [NSArray arrayWithObjects:(id)[UIColor blueColor].CGColor,(id)[UIColor redColor].CGColor,nil];
    [(CAGradientLayer *)self.layer setColors:array];
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [UIView animateWithDuration:2.0f
                          delay:0.0f
                        options:UIViewAnimationCurveEaseInOut
                     animations:^{
                         CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
                         animation.duration = 2.0f;
                         animation.delegate = self;
                         animation.fromValue = ((CAGradientLayer *)self.layer).colors;
                         animation.toValue = [NSArray arrayWithObjects:(id)[UIColor blackColor].CGColor,(id)[UIColor whiteColor].CGColor,nil];
                         [self.layer addAnimation:animation forKey:@"animateColors"];
                     }
                     completion:nil];
}

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSString *keyPath = ((CAPropertyAnimation *)anim).keyPath;
    if ([keyPath isEqualToString:@"colors"]) {
        ((CAGradientLayer *)self.layer).colors = ((CABasicAnimation *)anim).toValue;
    }
}
+(Class)layerClass {
    return [CAGradientLayer class];
}
@end
