//
//  C4WorkSpace.m
//  Examples
//
//  Created by Greg Debicki.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *s1, *s2;
    int state;
}

-(void)setup {
    s1 = [C4Shape rect:CGRectMake(100, 100, 100, 100)];
    [self.canvas addShape:s1];
}

-(void)touchesBegan {
    switch (state) {
        case 0:
            s2 = [s1 copy];
            break;
        case 1:
            s1.center = self.canvas.center;
            break;
        case 2:
            [self.canvas addShape:s2];
            break;
    }
    state++;
}

@endl