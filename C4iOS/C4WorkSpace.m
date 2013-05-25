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
    CGPoint pt = CGPointMake(img.width/4,img.height/2);
    CGFloat rad = 120.0f;
    CGFloat rot = 1 * PI / 4;
    [img triangleKaleidescope:pt size:200.0f rotation:-.36f decay:.55f];
}
@end