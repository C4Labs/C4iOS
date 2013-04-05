//
//  C4WorkSpace.m
//  Examples
//
//  Created by Greg Debicki.
//

@implementation C4WorkSpace {
    C4Sample *s;
    C4Timer *meterUpdateTimer;
    C4Shape *peakLeft, *peakRight, *avgLeft, *avgRight;
}

-(void)setup {
    s = [C4Sample sampleNamed:@"Harmonograph.aif"];
    [s prepareToPlay];
    
    s.loops = YES;
    s.meteringEnabled = YES;
    [s prepareToPlay];
    [s play];
    
    CGPoint pts[2] = {
        CGPointMake(self.canvas.width / 2, self.canvas.center.y - 100),
        CGPointMake(self.canvas.width / 2, self.canvas.center.y + 100)
    };
    pts[0].x -= 100;
    pts[1].x -= 100;
    avgLeft = [C4Shape line:pts];
    pts[0].x += 75;
    pts[1].x += 75;
    avgRight = [C4Shape line:pts];
    pts[0].x += 75;
    pts[1].x += 75;
    peakLeft = [C4Shape line:pts];
    pts[0].x += 75;
    pts[1].x += 75;
    peakRight = [C4Shape line:pts];
    avgLeft.strokeColor = C4RED;
    avgRight.strokeColor = C4RED;
    [self.canvas addObjects:@[avgLeft, avgRight, peakLeft, peakRight]];
    meterUpdateTimer = [C4Timer timerWithInterval:1/30.0f target:self method:@"updateMeters" repeats:YES];
    [meterUpdateTimer start];
    
}

-(void)updateMeters {
    [s updateMeters];
    avgLeft.strokeEnd = [C4Math pow:10 raisedTo:0.05 * [s averagePowerForChannel:0]];
    avgRight.strokeEnd = [C4Math pow:10 raisedTo:0.05 * [s averagePowerForChannel:1]];
    peakLeft.strokeEnd = [C4Math pow:10 raisedTo:0.05 * [s peakPowerForChannel:0]];
    peakRight.strokeEnd = [C4Math pow:10 raisedTo:0.05 * [s peakPowerForChannel:1]];
}

-(void)touchesBegan {
    [s play];
}

@end