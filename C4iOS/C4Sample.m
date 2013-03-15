//
//  C4Sample.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Sample.h"

@interface C4Sample ()
@end

@implementation C4Sample
@synthesize player = _player;

+(C4Sample *)sampleNamed:(NSString *)sampleName {
    return [[C4Sample alloc] initWithSampleName:sampleName];
}

-(id)initWithSampleName:(NSString *)sampleName {
    self = [super init];
    if(self != nil) {
        sampleName = [sampleName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSArray *filenameComponents = [sampleName componentsSeparatedByString:@"."];
        
        NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:filenameComponents[0]
                                                      withExtension:filenameComponents[1]];
                                    
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.enableRate = YES;
        self.player.delegate = self;
        [self setup];
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

-(void)setPan:(CGFloat)pan {
    self.player.pan = pan;
}

-(CGFloat)volume {
    return self.player.volume;
}

-(void)setVolume:(CGFloat)volume {
    self.player.volume = volume;
}

-(CGFloat)rate {
    return self.player.rate;
}
/* isn't working */
-(void)setRate:(CGFloat)rate {
    if(rate >= 0.5f) self.player.rate = rate;
}

-(BOOL)enableRate {
    return self.player.enableRate;
}

-(void)setEnableRate:(BOOL)enableRate {
    self.player.enableRate = enableRate;
}

-(CGFloat)currentTime {
    return (CGFloat)self.player.currentTime;
}

-(void)setCurrentTime:(CGFloat)currentTime {
    self.player.currentTime = (NSTimeInterval)currentTime;
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

-(void)setNumberOfLoops:(NSInteger)numberOfLoops {
    self.player.numberOfLoops = numberOfLoops;
}

-(AVAudioPlayer *)player {
    return _player;
}

-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    player = player; flag = flag;
    [self postNotification:@"endedNormally"];
    [self endedNormally];
}

-(void)setMeteringEnabled:(BOOL)meteringEnabled {
    self.player.meteringEnabled = meteringEnabled;
}

-(BOOL)isMeteringEnabled {
    return self.player.isMeteringEnabled;
}

-(NSUInteger)numberOfChannels {
    return self.player.numberOfChannels;
}

-(CGFloat)peakPowerForChannel:(NSUInteger)channelNumber {
    return [self.player peakPowerForChannel:channelNumber];
}

-(CGFloat)averagePowerForChannel:(NSUInteger)channelNumber {
    return [self.player averagePowerForChannel:channelNumber];
}

-(void)updateMeters {
    [self.player updateMeters];
}

-(NSDictionary *)settings {
    return self.player.settings;
}

@end