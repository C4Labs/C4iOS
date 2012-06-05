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
    [self addGesture:SWIPEUP name:@"swipeUpGesture" action:@"swipedUp"];
}

-(void)swipedUp {
    C4Log(@"hello gesture");
}

@end
