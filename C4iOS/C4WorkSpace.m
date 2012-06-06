//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Image *img;
    C4Shape *shape;
}

-(void)setup {
    img = [C4Image imageNamed:@"C4Sky.png"];
    img.cornerRadius = 20;
    img.masksToBounds = YES;
    [self.canvas addImage:img];

    shape = [C4Shape ellipse:CGRectMake(334, 462, 100, 100)];
    shape.borderColor = [UIColor greenColor];
    shape.borderWidth = 5.0f;
    shape.backgroundColor = [UIColor blackColor];
//    shape.masksToBounds = YES;
    shape.shadowOffset = CGSizeMake(10,10);
    shape.shadowOpacity = 0.5;
    [self.canvas addShape:shape];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    shape.cornerRadius = 10;
}

@end
