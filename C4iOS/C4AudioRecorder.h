//
//  C4AudioRecorder.h
//  C4iOS
//
//  Created by moi on 13-03-14.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Control.h"

@interface C4AudioRecorder : C4Control

-(id)initWithFilename:(NSString *)fileName;
-(void)prepareToRecord;
-(void)record;
-(void)recordAtTime:(CGFloat)time;
-(void)recordForDuration:(CGFloat)duration;
-(void)recordAtTime:(CGFloat)time forDuration:(CGFloat)duration;
-(void)pause;
-(void)stop;
-(void)deleteRecording;

-(NSUInteger)numberOfChannels;
-(CGFloat)peakPowerForChannel:(NSUInteger)channelNumber;
-(CGFloat)averagePowerForChannel:(NSUInteger)channelNumber;
-(void)updateMeters;

//Initializing an AVAudioRecorder Object
//– initWithURL:settings:error:
//Configuring and Controlling Recording
//– prepareToRecord
//– record
//– recordAtTime:
//– recordForDuration:
//– recordAtTime:forDuration:
//– pause
//– stop
//delegate  property
//– deleteRecording
//Managing Information About a Recording
//recording  property
//url  property
//channelAssignments  property
//currentTime  property
//deviceCurrentTime  property
//settings  property
//Using Audio Level Metering
//meteringEnabled  property
//– updateMeters
//– peakPowerForChannel:
//– averagePowerForChannel:
@end
