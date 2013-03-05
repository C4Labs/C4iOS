//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
#import "C4Button.h"

@implementation C4WorkSpace {
    C4Button *b1, *b2;
}

-(void)setup {
    b1 = [C4Button buttonWithType:ROUNDEDRECT];
    [self.canvas addSubview:b1];
    [b1.UIButton addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchDown];
}

-(void)test {
    b2 = [b1 copy];
    b2.center = self.canvas.center;
    [self.canvas addSubview:b2];
}

@end
