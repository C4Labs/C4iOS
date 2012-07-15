//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *s1, *s2;
}

-(void)setup {
    s1 = [C4Shape ellipse:CGRectMake(0, 0, 100, 100)];
    [self.canvas addShape:s1];
}

-(void)touchesBegan {
    s1.animationDuration = 2.0f;
    s1.animationOptions = EASEOUT;
    s1.backgroundColor = C4GREY;
    s1.center = self.canvas.center;
}

@end