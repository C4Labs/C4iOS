//
//  C4YoutubeParser.h
//  C4iOS
//
//  Created by moi on 12-08-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"
#define youtube

@interface C4YouTubeURLParser : C4Object

+(C4YouTubeURLParser *)parserWithURL:(NSURL *)url;
-(id)initWithYoutubeURL:(NSURL *)youtubeURL;

@property (readonly, nonatomic) NSURL *small, *medium, *large720, *large1080;
@end
