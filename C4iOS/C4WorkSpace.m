//
//  C4WorkSpace.m
//  Page Flip
//
//  Created by Les's Computer on 13-05-15.
//  Copyright (c) 2013 Les's Computer. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Image *img;
}

-(void)setup {
    img = [C4Image imageNamed:@"C4Sky"];
    img.center = self.canvas.center;
    img.borderColor = C4RED;
    img.borderWidth = 1.0f;
    [self.canvas addImage:img];
}


-(void)touchesBegan {
    [img droste:CGPointMake(100,100) inset2:CGPointMake(200,200) strandRadius:1 periodicity:1 rotation:0 zoom:1];
}
@end