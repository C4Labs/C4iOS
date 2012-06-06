//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface C4WorkSpace ()
-(void)test;
@end;

@implementation C4WorkSpace {
    C4Timer *timer;
    C4Shape *shape;
}

-(void)setup {
    shape = [C4Shape ellipse:CGRectMake(0,0,100,100)];
    shape.animationDuration = 0.25;
    [self.canvas addShape:shape];
    
    timer = [C4Timer timerWithInterval:0.5 target:self method:@"test" repeats:YES];
    [timer listenFor:@"touchesBegan" fromObject:self andRunMethod:@"start"];
    [timer listenFor:@"touchesEnded" fromObject:self andRunMethod:@"stop"];
}

-(void)test {
    shape.center = CGPointMake([C4Math randomInt:self.canvas.width],[C4Math randomInt:self.canvas.height]);
}
@end
