//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
#import "NewSlider.h"

@implementation C4WorkSpace {
    NewSlider *s;
}

-(void)setup {
    s = [NewSlider slider:CGRectMake(0,0,400,44)];
    s.thumbImageHighlighted = [C4Image imageNamed:@"pyramid"];
    [self.canvas addSubview:s];
}

-(void)test:(NewSlider *)sender {
    C4Log(@"%4.2f",sender.value);
}

-(void)touchesBegan {
    NewSlider *s2 = [s copy];
    s2.center = self.canvas.center;
    [self.canvas addSubview:s2];
    [s runMethod:@"test:" target:self forEvent:VALUECHANGED];
}

@end