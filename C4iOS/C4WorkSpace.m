//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface C4WorkSpace ()
@end

@implementation C4WorkSpace {
    C4Shape *translateRect, *transformRect;
}

-(void)setup {
    translateRect = [C4Shape rect:CGRectMake(100, 100, 100,100)];
    [self.canvas addShape:translateRect];
    
    transformRect = [C4Shape rect:CGRectMake(100, 300, 100, 100)];
    [self.canvas addShape:transformRect];
} 

-(void)test {
    translateRect.animationDuration = 1.0f;
    translateRect.animationOptions = AUTOREVERSE;
    translateRect.center = CGPointMake(384,150);

    transformRect.animationDuration = 1.0f;
    transformRect.animationOptions = AUTOREVERSE;
    transformRect.transform = CGAffineTransformMakeRotation(QUARTER_PI);
}

-(void)touchesBegan {
    [self test];
}

@end
