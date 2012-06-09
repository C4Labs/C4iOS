//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface C4WorkSpace ()
    //declare custom methods and properties here
@end

@implementation C4WorkSpace {
    C4Shape *curve;
}

-(void)setup {
    CGPoint endPoints[2] = {CGPointZero,CGPointMake(200, 200)};
    CGPoint controlPoints[2] = {CGPointMake(100, -100),CGPointMake(100, 300)};
    curve = [C4Shape curve:endPoints controlPoints:controlPoints];
    curve.backgroundColor = C4GREY;
    curve.center = self.canvas.center;
    [self.canvas addShape:curve];
} 

@end
