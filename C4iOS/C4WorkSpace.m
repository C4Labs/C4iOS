//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Slider *s1, *s2;
}

-(void)setup {
    s1 = [C4Slider slider:CGRectMake(0, 0, 368, 44)];
    [s1 setThumbImage:[C4Image imageNamed:@"pyramid"] forState:NORMAL];
    [self.canvas addSubview:s1];
}

-(void)touchesBegan {
    s2 = [s1 copy];
    s2.center = self.canvas.center;
    [self.canvas addSubview:s2];
}

@end
