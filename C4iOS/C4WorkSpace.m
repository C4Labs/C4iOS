//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Stepper *stepper, *stepper2;
}

-(void)setup {
    stepper = [C4Stepper stepper];
    stepper.center = self.canvas.center;
    stepper.shadowOffset = CGSizeMake(2,2);
    stepper.shadowOpacity = 0.8f;
    [self.canvas addSubview:stepper];

    UIStepper *s = [[UIStepper alloc] init];
    [s setBackgroundImage:[UIImage imageNamed:@"test"] forState:UIControlStateNormal];
    [self.canvas addSubview:s];
    C4Image *img = [C4Image imageWithUIImage:[s backgroundImageForState:UIControlStateNormal]];
    img.origin = CGPointMake(0,30);
    [self.canvas addImage: img];
}

@end
