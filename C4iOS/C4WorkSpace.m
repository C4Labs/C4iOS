//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

//NSMutableArray *shapesArray;
C4Movie *inception;
C4Label *pauseButton, *playButton;
C4Font *helvetica40;
C4GL *gl;
C4View *view;
BOOL flag, initiated;

@implementation C4WorkSpace

-(void)setup {
    helvetica40 = [C4Font fontWithName:@"helvetica" size:40];

    pauseButton = [C4Label labelWithText:@"PAUSE" andFont:helvetica40];
    pauseButton.textColor = C4RED;
    [self addLabel:pauseButton];
//    inception = [C4Movie movieNamed:@"inception.m4v"];
//    inception.center = CGPointMake(384, 512);
//    inception.shadowOffset = CGSizeMake(15, 15);
//    inception.shadowOpacity = 0.6f;
//    inception.shadowRadius = 10.0f;
//    [self addMovie:inception];
//    
//    helvetica40 = [C4Font fontWithName:@"helvetica" size:40];
//    
//    playButton = [C4Label new];
//    playButton.font = helvetica40;
//    playButton.text = @"PLAY";
//    [playButton sizeToFit];
//    playButton.origin = CGPointMake(0, 400);
//    
//    [self.view addSubview:playButton];
//
//    pauseButton = [C4Label new];
//    pauseButton.font = helvetica40;
//    pauseButton.text = @"PAUSE";
//    
//    pauseButton.backgroundColor = C4BLUE;
////    pauseButton.transform = CGAffineTransformMakeRotation(HALF_PI);
//    
//    [pauseButton sizeToFit];
//    pauseButton.origin = CGPointMake(0, 600);
//    [self addLabel:pauseButton];
//    
//    [inception listenFor:@"touchesBegan" fromObject:pauseButton andRunMethod:@"pause"];
//    [inception listenFor:@"touchesBegan" fromObject:playButton andRunMethod:@"play"];
//    view = [[C4View alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    view.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:view];
//    flag = NO;
//    
    /* maybe add listening to the workspace? */

}


@end