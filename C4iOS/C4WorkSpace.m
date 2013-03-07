//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Button *button;
    C4Slider *slider;
    C4Stepper *stepper;
    C4Switch *swich;
}

-(void)setup {
    
    button = [C4Button buttonWithType:ROUNDEDRECT];
    slider = [C4Slider slider:CGRectMake(0, 0, 368, 44)];
    stepper = [C4Stepper stepper];
    swich = [C4Switch switch];
    
    stepper.maximumValue = 5;
    
    CGPoint currentCenter;
    
    currentCenter = CGPointMake(self.canvas.center.x, 100);
    button.center = currentCenter;
    
    currentCenter.y += 100;
    slider.center = currentCenter;

    currentCenter.y += 100;
    stepper.center = currentCenter;
    
    currentCenter.y += 100;
    swich.center = currentCenter;
    
    [self.canvas addObjects:@[button, slider, stepper, swich]];
}

@end
