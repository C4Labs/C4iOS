//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
#import "C4Stepper.h"

@implementation C4WorkSpace {
    C4Stepper *s, *t;
}

-(void)setup {
    s = [C4Stepper stepper];
    t = [C4Stepper stepper];
    
    s.origin = CGPointMake(100,100);
    t.origin = CGPointMake(200,200);
    
    [s setDecrementImage:[C4Image imageNamed:@"pyramid"] forState:NORMAL];
    C4Image *divider = [C4Image imageNamed:@"lines"];
    divider.width = 2;
    [s setDividerImage:divider forLeftSegmentState:NORMAL rightSegmentState:NORMAL];
    
    [self.canvas addObjects:@[s,t]];
}

-(void)touchesBegan {
    t.style = s.style;
}

@end
