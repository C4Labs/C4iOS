//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

C4Sample *sample;

@implementation C4WorkSpace

-(void)setup {    
    sample = [C4Sample sampleNamed:@"C4Loop.aif"];
    [sample prepareToPlay];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [sample play];
}

/*
 add basic controls here...
 i.e self.backgroundColor
 
 block basic things like...
 self.origin
 */

@end