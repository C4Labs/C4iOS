//
// C4WorkSpace.m
//
// Created by Travis Kirton and Greg Debicki.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Slider *s1, *s2;
}

-(void)setup {
    s1 = [C4Slider slider:CGRectMake(44, 44,368,44)];
    [self.canvas addSubview:s1];
}

-(void)touchesBegan {
    if(s2 == nil) {
        s1.maximumTrackTintColor = C4BLUE;
        s1.shadowOpacity = 0.8f;
        s1.shadowOffset = CGSizeMake(2, 2);
        s2 = [C4Slider slider:CGRectMake(10,100,368,44)];
        s2.style = s1.style;
        [self.canvas addSubview:s2];
    }
}

@end