//
//  C4AudioPlayer.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-13.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4AudioPlayer.h"

@implementation C4AudioPlayer
@synthesize player, currentTime, pan, rate, volume, playing, duration, enableRate, numberOfLoops, deviceCurrentTime;

-(id)initWithFileNamed:(id)_filename {
    self = [super init];
    if(self != nil) {

        NSString *filename = [C4String nsStringFromObject:_filename];
        NSArray *filenameComponents = [filename componentsSeparatedByString:@"."];
        
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:[filenameComponents objectAtIndex:0] 
                                                                  ofType:[filenameComponents objectAtIndex:1]];
        NSURL *soundFileURL = [NSURL URLWithString:soundFilePath];
                                    
        AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.player = newPlayer;
    }
    return self;
}

-(BOOL)play {
    return [player play];
}

-(void)stop {
    [player stop];
}

-(void)pause {
    [player pause];
}

-(BOOL)prepareToPlay {
    return [player prepareToPlay];
}

-(BOOL)isPlaying {
    return player.isPlaying;
}

-(CGFloat)pan {
    return player.pan;
}

-(void)setPan:(CGFloat)_pan {
    player.pan = _pan;
}

-(CGFloat)volume {
    return player.volume;
}

-(void)setVolume:(CGFloat)_volume {
    player.volume = _volume;
}

-(CGFloat)rate {
    return player.rate;
}

-(void)setRate:(CGFloat)_rate {
    player.rate = _rate;
}

-(BOOL)enableRate {
    return player.enableRate;
}

-(void)setEnableRate:(BOOL)_enableRate {
    player.enableRate = _enableRate;
}

-(NSTimeInterval)currentTime {
    return player.currentTime;
}

-(void)setCurrentTime:(NSTimeInterval)_currentTime {
    player.currentTime = _currentTime;
}

-(NSTimeInterval)duration {
    return player.duration;
}

-(NSTimeInterval)deviceCurrentTime {
    return player.deviceCurrentTime;
}

-(NSInteger)numberOfLoops {
    return player.numberOfLoops;
}

-(void)setNumberOfLoops:(NSInteger)_numberOfLoops {
    player.numberOfLoops = _numberOfLoops;
}

@end