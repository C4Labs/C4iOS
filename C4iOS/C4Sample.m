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
@synthesize currentTime;
@synthesize pan;
@synthesize rate;
@synthesize volume;
@synthesize playing;
@synthesize duration;
@synthesize enableRate;
@synthesize numberOfLoops;
@synthesize deviceCurrentTime;
@synthesize loops = _loops;
@synthesize meteringEnabled = _meteringEnabled;

+(C4Sample *)sampleNamed:(NSString *)sampleName {
    return [[C4Sample alloc] initWithSampleName:sampleName];
}

-(id)initWithSampleName:(NSString *)sampleName {
    self = [super init];
    if(self != nil) {
        NSArray *filenameComponents = [sampleName componentsSeparatedByString:@"."];
        
        NSURL *soundFileURL = [[NSBundle mainBundle] URLForResource:[filenameComponents objectAtIndex:0]
                                                      withExtension:[filenameComponents objectAtIndex:1]];
                                    
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.player.delegate = self;
        [self setup];
    }
    return self;
}

-(void)dealloc {
    [_player stop];
    _player = nil;
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
/* isn't working */
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
}

-(void)setMeteringEnabled:(BOOL)meteringEnabled {
    self.player.meteringEnabled = meteringEnabled;
}

-(BOOL)isMeteringEnabled {
    return self.player.isMeteringEnabled;
}

@end