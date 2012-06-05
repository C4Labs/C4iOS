//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Movie *m;
}

-(void)setup {
    m = [C4Movie movieNamed:@"inception.mov"];
    m.shouldAutoplay = YES;
    m.loops = YES;
    [self.canvas addMovie:m];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint currentTouchPoint = [[touches anyObject] locationInView:self.canvas];
    m.rate = (currentTouchPoint.x-384)/384;
}

@end
