//
//  C4WorkSpace.m
//  Composite Objects Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *mainShape;
}

-(void)setup {
    mainShape = [C4Shape rect:CGRectMake(0, 0, 368, 368)];
    mainShape.lineWidth = 0.0f;
    mainShape.fillColor = [UIColor clearColor];
    
    CGFloat radius = mainShape.width / 2.0f;
    CGPoint center = CGPointMake(mainShape.width / 2, mainShape.height / 2);

    for(int i = 0; i < 12; i ++) {
        C4Shape *shape = [C4Shape ellipse:CGRectMake(0, 0, radius*2, radius*2)];
        shape.fillColor = [UIColor clearColor];
        shape.anchorPoint = CGPointMake(0.5,1.0f);
        shape.center = center;
        shape.rotation = TWO_PI / 12.0f * i;
        [mainShape addShape:shape];
        [self runMethod:@"animateShape:" withObject:shape afterDelay:(i+1)*0.5f];
    }

    C4Shape *mask = [C4Shape ellipse:CGRectMake(0, 0, radius*2, radius*2)];
    mask.center = center;
    mainShape.mask = mask;

    mainShape.center = self.canvas.center;

    mainShape.animationDuration = 10.0f;
    mainShape.animationOptions = REPEAT | LINEAR;
    mainShape.rotation = TWO_PI;
    
    [self.canvas addShape:mainShape];
}

-(void)animateShape:(C4Shape *)shape {
    shape.animationOptions = REPEAT | AUTOREVERSE;
    shape.animationDuration = 2.0f;
    shape.strokeColor = C4RED;
    shape.rotation = PI;
    
    [self runMethod:@"animateStrokeEnd:" withObject:shape afterDelay:0.25f];
}

-(void)animateStrokeEnd:(C4Shape *)shape {
    shape.animationDuration = 15.0f;
    shape.strokeEnd = 0.0f;
}

@end