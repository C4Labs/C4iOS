//
//  C4WorkSpace.m
//  clock1
//
//  Created by moi on 12-09-01.
//  Copyright (c) 2012 moi. All rights reserved.
//

#import "C4WorkSpace.h"

@interface C4WorkSpace ()
-(void)startAnimation;
-(void)nextNumber;
@end

@implementation C4WorkSpace {
    C4Shape *fillLine;
    C4Label *hour;
    C4Timer *timer;
    NSInteger animationLength;
    NSInteger currentHour;
    NSInteger currentColor;
    UIColor *blue, *lightGrey, *darkGrey;
    
}

-(void)setup {
    blue = [UIColor colorWithRed:38.0f/255.0f green:55.0f/255.0f blue:120.0f/255.0f alpha:1.0f];
    lightGrey = [UIColor colorWithRed:116.0f/255.0f green:125.0f/255.0f blue:153.0f/255.0f alpha:1.0f];
    darkGrey = [UIColor colorWithRed:95.0f/255.0f green:93.0f/255.0f blue:103.0f/255.0f alpha:1.0f];
    
    animationLength = 2;
    
    self.canvas.backgroundColor = blue;
    CGPoint center = CGPointMake(240,320);
    CGPoint p[2] = {center,center};
    p[1].y = 0;
    fillLine = [C4Shape line:p];
    fillLine.lineWidth = 480;
    fillLine.strokeEnd = 0;
    fillLine.strokeColor = [UIColor colorWithRed:35.0f/255.0f green:31.0f/255.0f blue:32.0f/255.0f alpha:0.3];
    [self.canvas addShape:fillLine];
    
    hour = [C4Label labelWithText:@"0" font:[C4Font fontWithName:@"Futura-Medium" size:160]];
    hour.width = 480;
    hour.textAlignment = ALIGNTEXTCENTER;
    hour.center = CGPointMake(240,160);
    hour.textColor= [UIColor whiteColor];
    [self.canvas addLabel:hour];
    timer = [C4Timer automaticTimerWithInterval:animationLength target:self method:@"nextHour" repeats:YES];
    [self startAnimation];
    
    for(int i = 0; i < 3; i++) {
        CGPoint linePoints[2] = {CGPointMake(0, (i+1)*80),CGPointMake(10, (i+1)*80)};
        C4Shape *l = [C4Shape line:linePoints];
        l.strokeColor = [UIColor whiteColor];
        l.lineWidth = 1.0f;
        [self.canvas addShape:l];
    }
    for(int i = 0; i < 3; i++) {
        CGPoint linePoints[2] = {CGPointMake(470, (i+1)*80),CGPointMake(480, (i+1)*80)};
        C4Shape *l = [C4Shape line:linePoints];
        l.strokeColor = [UIColor whiteColor];
        l.lineWidth = 1.0f;
        [self.canvas addShape:l];
    }
}

-(void)startAnimation {
    fillLine.animationDuration = animationLength;
    fillLine.animationOptions = LINEAR;
    fillLine.strokeEnd = 1.0f;
}

-(void)nextHour {
    fillLine.animationDuration = 0.0f;
    fillLine.strokeEnd = 0.0f;
    currentHour++;
    if(currentHour > 23) currentHour = 0;
    hour.text = [NSString stringWithFormat:@"%d",currentHour];
    [self startAnimation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return(toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void)nextNumber {
    
}

-(void)touchesBegan {
    switch (currentColor % 3) {
        case 0:
            self.canvas.backgroundColor = lightGrey;
            break;
        case 1:
            self.canvas.backgroundColor = darkGrey;
            break;
        default:
            self.canvas.backgroundColor = blue;
            break;
    }
    currentColor++;
}
@end
