//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"
#import "MyShape.h"

@implementation C4WorkSpace {
    MyShape *m;
}

-(void)setup {
    m = [MyShape new];
    [self.canvas addShape:m];
}

@end