//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Image *i;
    C4Shape *s;
    C4Movie *m;
}

-(void)setup {
    m = [C4Movie movieNamed:@"inception.mov"];
    m.center = self.canvas.center;
    m.rotation = QUARTER_PI;
    m.backgroundColor = C4RED;
    [self.canvas addMovie:m];

    i = [C4Image imageNamed:@"C4Table"];
    i.center = self.canvas.center;
    i.rotation = QUARTER_PI;
    i.backgroundColor = C4RED;
    [self.canvas addImage:i];

    s = [C4Shape ellipse:CGRectMake(0, 0, 100, 100)];
    [s addShape:[C4Shape ellipse:CGRectMake(0, 0, 10, 10)]];
    s.center = self.canvas.center;
    s.rotation = QUARTER_PI;
    s.backgroundColor = C4RED;
    [self.canvas addShape:s];
    
    [self runMethod:@"startRotation" afterDelay:1.0f];
}

-(void)startRotation {
    i.animationDuration = 2.0f;
    i.animationOptions = LINEAR;
    i.rotation += PI;

    s.animationDuration = 2.0f;
    s.animationOptions = LINEAR;
    s.rotation += PI;
   
    m.animationDuration = 2.0f;
    m.animationOptions = LINEAR;
    m.rotation += PI;
}

-(void)touchesBegan {
    [self startRotation];
}

@end