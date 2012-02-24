//
//  CustomShape.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-24.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "CustomShape.h"

@implementation CustomShape

-(void)blueCircle {
    self.animationDuration = 1.0f;
    self.fillColor = C4BLUE;
    self.strokeColor = C4RED;
    [self ellipse:self.frame];
}

-(void)blueSquare {
    self.animationDuration = 1.0f;
    self.fillColor = C4BLUE;
    self.strokeColor = C4RED;
    [self rect:self.frame];
}

-(void)redCircle {
    self.animationDuration = 1.0f;
    self.fillColor = C4RED;
    self.strokeColor = C4BLUE;
    [self ellipse:self.frame];
}

-(void)redSquare {
    self.animationDuration = 1.0f;
    self.fillColor = C4RED;
    self.strokeColor = C4BLUE;
    [self rect:self.frame];
}

@end
