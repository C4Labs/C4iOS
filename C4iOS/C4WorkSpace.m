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
    [self.canvas addMovie:m];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    m.volume = [[touches anyObject] locationInView:self.canvas].x / self.canvas.width;
}

@end
