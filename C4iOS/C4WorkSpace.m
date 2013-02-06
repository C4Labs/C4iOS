//
// C4WorkSpace.m
//
// Created by Travis Kirton and Greg Debicki.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *shape, *shape2;
    BOOL isStyled;
}

-(void)setup {
    shape = [C4Shape rect:CGRectMake(0, 0, 200, 200)];
    shape.center = CGPointMake(self.canvas.width * 0.33, self.canvas.center.y);

    shape2 = [C4Shape ellipse:shape.frame];
    shape2.center = CGPointMake(self.canvas.width * 0.66, self.canvas.center.y);
    
    shape.lineWidth = 10;
    shape.lineDashPattern = @[@(1),@(15)];
    shape.lineCap = CAPROUND;
    shape.shadowOpacity = 0.8;
    shape.shadowOffset = CGSizeMake(4,4);
    shape.shadowColor = C4RED;
    
    [self.canvas addObjects:@[shape, shape2]];
}

-(void)touchesBegan {
    if (isStyled == NO) {
        shape2.style = shape.style;
        isStyled = YES;
    }
}

@end