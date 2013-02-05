//
//  C4WorkSpace.m
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Slider *s1, *s2;
}

-(void)setup {
    s1 = [C4Slider slider:CGRectMake(0, 0, 400, 44)];
    s1.center = self.canvas.center;
    s1.maxTrackImage = [C4Image imageNamed:@"lines"];
    s1.shadowOpacity = 0.8f;
    s1.shadowOffset = CGSizeMake(5,5);
    [self.canvas addSubview:s1];
}

-(void)touchesBegan {
    s2 = [s1 copy];
    s2.origin = CGPointMake(100,100);
    s2.thumbTintColor = C4RED;
    [self.canvas addSubview:s2];
}

@end