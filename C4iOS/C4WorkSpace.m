//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
#import "C4Switch.h"

@implementation C4WorkSpace {
    C4Switch *s;
    C4Shape *shape;
}

-(void)setup {
    s = [C4Switch switch];
    [s runMethod:@"switchShape:" target:self forEvent:VALUECHANGED];
    [self.canvas addSubview:s];
        
    s.center = self.canvas.center;
}

-(void)switchShape:(C4Switch *)sender {
    s.animationDuration = 0.5f;
    if(sender.isOn) {
        s.center = CGPointMake([C4Math randomInt:self.canvas.width-200]+100, [C4Math randomInt:self.canvas.height-200]+100);
    } else {
        s.center = self.canvas.center;
    }
}

@end
