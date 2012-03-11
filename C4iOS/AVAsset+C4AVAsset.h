//
//  AVAsset+C4AVAsset.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-10.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
/** This document describes a category for AVAsset that makes available a method which allows for creating assets with media in the application's main bundle by specifying only their filename.
 */
@interface AVAsset (C4AVAsset)
/// @name Initialization
/** Creates and returns an AVAsset whose media is specified by its file name.
 
 @param name The name of a media file including its extension.
 */
+(AVAsset *)assetWithName:(NSString *)name;
@end
