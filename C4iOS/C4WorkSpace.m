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
    
    [C4Switch defaultStyle].onTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightBluePattern"]];
    [C4Switch defaultStyle].tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightRedPattern"]];
    [C4Switch defaultStyle].thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];
    
    [[C4Switch defaultStyle] setOffImage:[C4Image imageNamed:@"switchOff"]];
    [[C4Switch defaultStyle] setOnImage:[C4Image imageNamed:@"switchOn"]];
    
    [C4Slider defaultStyle].thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkBluePattern"]];
    [C4Slider defaultStyle].minimumTrackTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightRedPattern"]];
    [C4Slider defaultStyle].maximumTrackTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];

    [C4Stepper defaultStyle].tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];
    [[C4Stepper defaultStyle] setDecrementImage:[C4Image imageNamed:@"decrementDisabled"] forState:DISABLED];
    [[C4Stepper defaultStyle] setDecrementImage:[C4Image imageNamed:@"decrementNormal"] forState:NORMAL];
    [[C4Stepper defaultStyle] setIncrementImage:[C4Image imageNamed:@"incrementDisabled"] forState:DISABLED];
    [[C4Stepper defaultStyle] setIncrementImage:[C4Image imageNamed:@"increment"] forState:NORMAL];
    
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
    
    
//    [slider setThumbImage:[C4Image imageNamed:@"sliderThumbDisabled"] forState:DISABLED];
//    [slider setThumbImage:[C4Image imageNamed:@"sliderThumbHighlighted"] forState:NORMAL];
//    [slider setThumbImage:[C4Image imageNamed:@"sliderThumbSelected"] forState:HIGHLIGHTED];
//    [slider setMinimumTrackImage:[C4Image imageNamed:@"sliderTrackDisabled"] forState:NORMAL];
//    [slider setMaximumTrackImage:[C4Image imageNamed:@"sliderTrackNormal"] forState:NORMAL];
}

@end
