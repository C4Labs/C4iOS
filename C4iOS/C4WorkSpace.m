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
    //declare custom variables here
    C4Shape *arc;
}

-(void)setup {
    arc = [C4Shape arcWithCenter:self.canvas.center radius:100 startAngle:0 endAngle:PI]; //works
    [arc closeShape]; //works
    arc.center = self.canvas.center; //works
    [self.canvas addShape:arc];
} 

@end
