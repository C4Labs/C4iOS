//
//  C4WorkSpace.m
//  Pan Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Image *robotsImage;
    C4Movie *robotsMovie;
}

-(void)setup {
    NSURL *robotsImageUrl = [NSURL URLWithString:@"http://www.c4ios.com/tutorials/gettingMedia/robots.png"];
    NSData *robotsData = [NSData dataWithContentsOfURL:robotsImageUrl];
    robotsImage = [C4Image imageWithData:robotsData];
    robotsImage.width = self.canvas.width;
    robotsImage.center = self.canvas.center;
    robotsImage.zPosition = -100.0f;
    [self.canvas addImage:robotsImage];
    self.canvas.backgroundColor = [UIColor blackColor];
    
    robotsMovie = [C4Movie movieWithURL:@"https://vimeo.com/64228645/download?t=1366415178&v=158652843&s=01e327470a59c8c98666da0905b8440a"];
    robotsMovie.zPosition = 100.0f;
    robotsMovie.perspectiveDistance = 1000.0f;
    robotsMovie.alpha = 0.0f;
    robotsMovie.center = CGPointMake(self.canvas.center.x,self.canvas.center.y-10);
    robotsMovie.loops = YES;

    [self.canvas addMovie:robotsMovie];
    
    robotsImageUrl = nil;
    robotsData = nil;
}

-(void)touchesBegan {
    [self play];
}

-(void)play {
    if (robotsMovie.isPlaying == NO) {
        robotsMovie.animationDuration = 1.0f;
        robotsMovie.alpha = 1.0f;
        [robotsMovie play];
        
        robotsMovie.animationOptions = REPEAT | LINEAR;
        robotsMovie.animationDuration = robotsMovie.duration;
        robotsMovie.rotationY += TWO_PI;
    }
}

@end