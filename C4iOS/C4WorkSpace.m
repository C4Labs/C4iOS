//
// C4WorkSpace.m
//
// Created by Travis Kirton and Greg Debicki.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Label *l1, *l2;
}

-(void)setup {
    l1 = [C4Label labelWithText:@"hi"];
    l1.textColor = C4RED;
    l1.shadowOpacity = 0.8f;
    l1.shadowOffset = CGSizeMake(2,2);
    l1.shadowRadius = 2.0f;
    l1.textShadowOffset = CGSizeMake(1,1);
    l1.textShadowColor = l1.shadowColor;
    [self.canvas addLabel:l1];
}

-(void)touchesBegan {
    if(l2 == nil) {
        l2 = [l1 copy];
        l2.origin = CGPointMake(100,0);
        [self.canvas addLabel:l2];
    }
}

@end