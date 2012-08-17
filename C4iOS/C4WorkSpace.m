//
//  C4Workspace.h
//  Examples
//
//  Created by Travis Kirton
//

#import "C4Workspace.h"
#import "C4YouTubeURLParser.h"

@implementation C4WorkSpace {
    C4Movie *m;
}

//this example uses a default renderer
-(void)setup {
    m = [C4Movie movieWithYouTubeURL:@"http://www.youtube.com/watch?v=R5ipefVnw3g"];
    m.center = self.canvas.center;
    m.shouldAutoplay = YES;
    m.loops = YES;
    m.userInteractionEnabled = NO;
    [self.canvas addMovie:m];
}

//toggle the animation based on touching the canvas
-(void)touchesBegan {
    m.animationDuration = 1.0f;
    m.perspectiveDistance = 200.0f;
    m.rotationX += TWO_PI;
    m.width = 500;
}

@end