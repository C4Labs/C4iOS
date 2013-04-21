//
//  C4WorkSpace.m
//  Getting Media Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Image *robotsImage;
    C4Movie *robotsMovie;
}

-(void)setup {
    self.canvas.backgroundColor = [UIColor blackColor];

    robotsImage = [self createRobotsImage];
    if(robotsImage != nil) [self.canvas addImage:robotsImage];

    robotsMovie = [self createRobotsMovie];
    if(robotsMovie != nil) [self.canvas addMovie:robotsMovie];
}

-(C4Image *)createRobotsImage {
    NSString *robotsImageUrl = @"http://www.c4ios.com/tutorials/gettingMedia/robots.png";
    C4Image *imageFromURL = [C4Image imageWithURL:robotsImageUrl];
    imageFromURL.width = self.canvas.width;
    imageFromURL.center = self.canvas.center;

    return imageFromURL;
}

-(C4Movie *)createRobotsMovie {
    NSString *vimeoURL = @"https://vimeo.com/64228645/download?t=1366415178&v=158652843&s=01e327470a59c8c98666da0905b8440a";
//    NSString *anotherURL = @"http://c4ios.com/tutorials/gettingMedia/robots.mp4";

    C4Movie *movieFromURL = [C4Movie movieWithURL:vimeoURL];
    movieFromURL.zPosition = 200;
    movieFromURL.perspectiveDistance = 1000.0f;
    movieFromURL.alpha = 0.0f;
    movieFromURL.center = CGPointMake(self.canvas.center.x,self.canvas.center.y-10);
    movieFromURL.loops = YES;
    movieFromURL.shouldAutoplay = YES;
    [self runMethod:@"animate" afterDelay:0.5f];

    return movieFromURL;
}

-(void)animate {
    robotsMovie.animationDuration = 1.0f;
    robotsMovie.alpha = 1.0f;
    
    robotsMovie.animationOptions = REPEAT | LINEAR;
    robotsMovie.animationDuration = robotsMovie.duration;
    robotsMovie.rotationY += TWO_PI;
}

@end