//
//  C4WorkSpace.m
//  Composite Objects Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace

-(void)setup {
    C4Shape *s = [C4Shape rect:CGRectMake(0, 0, 100, 100)];
    s.center = self.canvas.center;
    s.fillColor = [C4GREY colorWithAlphaComponent:0.5f];
    [self.canvas addShape:s];
}

@end