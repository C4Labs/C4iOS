//
//  AVPlayerItem+C4AVPlayerItem.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-10.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "AVPlayerItem+C4AVPlayerItem.h"

@implementation AVPlayerItem (C4AVPlayerItem)
+(AVPlayerItem *)playerItemWithName:(NSString *)name {
    NSArray *nameComponents = [name componentsSeparatedByString:@"."];
    NSURL *mediaItemURL = [[NSBundle mainBundle] URLForResource:[nameComponents objectAtIndex:0] 
                                                  withExtension:[nameComponents objectAtIndex:1]];
    return [AVPlayerItem playerItemWithURL:mediaItemURL];
}

-(id)initWithName:(NSString *)name {
    NSArray *nameComponents = [name componentsSeparatedByString:@"."];
    NSURL *mediaItemURL = [[NSBundle mainBundle] URLForResource:[nameComponents objectAtIndex:0] 
                                                  withExtension:[nameComponents objectAtIndex:1]];
    return [self initWithURL:mediaItemURL];
}

@end