//
//  CustomShape.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-24.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "CustomShape.h"

@implementation CustomShape

-(id)init {
    self = [super init]; 
    if(self != nil) {
        self.lineWidth = 0.0f;
        self.animationDuration = 0.0f;
    }
    return self;
}

-(void)setup {
}

-(void)blueCircle {
    self.animationDuration = 1.0f;
//    self.fillColor = C4BLUE;
//    self.strokeColor = C4RED;
    [self ellipse:self.frame];
}

-(void)blueSquare {
    self.animationDuration = 1.0f;
//    self.fillColor = C4BLUE;
//    self.strokeColor = C4RED;
    [self rect:self.frame];
}

-(void)redCircle {
    self.animationDuration = 1.0f;
//    self.fillColor = C4RED;
//    self.strokeColor = C4BLUE;
    [self ellipse:self.frame];
}

-(void)redSquare {
//    self.animationOptions = AUTOREVERSE | REPEAT;
    self.animationDuration = 1.0f;
//    self.fillColor = C4RED;
//    self.strokeColor = C4BLUE;
    [self rect:self.frame];
}

-(void)greySquare {
    self.animationDuration = 1.0f;
    self.fillColor = C4GREY;
    [self rect:self.frame];
}

-(void)circle {
    self.animationOptions = AUTOREVERSE;
    self.animationDuration = 1.0f;
    self.lineWidth = 5.0f;
//    self.fillColor = [UIColor clearColor];
    [self ellipse:self.frame];
}

-(void)orangeRect {
    self.animationDuration = 1.0f;
    self.fillColor = [UIColor orangeColor];
    [self rect:self.frame];
}

-(void)greenCircle {
    self.animationDuration = 1.0f;
    self.lineWidth = 0.0f;
    self.fillColor = [UIColor greenColor];
    [self ellipse:self.frame];
}

-(void)swipedRight {
    [self circle];
}

-(void)swipedLeft {
    [self greySquare];
}

-(void)swipedUp {
    [self blueCircle];
}

-(void)swipedDown {
    [self redSquare];
}
-(void)pressedLong {
    [self greenCircle];
}

-(void)touchesBegan {
//    self.animationOptions = AUTOREVERSE;
    [self circle];
}
@end
