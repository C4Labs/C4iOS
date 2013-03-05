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
    b2.origin = CGPointMake(0,50);
    [b2 setTitle:@"Travis" forState:NORMAL];
    [self.canvas addSubview:b2];
    [b2 runMethod:@"randomBackground" target:self forEvent:TOUCHDOWN];
}

-(void)randomBackground {
    self.canvas.animationDuration = 1.0f;
    self.canvas.backgroundColor = [UIColor colorWithRed:[C4Math randomInt:100]/100.0f green:[C4Math randomInt:100]/100.0f blue:[C4Math randomInt:100]/100.0f alpha:1.0f];
}

@end
