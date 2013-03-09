//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *s1, *s2;
}

-(void)setup {
    s1 = [C4Shape rect:CGRectMake(0, 0, 192, 96)];
    [s1 addGesture:SWIPELEFT name:@"leftSwipeGesture" action:@"swipedLeft"];

    s2 = [C4Shape rect:CGRectMake(0, 0, 192, 96)];
    [s2 addGesture:SWIPELEFT name:@"left" action:@"swipedLeft"];
    
    s1.center = CGPointMake(self.canvas.center.x, self.canvas.center.y - s1.height * 1.25);
    s2.center = CGPointMake(self.canvas.center.x, self.canvas.center.y + s2.height * 0.25);
    
    NSArray *shapes = @[s1,s2];
    [self.canvas addObjects:shapes];
    
    [self listenFor:@"swipedLeft" fromObjects:shapes andRunMethod:@"randomColor:"];
}

-(void)randomColor:(NSNotification *)notification {
    C4Shape *shape = (C4Shape *)notification.object;
    shape.fillColor = [UIColor colorWithRed:[C4Math randomInt:100]/100.0f
                                      green:[C4Math randomInt:100]/100.0f
                                       blue:[C4Math randomInt:100]/100.0f
                                      alpha:1.0f];
}
@end
