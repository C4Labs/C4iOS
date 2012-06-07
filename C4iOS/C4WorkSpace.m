//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace

-(void)setup {
    C4Movie *m = [C4Movie movieNamed:@"inception.mov"];
    m.shouldAutoplay = YES;
    [self.canvas addMovie:m];
}

@end
