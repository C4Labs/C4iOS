//
//  C4WorkSpace.m
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Slider *s1, *s2;
    C4Shape *s;
}

-(void)setup {
    s1 = [C4Slider slider:CGRectMake(0, 0, 400, 44)];
    s1.center = self.canvas.center;
    s1.maxTrackImage = [C4Image imageNamed:@"lines"];
    [self.canvas addSubview:s1];
    
    s = [C4Shape rect:CGRectMake(10, 10, 20, 20)];
    [self.canvas addShape:s];
}

-(void)touchesBegan {
    if(s2 == nil) {
        s2 = [s1 copy];
        s2.origin = CGPointMake(100,100);
        s2.thumbTintColor = C4RED;
        [self.canvas addSubview:s2];
    }
}

@end