//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
}

-(void)setup {
    [self addGesture:TAP name:@"tap" action:@"tapped"];
    UIGestureRecognizer *g = [self gestureForName:@"tap"];
    g.delaysTouchesBegan = NO;
}

-(void)tapped {
    C4Log(@"Called when the gesture recognizes a tap");
}

-(void)touchesBegan {
    C4Log(@"Called only if g.delaysTouchesBegan == NO");
}
@end
