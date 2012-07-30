//
//  C4Workspace.h
//  Examples
//
//  Created by Travis Kirton
//

#import "C4Workspace.h"

@implementation C4WorkSpace {
}

-(void)setup {
//    for(int i = 0; i < 4; i ++ ) {
        C4Movie *m = [C4Movie movieNamed:@"inception.mov"];
        m.center = self.canvas.center;
        CGRect frame = m.bounds;
        frame.size.width /=4;
//        frame.origin.x = i*frame.size.width;
//        C4Shape *s = [C4Shape rect:frame];
//        m.mask = s;
        m.loops = YES;
//        if(i > 0) m.volume = 0.0f;
        [self.canvas addMovie:m];
//    }
    [self runMethod:@"test" afterDelay:0.2f];
}

-(void)test {
    for(C4Movie *m in self.canvas.subviews){
        m.animationDuration = 1.0f;
        m.shadowOpacity = 0.5f;
        m.shadowOffset = CGSizeMake(10,10);
        [m seekToTime:0.0f];
        [m play];
    }
}

-(void)touchesBegan {
    int i = 0;
    for(C4Movie *m in self.canvas.subviews) {
        m.perspectiveDistance = 0.002;
        m.animationDuration = 2.0f;
        m.animationDelay = 0.33*i;
        m.animationOptions = LINEAR | REPEAT;
        m.rotationX = TWO_PI;
        i++;
    }
}

@end