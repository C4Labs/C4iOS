//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface C4WorkSpace ()
    //declare custom methods and properties here
@end

@implementation C4WorkSpace {
    C4Shape *curve;
}

-(void)setup {
    [self.canvas addShape:curve];
} 

@end
