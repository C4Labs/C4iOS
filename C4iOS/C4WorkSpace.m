//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Image *image;
}

-(void)setup {
    image = [C4Image imageNamed:@"C4Table"];
    [self.canvas addImage:image];
}

-(void)touchesBegan {
    image.animationDuration = 0.5f;
    [image gaussianBlur:10.0f];
}

@end
