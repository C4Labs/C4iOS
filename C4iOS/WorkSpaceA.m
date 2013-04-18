//
//  WorkSpaceA.m
//  C4iOS
//
//  Created by travis on 2013-04-17.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "WorkSpaceA.h"

@implementation WorkSpaceA {
    C4Label *label;
    C4Font *font;
    C4Shape *circle;
    BOOL animating;
}

-(void)setup {
    circle = [C4Shape ellipse:CGRectMake(0, 0, 368, 368)];
    circle.lineWidth = 50.0f;
    circle.center = self.canvas.center;
    [self.canvas addShape:circle];
    
    font = [C4Font fontWithName:@"Avenir" size:92];
    label = [C4Label labelWithText:@"WorkSpace A" font:font];
    label.backgroundColor = [UIColor whiteColor];
    label.center = self.canvas.center;
    label.zPosition = 2;
    [self.canvas addLabel:label];

    self.canvas.borderColor = C4BLUE;
    self.canvas.borderWidth = 1.0f;
}

-(void)touchesBegan {
    if(animating == NO) {
        circle.animationDuration = 4.0f;
        circle.animationOptions = REPEAT | AUTOREVERSE;
        circle.strokeStart = 1.0f;
        animating = YES;
    }
}

@end
