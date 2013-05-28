@implementation C4WorkSpace {
    C4Shape *s1, *s2, *s3;
}

-(void)setup {
    [self setupShapes];
    
    [self addLongPressToShape:s1];
    [self addLongPressToShape:s2];
    [self addLongPressToShape:s3];
}

-(void)addLongPressToShape:(C4Shape *)shape {
    [shape addGesture:LONGPRESS name:@"longPress" action:@"pressedLong"];
    [shape minimumPressDuration:2.0f forGesture:@"longPress"];
    [self listenFor:@"pressedLong" fromObject:shape andRunMethod:@"randomColor:"];
}

-(void)randomColor: (NSNotification *)notification {
    C4Shape *shape = (C4Shape *)notification.object;
    shape.fillColor = [UIColor colorWithRed:[C4Math randomInt:100]/100.0f
                                      green:[C4Math randomInt:100]/100.0f
                                       blue:[C4Math randomInt:100]/100.0f
                                      alpha:1.0f];
    
}

-(void)setupShapes {
    CGRect shapeFrame = CGRectMake(0, 0, 100, 100);
    s1 = [C4Shape ellipse:shapeFrame];
    s2 = [C4Shape ellipse:shapeFrame];
    s3 = [C4Shape ellipse:shapeFrame];
    
    CGPoint centerPoint = self.canvas.center;
    centerPoint.y -= 150;
    s1.center = centerPoint;
    centerPoint.y += 150;
    s2.center = centerPoint;
    centerPoint.y += 150;
    s3.center = centerPoint;
    
    NSArray *shapes = @[s1,s2,s3];
    [self.canvas addObjects:shapes];
}
@end

