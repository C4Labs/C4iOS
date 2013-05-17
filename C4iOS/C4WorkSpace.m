//
//  C4WorkSpace.m
//  Examples
//
//  Created by Travis Kirton on 12-07-23.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    CGPoint trianglePoints[3];
    C4Shape *triangle;
}

-(void)setup {
    trianglePoints[0] = CGPointMake(286, 412);
    trianglePoints[1] = CGPointMake(486, 412);
    trianglePoints[2] = CGPointMake(386, 612);
    
    triangle = [C4Shape triangle:trianglePoints];
    [self.canvas addShape:triangle];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    event = event;
    CGPoint p = [[touches anyObject] locationInView:self.canvas];
    trianglePoints[2] = p;
    
    [triangle triangle:trianglePoints];
}

@end