//
//  OuterShape.m
//  interface
//
//  Created by moi on 12-12-12.
//  Copyright (c) 2012 moi. All rights reserved.
//

#import "OuterShape.h"

@implementation OuterShape

-(void)setup {
    [self rect:CGRectMake(0, 0, [C4Math randomInt:768], [C4Math randomInt:100])];

    self.fillColor = [UIColor clearColor];
    self.backgroundColor = [C4BLUE colorWithAlphaComponent:0.75];
    self.lineWidth = 0.0f;
    self.borderColor = [UIColor blackColor];
    self.borderWidth = 1.0f;
    self.cornerRadius = 5.0f;
    [self addGesture:PAN name:@"pan" action:@"move:"];
    
    [self randomMove];
}

-(void)randomMove {
    self.animationDuration = [C4Math randomInt:20]/10.0f+0.25f;
    [self rect:CGRectMake(0, 0, [C4Math randomInt:758]+10, [C4Math randomInt:70]+10.0f)];
    self.origin = CGPointMake(0,[C4Math randomInt:self.superview.frame.size.height-self.height]);
}


@end
