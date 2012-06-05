//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@interface MyShape : C4Shape {
}
@end

@implementation MyShape
-(void)setup {
    self.fillColor = C4GREY;
}
@end

@implementation C4WorkSpace {
    MyShape *shape;
}

-(void)setup {
    shape = [MyShape new];
    [shape ellipse:CGRectMake(100, 100, 100, 100)];
    [self.canvas addShape:shape];
}

@end
