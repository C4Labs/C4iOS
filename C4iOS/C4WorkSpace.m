//
//  C4WorkSpace.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-12.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Movie *m;
    C4Shape *s;
}

-(void)setup {
    s = [C4Shape shapeFromString:@"MASK" withFont:[C4Font fontWithName:@"helvetica" size:120.0f]];
    m = [C4Movie movieNamed:@"inception.mov"];
    [self.canvas addMovie:m];
    
    //    m.layer.mask = s.layer;
    s.center = CGPointMake(m.frame.size.width/2, m.frame.size.height/2);
//    
    m.loops = YES;
    m.shouldAutoplay = YES;
    m.center = self.canvas.center;
    [self addGe
}

@end


//@implementation C4WorkSpace 
//
//-(void)setup {
//    C4Shape *s = [C4Shape rect:CGRectMake(0, 0, 200, 200)];
//    s.center = self.canvas.center;
//    [self.canvas addShape:s];
//    [self runMethod:@"changeShapeColor:" withObject:s afterDelay:1.0f];
//    C4Image *img = [C4Image imageNamed:@"code1.png"];
//    img.origin = CGPointMake(10,self.canvas.frame.size.height - img.frame.size.height - 10);
//    [self.canvas addImage:img];
//}
//
//-(void)changeShapeColor:(C4Shape *)aShape {
//    aShape.animationDuration = 1.0f;
//    aShape.fillColor = [UIColor colorWithRed:RGBToFloat([C4Math randomInt:255]) 
//                                       green:RGBToFloat([C4Math randomInt:255])
//                                        blue:RGBToFloat([C4Math randomInt:255])
//                                       alpha:1.0f];
//    [self runMethod:@"changeShapeColor:" withObject:aShape afterDelay:1.05f];
//}
//@end

//@implementation C4WorkSpace {
//    UIColor *red, *grey, *blue;
//    
//    CGFloat l;
//    CGPoint ptsC[8], ptsDot[4], pts4[14];
//    
//    C4Shape *_C, *_4, *_Dot;
//}
//
//-(void)setup {    
//    //define colors
//    red = [UIColor colorWithRed:0.94f green:0.0f blue:0.26f alpha:1.0f];
//    blue = [UIColor colorWithRed:0.14f green:0.58f blue:0.81f alpha:1.0f];
//    grey = [UIColor colorWithRed:0.13f green:0.13f blue:0.13f alpha:1.0f];
//    
//    //define a value for the length of an edge (basically a scale value)
//    l = 100.0f;
//    
//    //define the points for the C shape
//    ptsC[0] = CGPointMake(0*l,0*l);
//    ptsC[1] = CGPointMake(2*l,0*l);
//    ptsC[2] = CGPointMake(2*l,1*l);
//    ptsC[3] = CGPointMake(1*l,1*l);
//    ptsC[4] = CGPointMake(1*l,3*l);
//    ptsC[5] = CGPointMake(3*l,3*l);
//    ptsC[6] = CGPointMake(3*l,4*l);
//    ptsC[7] = CGPointMake(0*l,4*l);
//    
//    //define the points for the Dot shape
//    ptsDot[0] = CGPointMake(2*l, 0*l);
//    ptsDot[1] = CGPointMake(3*l, 0*l);
//    ptsDot[2] = CGPointMake(3*l, 1*l);
//    ptsDot[3] = CGPointMake(2*l, 1*l);
//    
//    //define the points for the 4 shape
//    pts4[0] = CGPointMake(2*l, 1*l);
//    pts4[1] = CGPointMake(3*l, 1*l);
//    pts4[2] = CGPointMake(3*l, 2*l);
//    pts4[3] = CGPointMake(4*l, 2*l);
//    pts4[4] = CGPointMake(4*l, 0*l);
//    pts4[5] = CGPointMake(5*l, 0*l);
//    pts4[6] = CGPointMake(5*l, 2*l);
//    pts4[7] = CGPointMake(6*l, 2*l);
//    pts4[8] = CGPointMake(6*l, 3*l);
//    pts4[9] = CGPointMake(5*l, 3*l);
//    pts4[10] = CGPointMake(5*l, 4*l);
//    pts4[11] = CGPointMake(4*l, 4*l);
//    pts4[12] = CGPointMake(4*l, 3*l);
//    pts4[13] = CGPointMake(2*l, 3*l);
//    
//    //create the C shape
//    _C = [C4Shape polygon:ptsC pointCount:8];
//    _C.fillColor = red;
//    _C.lineWidth = 0.0f;  
//    
//    //create the Dot shape
//    _Dot = [C4Shape polygon:ptsDot pointCount:4];
//    _Dot.fillColor = grey;
//    _Dot.lineWidth = 0.0f;
//    _Dot.origin = CGPointMake(-l,-4*l);
//    
//    //create the 4 shape
//    _4 = [C4Shape polygon:pts4 pointCount:14];
//    _4.fillColor = blue;
//    _4.lineWidth = 0.0f;
//    _4.origin = CGPointMake(-l,-4*l);
//    
//    //add shapes to C
//    [_C addSubview:_Dot];
//    [_C addSubview:_4];
//    [self.canvas addShape:_C];
//    
//    //offset C so it looks like it's in the center (+6 keeps aligns with the launch image)
//    CGFloat dx = (self.canvas.frame.size.width - 6*l)/2 + 6;
//    CGFloat dy = (self.canvas.frame.size.height - 4*l)/2;
//    CGPoint newOrigin = _C.origin;
//    newOrigin.x += dx;
//    newOrigin.y += dy;
//    _C.origin = newOrigin;
//}
//
//@end
