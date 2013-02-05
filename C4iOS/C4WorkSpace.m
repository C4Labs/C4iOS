//
//  C4WorkSpace.m
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Slider *slider, *s;
    C4Shape *pathShape;
}

-(void)setup {
    [self createAndAddSinShape];
    
    slider = [[C4Slider alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
    slider.center = self.canvas.center;
    [self.canvas addSubview:slider];
    [slider runMethod:@"adjustPathShape:" target:self forEvent:VALUECHANGED];
}

-(void)touchesBegan {
    if(s == nil) {
        slider.maximumTrackTintColor = C4BLUE;
        s = [[C4Slider alloc]  initWithFrame:slider.frame];
        s.origin = CGPointMake(100,100);
        s.style = slider.style;
        [self.canvas addSubview:s];
    }
}

-(void)createAndAddSinShape {
    NSInteger width = (NSInteger)self.canvas.width;
    NSInteger stepWidth = 8;
    NSInteger steps = width / stepWidth +1;
    CGPoint p[steps];
    
    for(int currentStep = 0; currentStep < steps; currentStep++) {
        CGFloat x = currentStep * stepWidth;
        CGFloat y = [C4Math sin:(x / self.canvas.width)*TWO_PI*2]*100;
        p[currentStep] = CGPointMake(x,y);
    }

    pathShape = [C4Shape polygon:p pointCount:steps];
    pathShape.userInteractionEnabled = NO;
    pathShape.center = self.canvas.center;
    pathShape.fillColor = [UIColor clearColor];
    pathShape.strokeEnd = slider.value;
    pathShape.lineCap = CAPROUND;
    [self.canvas addShape:pathShape];
}

-(void)adjustPathShape:(C4Slider *)sender {
    if(pathShape.strokeEnd != slider.value)
        pathShape.strokeEnd = sender.value;
}

@end