//
//  C4WorkSpace.m
//  Page Flip
//
//  Created by Les's Computer on 13-05-15.
//  Copyright (c) 2013 Les's Computer. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Movie *movie;
    C4Slider *slider;
    C4Timer *updateTimer;
}

-(void)setup {
    movie = [C4Movie movieNamed:@"inception.mov"];
    movie.shouldAutoplay = YES;
    movie.center = self.canvas.center;

    slider = [C4Slider slider:CGRectMake(0,0, movie.width, 20)];
    slider.origin = CGPointMake(0,movie.height-slider.height);
    
    C4Image *littleGrayImage = [C4Image constantColor:CGSizeMake(8, 8) color:C4GREY];
    [slider setThumbImage:littleGrayImage forState:NORMAL];
    [slider setThumbImage:littleGrayImage forState:HIGHLIGHTED];
    
    [slider setMinimumTrackTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1f]];
    [slider setMaximumTrackTintColor:[[UIColor whiteColor] colorWithAlphaComponent:0.1f]];
    
    [slider runMethod:@"pauseTimer" target:self forEvent:TOUCHDOWN];
    [slider runMethod:@"playTimer" target:self forEvent:TOUCHUPINSIDE | TOUCHUPOUTSIDE];
    [slider runMethod:@"dragSlider" target:self forEvent:TOUCHDOWNDRAGINSIDE | TOUCHDOWNDRAGOUTSIDE];
    
    [movie addSubview:slider];
    [self.canvas addMovie:movie];
    
    updateTimer = [C4Timer automaticTimerWithInterval:0.03f target:self method:@"syncPlayhead" repeats:YES];
}

-(void)syncPlayhead {
    slider.value = movie.currentTime / movie.duration;
}

-(void)pauseTimer {
    [updateTimer stop];
}

-(void)dragSlider {
    [movie seekToTime:slider.value * movie.duration];
}

-(void)playTimer {
    [updateTimer start];
}

@end