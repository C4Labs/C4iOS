//
//  WorkSpaceB.m
//  C4iOS
//
//  Created by travis on 2013-04-17.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "WorkSpaceB.h"

@implementation WorkSpaceB {
    C4Label *label;
    C4Font *font;
    C4Shape *square;
    BOOL animating;
}

-(void)setup {
    square = [C4Shape rect:CGRectMake(0, 0, 368, 368)];
    square.lineWidth = 50.0f;
    square.strokeColor = C4RED;
    square.center = self.canvas.center;
    [self.canvas addShape:square];
    
    font = [C4Font fontWithName:@"Avenir" size:92];
    label = [C4Label labelWithText:@"WorkSpace B" font:font];
    label.backgroundColor = [UIColor whiteColor];
    label.center = self.canvas.center;
    [self.canvas addLabel:label];
    
    self.canvas.borderColor = C4RED;
    self.canvas.borderWidth = 1.0f;
}

-(void)touchesBegan {
    if(animating == NO) {
        square.animationDuration = 4.0f;
        square.animationOptions = REPEAT | AUTOREVERSE;
        square.rotation = TWO_PI;
        animating = YES;
    }
}


@end
