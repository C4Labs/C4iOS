//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Image *myImage;
}

-(void)setup {
    myImage = [C4Image imageNamed:@"C4Sky.png"];
    [self.canvas addImage:myImage];
}

@end