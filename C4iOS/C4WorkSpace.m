//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
#import "NewImage.h"

@implementation C4WorkSpace {
    NewImage *n, *o;
}

-(void)setup {
    n = [NewImage imageNamed:@"C4Sky"];
    [self.canvas addSubview:n];
}

-(void)touchesBegan {
    n.animationDuration = 1.0f;
    [n startFiltering];
    [n colorMonochrome:C4RED inputIntensity:1.0f];
    [n colorInvert];
    [n renderFilteredImage];
}

@end
