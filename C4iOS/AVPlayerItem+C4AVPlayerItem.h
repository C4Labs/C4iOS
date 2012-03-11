//
//  AVPlayerItem+C4AVPlayerItem.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-10.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/** This document describes a category for AVPlayerItem that makes available a method which allows for creating playerItems with media in the application's main bundle by specifying only their filename.
 */

@interface AVPlayerItem (C4AVPlayerItem)
/// @name Initialization
/** Creates and returns an AVPlayerItem whose media is specified by its file name.
 
 @param name The name of a media file including its extension.
 */
+(AVPlayerItem *)playerItemWithName:(NSString *)name;
-(id)initWithName:(NSString *)name;
@end
