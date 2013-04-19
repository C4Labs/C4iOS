//
//  C4WorkSpace.m
//  Pan Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *circle;
}

-(void)setup {
    circle = [C4Shape ellipse:CGRectMake(0, 0, 386, 386)];
    circle.userInteractionEnabled = NO;
    circle.center = self.canvas.center;
    [self.canvas addShape:circle];
    [self addGesture:PAN name:@"pan" action:@"modifyLineWidth:"];
}

-(void)modifyLineWidth:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self.canvas];
    [recognizer setTranslation:CGPointZero inView:self.canvas];
    
    CGFloat lineWidth = [C4Math absf:translation.x] + [C4Math absf:translation.y];
    circle.lineWidth = [C4Math constrainf:lineWidth min:5 max:150];
}
@end