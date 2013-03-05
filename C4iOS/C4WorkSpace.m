//
// C4WorkSpace.m
//
// Created by Travis Kirton
//

#import "C4WorkSpace.h"
#import "C4Switch.h"

@implementation C4WorkSpace {
    C4Switch *s, *t;
    C4Shape *shape;
}

-(void)setup {
    s = [C4Switch switch];
    [s runMethod:@"switchShape:" target:self forEvent:VALUECHANGED];
    s.center = self.canvas.center;

    t = [C4Switch switch];
    t.tintColor = C4GREY;
    t.thumbTintColor = C4BLUE;
    t.onImage = [C4Image imageNamed:@"pyramid"];
    t.offImage = [C4Image imageNamed:@"lines"];
    t.origin = CGPointMake(100.5,100.5);

    [self.canvas addObjects:@[s,t]];
}

-(void)switchShape:(C4Switch *)sender {
    s.animationDuration = 0.5f;
    if(sender.isOn) {
        s.center = CGPointMake([C4Math randomInt:self.canvas.width-200]+100, [C4Math randomInt:self.canvas.height-200]+100);
    } else {
        s.center = self.canvas.center;
    }
}

-(void)touchesBegan {
    s.style = t.style;
}
@end
