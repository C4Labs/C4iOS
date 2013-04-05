//
//  C4WorkSpace.m
//  Examples
//
//  Created by Greg Debicki.
//

@implementation C4WorkSpace {
    C4Shape *s;
}

-(void)setup {
    s = [C4Shape ellipse:CGRectMake(0, 0, 200, 200)];
    s.center = self.canvas.center;
    [self.canvas addShape:s];
}

-(void)touchesBegan {
    [self runMethod:@"changeFillColor:" withObject:s afterDelay:1.0f];
}

-(void)changeFillColor:(C4Shape *)shape {
    shape.fillColor = [UIColor colorWithRed:[C4Math randomInt:100]/100.0f
                                      green:[C4Math randomInt:100]/100.0f
                                       blue:[C4Math randomInt:100]/100.0f
                                      alpha:1.0f];
}

@end