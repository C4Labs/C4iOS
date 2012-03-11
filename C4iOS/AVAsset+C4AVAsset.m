//
//  AVAsset+C4AVAsset.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-10.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "AVAsset+C4AVAsset.h"

@implementation AVAsset (C4AVAsset)
+(AVAsset *)assetWithName:(NSString *)name {
    NSArray *nameComponents = [name componentsSeparatedByString:@"."];
    NSURL *assetURL = [[NSBundle mainBundle] URLForResource:[nameComponents objectAtIndex:0] 
                                              withExtension:[nameComponents objectAtIndex:1]];
    return [AVAsset assetWithURL:assetURL];
}
@end
