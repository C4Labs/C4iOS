//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"
#import "C4VideoPlayerView.h"

C4Image *image, *inverted, *descartes;
C4VideoPlayerView *inceptionView;

@implementation C4CanvasController
@synthesize canvas;


-(void)setup {
    canvas = (C4Window *)self.view;

    inceptionView = [[C4VideoPlayerView alloc] initWithMovieName:@"inception.m4v"];
    inceptionView.width = 768.0f;
    inceptionView.loops = YES;
    [canvas addSubview:inceptionView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [inceptionView seekToTime:205.0f];
    [inceptionView play];
}
@end