//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Slider *s;
}

-(void)setup {
    s = [C4Slider slider:CGRectMake(0,0,400,44)];
    s.thumbImage = [C4Image imageNamed:@"pyramid"];
    [s runMethod:@"test:" target:self forEvent:VALUECHANGED];
    [self.canvas addSubview:s];
}

-(void)test:(C4Slider *)sender {
    C4Log(@"%4.2f",sender.value);
}

-(void)touchesBegan {
    C4Slider *s2 = [s copy];
    s2.center = self.canvas.center;
    [self.canvas addSubview:s2];
    [s runMethod:@"test:" target:self forEvent:VALUECHANGED];
}

@end