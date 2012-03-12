//
//  C4Sampler.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-13.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4Object.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface C4Sampler : C4Object <AVAudioPlayerDelegate>

-(id)initWithFileNamed:(NSString *)filename;

-(void)play;
-(void)pause;
-(void)stop;
-(void)prepareToPlay;
-(void)endedNormally;
-(void)playAtTime:(CGFloat)time;

@property (readonly, nonatomic, getter=isPlaying) BOOL playing;
@property (readonly, nonatomic) CGFloat duration;
@property (readwrite, nonatomic) CGFloat pan;
@property (readwrite, nonatomic) CGFloat volume;
@property (readwrite, nonatomic) CGFloat rate;
@property (readwrite, nonatomic) BOOL enableRate; 
@property (readwrite, nonatomic) CGFloat currentTime;
@property (readonly, nonatomic) CGFloat deviceCurrentTime;
@property (readwrite, nonatomic) BOOL loops;
@property (readwrite, nonatomic) NSInteger numberOfLoops;
@end