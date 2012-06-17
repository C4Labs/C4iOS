//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface C4WorkSpace ()
-(void)startClock;
@end

@implementation C4WorkSpace {
    C4Shape *line;
    
}

-(void)setup {
    CGPoint linePoints[2] = {CGPointZero, CGPointMake(0, 100)};
    line = [C4Shape line:linePoints];
    line.origin = self.canvas.center;
    line.layer.anchorPoint = CGPointMake(1, 1);
    [self.canvas addShape:line];
    [self runMethod:@"startClock" afterDelay:0.1f];
} 

-(void)startClock {
    line.animationDuration = 60.0f;
    line.animationOptions = LINEAR | REPEAT;
    line.rotation = TWO_PI;
}

@end