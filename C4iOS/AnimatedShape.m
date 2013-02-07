//
//  AnimatedShape.m
//  C4iOS
//
//  Created by moi on 13-02-06.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "AnimatedShape.h"

@implementation AnimatedShape {
    C4Shape *s;
}

-(void)setup {
    self.lineWidth = 0.0f;
    s = [C4Shape ellipse:CGRectMake(0, 0, 15, 15)];
    s.alpha = 0.0f;
    s.center = CGPointZero;
    s.lineWidth = 0.0f;
    [self addShape:s];
}

-(void)startAnimation {
    s.animationDuration = 2.0f;
    s.animationOptions = AUTOREVERSE | REPEAT;
    s.center = CGPointMake(276, 0);
    s.alpha = 1.0f;
}

-(AnimatedShape *)copyWithZone:(NSZone *)zone {
    AnimatedShape *as = [[AnimatedShape allocWithZone:zone] initWithFrame:self.frame];
    as.style = self.style;
    return as;
}

@end
