//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *s;
    C4Image *i;
}

-(void)setup {
    s = [C4Shape rect:CGRectMake(0, 0, 100, 100)];
    s.userInteractionEnabled = YES;
    
    i = [C4Image imageNamed:@"C4Sky"];
    i.userInteractionEnabled = YES;
    [self.canvas addImage:i];
    [self.canvas addShape:s];
}

-(void)touchBegan {
    i.userInteractionEnabled = YES;
    s.userInteractionEnabled = YES;
}

@end
