//
//  C4WorkSpace.m
//  Examples
//
//  Created by Greg Debicki.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {
        CGPoint touchPoint = [t locationInView:self.canvas];
        [self createObjectAtPoint:touchPoint];
    }
}

-(void)createObjectAtPoint:(CGPoint)newPoint {
    C4Shape *s = [C4Shape ellipse:CGRectMake(newPoint.x-50,newPoint.y-50,100,100)];
    s.userInteractionEnabled = NO;
    [self.canvas addShape:s];
    [self runMethod:@"fadeAndRemoveShape:" withObject:s afterDelay:0.0f];
}

-(void)fadeAndRemoveShape:(C4Shape *)shape {
    shape.animationDuration = 1.0f;
    shape.alpha = 0.0f;
    [shape runMethod:@"removeFromSuperview" afterDelay:shape.animationDuration];
}

@end


