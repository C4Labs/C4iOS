// Copyright © 2012 Travis Kirton
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import "C4Sample.h"

@interface C4Sample ()
@property(nonatomic, strong) AVAudioPlayer *player;
@end


@implementation C4Sample

+ (instancetype)sampleNamed:(NSString *)sampleName {
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