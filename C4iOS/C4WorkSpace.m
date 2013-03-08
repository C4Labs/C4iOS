//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
#import "C4ScrollView.h"

@implementation C4WorkSpace {
    C4ScrollView *sv;
    C4Shape *s1, *s2;
    CAShapeLayer *layer;
}

-(void)setup {
    s1 = [C4Shape rect:CGRectMake(100, 100, 100, 100)];
    s1.rotation = QUARTER_PI;
    s1.lineWidth = 20.0f;
    [self.canvas addShape:s1];
}

-(void)touchesBegan {
    s1.animationDuration = 0.25f;
    s1.rotation -= QUARTER_PI;
    s1.lineWidth = 5.0f;
}

@end
