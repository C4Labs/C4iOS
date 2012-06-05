//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *polygon;
}

-(void)setup {
    CGPoint polyPoints[3] = {CGPointMake(100, 100), CGPointMake(200, 150), CGPointMake(100, 200)};
    polygon = [C4Shape polygon:polyPoints pointCount:3];
    [self.canvas addShape:polygon];
}

-(void)touchesBegan {
    polygon.animationDuration = 3.0f;
    [polygon closeShape];
}
@end
