//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *s;
}

-(void)setup {
    CGPoint linePoints[2] = {CGPointZero,CGPointMake(0, -200)};
	s = [C4Shape line:linePoints];
    s.animationDuration = 0.0f;
    s.anchorPoint = CGPointMake(0.5, 1);
    s.center = self.canvas.center;
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
    CGFloat seconds = [dateComponents second];
    CGFloat currentRotation = seconds / 60.0f * TWO_PI;
    s.rotation = currentRotation;
    
    [self runMethod:@"startRotation" afterDelay:0.4f];
    [self.canvas addShape:s];
}

-(void)startRotation {
    C4Log(@"hi");
    s.animationDuration = 60.0f;
    s.animationOptions = REPEAT | LINEAR;
    s.rotation += TWO_PI;
}

-(void)touchesBegan {
    [self startRotation];
}
@end
