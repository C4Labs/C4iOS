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
    i = [C4Image imageNamed:@"C4Sky"];
    [self.canvas addImage:i];
    i.width = 200;
}

-(void)touchesBegan {
    [i colorInvert];
}

@end
