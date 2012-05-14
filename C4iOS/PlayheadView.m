//
//  MyShape.m
//  C4iOS
//
//  Created by Travis Kirton on 12-05-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "PlayheadView.h"

@interface PlayheadView ()
@property (readwrite, strong) C4Shape *playhead;
@property (readwrite) CGFloat pointsPerSecond;
@property (readwrite, strong) NSTimer *playheadTimer;
@end

@implementation PlayheadView {
    C4Movie *m;
}

@synthesize loops, playhead, playheadTimer, pointsPerSecond, sample = _sample;

-(id)initWithSample:(C4Sample *)newSample frame:(CGRect)rect {
    self = [super init];
    if(self != nil) {
        CGRect newFrame = rect;
        
        self.animationDuration = 0.0f;
        self.lineWidth = 0.0f;
        [self rect:newFrame];
        
        CGPoint pointArray[2] = {CGPointZero,CGPointMake(0, newFrame.size.height)};
        playhead = [C4Shape line:pointArray];
        
        playhead.animationDuration = 0.0f;
        playhead.strokeColor = C4GREY;
        [self addSubview:playhead];
        
        self.sample = newSample;
        [self.sample prepareToPlay];
        self.pointsPerSecond = newFrame.size.width / self.sample.duration;
        
        m = [C4Movie movieNamed:@"inception.mov"];
        
        [self addGesture:TAP name:@"tapG" action:@"play"];
    }
    return self;
}

-(id)initWithSample:(C4Sample *)newSample {
    self = [self initWithSample:newSample frame:CGRectMake(0, 0, 568, 100)];
    return self;
}

-(void)setSample:(C4Sample *)sample {
    _sample = sample;
    if (sample != nil) {
        [self listenFor:@"endedNormally" fromObject:self.sample andRunMethod:@"stop"];
    }
}

-(void)play {
    if([self.playheadTimer isValid]) {
        [self.playheadTimer invalidate];
    }
    
    self.playheadTimer = [NSTimer scheduledTimerWithTimeInterval:1.0f/30.0f 
                                                          target:self 
                                                        selector:@selector(updatePlayheadPosition) 
                                                        userInfo:nil 
                                                         repeats:TRUE];
    [[NSRunLoop mainRunLoop] addTimer:self.playheadTimer forMode:NSDefaultRunLoopMode];
    [self.sample play];
}

-(void)setLoops:(BOOL)_loops {
    switch (self.sample.isPlaying) {
        case YES:
            [self.sample pause];
            self.sample.loops = _loops;
            [self.sample play];
            break;
        default:
            self.sample.loops = _loops;
            break;
    }
}

-(BOOL)loops {
    return self.sample.loops;
}

-(BOOL)isPlaying {
    return self.sample.isPlaying;
}

-(void)pause {
    [self.playheadTimer invalidate];
    [self.sample pause];
}

-(void)stop {
    [self.playheadTimer invalidate];
    self.playhead.origin = CGPointZero;
    [self.sample stop];
    self.sample.currentTime = 0.0f;
}

-(void)updatePlayheadPosition {
    CGPoint newPosition = self.playhead.origin;
    newPosition.x = self.sample.currentTime * self.pointsPerSecond;
    self.playhead.origin = newPosition;
}

-(void)touchesBegan {
//    [self play];
}
@end
