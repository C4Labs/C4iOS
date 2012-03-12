//
//  C4AudioPlayer.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-13.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4Sampler.h"

@interface C4Sampler ()
@property (readonly, strong) AVAudioPlayer *player;
@end

@implementation C4Sampler
@synthesize player = _player, currentTime, pan, rate, volume, playing, duration, enableRate, numberOfLoops, deviceCurrentTime;
@synthesize loops = _loops;

-(id)initWithFileNamed:(NSString *)_filename {
    self = [super init];
    if(self != nil) {

        NSString *filename = _filename;
        NSArray *filenameComponents = [filename componentsSeparatedByString:@"."];
        
        NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:[filenameComponents objectAtIndex:0]
                                                      withExtension:[filenameComponents objectAtIndex:1]];
                                    
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.player.delegate = self;
    }
    return self;
}

-(void)play {
    [self.player play];
}

-(void)stop {
    [self.player stop];
}

-(void)pause {
    [self.player pause];
}

-(void)prepareToPlay {
    [self.player prepareToPlay];
}

-(BOOL)isPlaying {
    return self.player.isPlaying;
}

-(CGFloat)pan {
    return self.player.pan;
}

-(void)setPan:(CGFloat)_pan {
    self.player.pan = _pan;
}

-(CGFloat)volume {
    return self.player.volume;
}

-(void)setVolume:(CGFloat)_volume {
    self.player.volume = _volume;
}

-(CGFloat)rate {
    return self.player.rate;
}

-(void)setRate:(CGFloat)_rate {
    if(_rate >= 0)
        self.player.rate = _rate;
}

-(BOOL)enableRate {
    return self.player.enableRate;
}

-(void)setEnableRate:(BOOL)_enableRate {
    self.player.enableRate = _enableRate;
}

-(CGFloat)currentTime {
    return (CGFloat)self.player.currentTime;
}

-(void)setCurrentTime:(CGFloat)_currentTime {
    self.player.currentTime = (NSTimeInterval)_currentTime;
}

-(CGFloat)duration {
    return (CGFloat)self.player.duration;
}

-(CGFloat)deviceCurrentTime {
    return (CGFloat)self.player.deviceCurrentTime;
}

-(void)setLoops:(BOOL)loops {
    if(loops) self.player.numberOfLoops = -1;
    else self.player.numberOfLoops = 0;
}

-(BOOL)loops {
    return self.player.numberOfLoops != 0 ? YES : NO;
}

-(NSInteger)numberOfLoops {
    return self.player.numberOfLoops;
}

-(void)playAtTime:(CGFloat)time {
   [self.player playAtTime:(NSTimeInterval)time];
}

-(void)endedNormally {
}

-(void)setNumberOfLoops:(NSInteger)_numberOfLoops {
    self.player.numberOfLoops = _numberOfLoops;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self postNotification:@"endedNormally"];
    [self endedNormally];
=======
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
>>>>>>> origin/master
}

@end