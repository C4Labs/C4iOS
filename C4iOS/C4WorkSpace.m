//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *s;
}

-(void)setup {
    CGPoint points[2] = {
        CGPointMake(284,512),
        CGPointMake(484,512),
    };
    s = [C4Shape line:points];
    [self.canvas addShape:s];
}

-(void)touchesBegan {
    s.animationDuration = 1.0f;
    s.rotation += QUARTER_PI;
}

@end
