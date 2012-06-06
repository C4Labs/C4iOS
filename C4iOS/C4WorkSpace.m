//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface MyShape : C4Shape
-(void)changeColor;
@end

@implementation MyShape
-(void)changeColor {
    self.fillColor = C4GREY;
}
@end

@interface C4WorkSpace ()
-(void)test;
@end;

@implementation C4WorkSpace {
    C4Shape *circle, *rect;
    MyShape *myShape;
}

-(void)setup {
    circle = [C4Shape ellipse:CGRectMake(0,0,100,100)];
    circle.animationDuration = 0.25;
    [self.canvas addShape:circle];

    rect = [C4Shape rect:CGRectMake(400,0,100,100)];
    rect.animationDuration = 0.25;
    [self.canvas addShape:rect];

    myShape = [MyShape new];
    [myShape ellipse:CGRectMake(200,0,100,100)];
    [self.canvas addShape:myShape];
    
    [self runMethod:@"test" afterDelay:1.0f];
    [self runMethod:@"testWithObject:" withObject:rect afterDelay:1.0f];
    [myShape runMethod:@"changeColor" afterDelay:1.0f];
}

-(void)test {
    circle.center = CGPointMake([C4Math randomInt:self.canvas.width],[C4Math randomInt:self.canvas.height]);
}

-(void)testWithObject:(C4Shape *)object {
    object.strokeColor = C4GREY;
}

@end
