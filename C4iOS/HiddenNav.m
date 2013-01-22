//
//  HiddenNav.m
//  C4iOS
//
//  Created by moi on 12-12-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "HiddenNav.h"
#import "C4TransformableControl.h"

@implementation HiddenNav {
    C4TransformableControl *t;
    BOOL flipIn;
}

-(void)setup {
    t = [[C4TransformableControl alloc]
         initWithFrame:CGRectMake(0,0,self.canvas.frame.size.width/2,
                                  self.canvas.frame.size.height)];
    t.anchorPoint = CGPointMake(1.0,0.5);
//    t.userInteractionEnabled = NO;

    CGRect r = CGRectMake(2, 2, 40, 40);
    C4Shape *e = [C4Shape ellipse:r];
    e.fillColor = C4GREY;
    e.zPosition = -1;
    e.lineWidth = 0.0f;
    [self listenFor:@"touchesBegan" fromObject:e andRunMethod:@"flip"];
    [t addSubview:e];
    
    C4Image *i = [C4Image imageNamed:@"pyramid"];
    i.frame = t.bounds;
    i.userInteractionEnabled = NO;
    [t addImage:i];
    
    t.perspectiveDistance = -400.0f;
    
    [self.canvas addSubview:t];
}

-(void)flip {
    t.animationDuration = 1.0f;
    t.rotationY = PI;
}

-(void)touchesBegan {
    [self flip];
}

@end
