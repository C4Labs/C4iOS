//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

C4Sampler *ap;

@implementation C4WorkSpace

-(void)setup {    
    ap = [[C4Sampler alloc] initWithFileNamed:@"C4Loop.aif"];
    [ap prepareToPlay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [ap play];
}

/*
 add basic controls here...
 i.e self.backgroundColor
 
 block basic things like...
 self.origin
 */

@end