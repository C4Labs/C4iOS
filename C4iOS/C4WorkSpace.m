//
//  C4WorkSpace.m
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Slider *s;
    UISlider *u;
}

-(void)setup {
    s = [[C4Slider alloc] initWithFrame:CGRectMake(100, 100, 400, 44)];
    s.thumbImage = [C4Image imageNamed:@"pyramid"];
    s.minimumTrackTintColor = C4RED;
    [self.canvas addSubview:s];
    [s runMethod:@"action:" target:self forEvent:VALUECHANGED];
}

-(void)touchesBegan {
    s.animationDuration = 1.0f;
}

-(void)action:(id)sender {
    C4Log(@"%@",sender);
}

@end