//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *s;
}

-(void)setup {
    s = [C4Shape rect:CGRectMake(100, 100, 100, 100)];
    s = [C4Shape rect:CGRectMake(100, 100, 200, 200)];
    [self.canvas addShape:s];
}

-(void)touchesBegan {
}
@end
