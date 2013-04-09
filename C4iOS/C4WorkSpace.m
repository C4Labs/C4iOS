//
//  C4WorkSpace.m
//  Notification Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace

-(void)setup {
    C4Shape *circle = [C4Shape ellipse:CGRectMake(0,0,368,368)];
    circle.lineWidth = 2.0f;
    circle.strokeColor = C4GREY;
    circle.fillColor = [UIColor clearColor];
    
    CGPoint A, B, C, D, M, P, Q, X, Y;
    
    A = CGPointMake(10, 10);
    B = CGPointMake(110, 110);
    C = CGPointMake(110, 10);
    D = CGPointMake(10, 110);
    
    CGFloat radius = circle.width / 2.0f;
    CGFloat theta = PI * 1.15f;
    A = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * 0.3f;
    B = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * 0.85f;
    C = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * 1.7f;
    D = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    CGPoint polypts[4] = {A,B,C,D};
    C4Shape *poly = [C4Shape polygon:polypts pointCount:4];

    C4Label *lA, *lB, *lC, *lD;
    lA = [C4Label labelWithText:@"A"];
    lA.textColor = C4RED;
    lA.center = A;
    
    lB = [C4Label labelWithText:@"B"];
    lB.textColor = C4RED;
    lB.center = B;
    
    lC = [C4Label labelWithText:@"C"];
    lC.textColor = C4RED;
    lC.center = C;
    
    lD = [C4Label labelWithText:@"D"];
    lD.textColor = C4RED;
    lD.center = D;
    
//    [poly addObjects:@[lA, lB, lC, lD]];
    
    poly.center = CGPointMake(circle.width/2.0f,poly.height/2.0f+20.0f);
    poly.style = circle.style;
    poly.miterLimit = 50.0f;
    poly.lineJoin = JOINBEVEL;
    [poly closeShape];

    [self.canvas addShape:poly];
    
    [circle addShape:poly];
    [self.canvas addShape:circle];
    circle.center = self.canvas.center;
    
    X = CGPointMake((D.x + A.x)/2.0f,(D.y+A.y)/2.0f);
    C4Shape *c = [C4Shape ellipse:CGRectMake(0, 0, 7, 7)];
    c.lineWidth = 2.0f;
    c.strokeColor = C4GREY;
    c.fillColor = C4RED;
    c.center = X;
    
    CGFloat a1 = B.y - A.y;
    CGFloat b1 = A.x - B.x;
    CGFloat c1 = a1*A.x + b1*A.y;

    CGFloat a2 = D.y - C.y;
    CGFloat b2 = C.x - D.x;
    CGFloat c2 = a2*C.x + b2*C.y;
    
    CGFloat det = a1*b2 - a2 * b1;
    M = CGPointMake((b2*c1 - b1*c2)/det, (a1*c2 - a2*c1)/det);
    C4Shape *m = [c copy];
    m.center = M;
    
    //////////////
    
    CGFloat dMX = [C4Vector distanceBetweenA:M andB:X];
    
    CGFloat dBM = [C4Vector distanceBetweenA:B andB:M];
    CGFloat dBC = [C4Vector distanceBetweenA:B andB:C];
    CGFloat dCM = [C4Vector distanceBetweenA:C andB:M];
    
    CGFloat s = (dBM + dBC + dCM)/2;
    CGFloat h = 2/dBC * [C4Math sqrt:s * (s-dBM) * (s-dBC) * (s-dCM)];
    
    CGFloat dY = M.y - X.y;
    CGFloat dX = M.x - X.x;
    
    Y = CGPointMake(X.x + dX * (dMX + h)/dMX, X.y + dY * (dMX + h)/dMX);
    
    C4Shape *y = [m copy];
    y.center = Y;
    
    CGPoint linePts[2] = {X,Y};
    C4Shape *lineXY = [C4Shape line:linePts];
    lineXY.style = circle.style;
    
    [poly addObjects:@[lineXY,c,m,y]];
}

@end