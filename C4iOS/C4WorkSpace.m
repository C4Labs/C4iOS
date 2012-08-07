//
//  C4Workspace.h
//  Examples
//
//  Created by Travis Kirton
//

#import "C4Workspace.h"

@interface C4WorkSpace ()
@end

@implementation C4WorkSpace {
    C4Image *x, *y, *z;
}


-(void)setup {
    x = [C4Image imageNamed:@"C4Sky.png"];
    x.width = 200;
    x.center = CGPointMake(self.canvas.center.x, self.canvas.height / 4);
    [self.canvas addImage:x];

    y = [C4Image imageNamed:@"C4Sky.png"];
    y.width = 200;
    y.center = self.canvas.center;
    [self.canvas addImage:y];

    z = [C4Image imageNamed:@"C4Sky.png"];
    z.width = 200;
    z.center = CGPointMake(self.canvas.center.x, self.canvas.height * 3 / 4);
    [self.canvas addImage:z];
}

-(void)touchesBegan {
    x.animationDuration = 1.0f;
    y.animationDuration = 1.0f;
    z.animationDuration = 1.0f;

    x.rotationX += PI / 3;
    y.rotationY += TWO_PI;
    z.rotation += PI / 3;
}

@end