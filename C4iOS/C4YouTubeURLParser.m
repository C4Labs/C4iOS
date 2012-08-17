//
//  C4YoutubeParser.m
//  C4iOS
//
//  Created by moi on 12-08-16.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//
//  Built off of Simon Andersson's HCYoutubeParser

#import "C4YouTubeURLParser.h"
#define youtubeVideoIDUrlHeader @"http://www.youtube.com/get_video_info?video_id="

@interface C4YouTubeURLParser ()
-(NSString *)stringByDecodingYoutubeURLFormat:(NSString *)originalYoutubeURLString;
-(NSMutableDictionary *)dictionaryFromQueryStringComponents:(NSString *)decodedYoutubeURLString;
-(NSMutableDictionary *)dictionaryForQueryURL:(NSURL *)queryURL;
@property (readwrite, atomic) NSMutableDictionary *videoDictionary;
@end

@implementation C4YouTubeURLParser
@synthesize small, medium, large720, large1080;

+(C4YouTubeURLParser *)parserWithURL:(NSURL *)url {
    C4YouTubeURLParser *newParser = [[C4YouTubeURLParser alloc] initWithYoutubeURL:url];
    return newParser;
}

-(NSString *)stringByDecodingYoutubeURLFormat:(NSString *)originalYoutubeURLString {
    NSString *result = [originalYoutubeURLString stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}

-(NSMutableDictionary *)dictionaryFromQueryStringComponents:(NSString *)decodedYoutubeURLString {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    for (NSString *keyValue in [decodedYoutubeURLString componentsSeparatedByString:@"&"]) {
        NSArray *keyValueArray = [keyValue componentsSeparatedByString:@"="];
        if ([keyValueArray count] < 2) {
            continue;
        }
        
        NSString *key = [keyValueArray objectAtIndex:0];
        key = [self stringByDecodingYoutubeURLFormat:key];
        NSString *value = [keyValueArray objectAtIndex:1];
        value = [self stringByDecodingYoutubeURLFormat:value];
        
        NSMutableArray *results = [parameters objectForKey:key];
        
        if(!results) {
            results = [NSMutableArray arrayWithCapacity:1];
            [parameters setObject:results forKey:key];
        }
        
        [results addObject:value];
    }
    
    return parameters;
}

-(NSMutableDictionary *)dictionaryForQueryURL:(NSURL *)queryURL {
    NSString *queryString = [queryURL query];
    NSMutableDictionary *dictionary = [self dictionaryFromQueryStringComponents:queryString];
    return dictionary;
}

-(id)initWithYoutubeURL:(NSURL *)youtubeURL {
    self = [super init];
    if(self != nil) {
        NSMutableDictionary *dictionary = [self dictionaryForQueryURL:youtubeURL];
        NSString *youtubeID = [[dictionary objectForKey:@"v"] objectAtIndex:0];
        
        if (youtubeID) {
            NSURL *fullYoutubeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", youtubeVideoIDUrlHeader, youtubeID]];
            
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fullYoutubeURL];
            [request setHTTPMethod:@"GET"];
            
            NSURLResponse *response = nil;
            NSError *error = nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            if (!error) {
                NSString *responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                NSMutableDictionary *parts = [self dictionaryFromQueryStringComponents:responseString];
                
                if (parts) {
                    
                    NSString *fmtStreamMapString = [[parts objectForKey:@"url_encoded_fmt_stream_map"] objectAtIndex:0];
                    NSArray *fmtStreamMapArray = [fmtStreamMapString componentsSeparatedByString:@","];
                    
                    if(self.videoDictionary != nil) {
                        [self.videoDictionary removeAllObjects];
                        self.videoDictionary = nil;
                    }
                    self.videoDictionary = [NSMutableDictionary dictionary];
                    
                    for (NSString *videoEncodedString in fmtStreamMapArray) {
                        NSMutableDictionary *videoComponents = [self dictionaryFromQueryStringComponents:videoEncodedString];
                        NSString *videoComponentsType = [[videoComponents objectForKey:@"type"] objectAtIndex:0];
                        NSString *type = [self stringByDecodingYoutubeURLFormat:videoComponentsType];
                        if ([type rangeOfString:@"mp4"].length > 0) {
                            NSString *url = [[videoComponents objectForKey:@"url"] objectAtIndex:0];
                            url = [self stringByDecodingYoutubeURLFormat:url];
                            
                            NSString *quality = [[videoComponents objectForKey:@"quality"] objectAtIndex:0];
                            quality = [self stringByDecodingYoutubeURLFormat:quality];
                            
                            [self.videoDictionary setObject:[NSURL URLWithString:url] forKey:quality];
                        }
                    }
                    C4Assert([[self.videoDictionary allKeys] count] > 0, @"The YouTube video you tried to requeset could not be found in any size format");
                }
            }
        }
    }
    return self;
}

-(NSURL *)small {
    return (NSURL *)[self.videoDictionary valueForKey:@"small"];
}

-(NSURL *)medium {
    return (NSURL *)[self.videoDictionary valueForKey:@"medium"];
}

-(NSURL *)large720 {
    return (NSURL *)[self.videoDictionary valueForKey:@"720p"];
}

-(NSURL *)large1080 {
    return (NSURL *)[self.videoDictionary valueForKey:@"1080p"];
}

@end
