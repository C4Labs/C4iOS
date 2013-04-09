//
//  C4WorkSpace.m
//  Notification Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    CGPoint A, B, C, D, M, P, Q, X, Y;
    CGFloat radius, theta, dX, dY, s, h, slope, b;
    C4Shape *circle, *poly, *mPt, *pPt, *qPt, *xPt, *yPt;
    C4Label *lblA, *lblB, *lblC, *lblD, *lblM, *lblP, *lblQ, *lblX, *lblY;
}

-(void)setup {
    [self setupCircleAndPoly];
    [self setX];
    [self setM];
    [self setY];
    [self setPQ];
    [self addShapesToPoly];
    [self setAngleBD];
    [self addLabels];
    [self addGesture:PAN name:@"pan" action:@"rotate:"];
    poly.backgroundColor = [C4GREY colorWithAlphaComponent:0.3];
    circle.backgroundColor = C4RED;

}

-(void)setupCircleAndPoly {
    circle = [C4Shape ellipse:CGRectMake(0,0,368,368)];
    circle.lineWidth = 2.0f;
    circle.strokeColor = C4GREY;
    circle.fillColor = [UIColor clearColor];
    
    radius = circle.width / 2.0f;
    theta = PI * 1.15f;
    A = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * 0.3f;
    B = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * 0.85f;
    C = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * 1.7f;
    D = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    CGPoint polypts[4] = {A,B,C,D};
    poly = [C4Shape polygon:polypts pointCount:4];
    poly.style = circle.style;
    poly.lineJoin = JOINBEVEL;
//    poly.anchorPoint = CGPointMake(A.x/poly.width,A.y/poly.height);
//    poly.center = A;
    [poly closeShape];
    
    [circle addShape:poly];
//    poly.anchorPoint = CGPointMake(0.5f,0.5f);
    [self.canvas addShape:circle];
    circle.center = self.canvas.center;
}

-(void)setX {
    //X is the mid-point of the left-hand circle
    X = CGPointMake((D.x + A.x)/2.0f,(D.y+A.y)/2.0f);
    
    xPt = [C4Shape ellipse:CGRectMake(0, 0, 7, 7)];
    xPt.lineWidth = 2.0f;
    xPt.strokeColor = C4GREY;
    xPt.fillColor = C4RED;
    xPt.center = X;
}

-(void)setM {
    //M is the intersection of the two internal lines of the polygon
    CGFloat a1 = B.y - A.y;
    CGFloat b1 = A.x - B.x;
    CGFloat c1 = a1*A.x + b1*A.y;
    
    CGFloat a2 = D.y - C.y;
    CGFloat b2 = C.x - D.x;
    CGFloat c2 = a2*C.x + b2*C.y;
    
    CGFloat det = a1*b2 - a2 * b1;
    M = CGPointMake((b2*c1 - b1*c2)/det, (a1*c2 - a2*c1)/det);
    mPt = [xPt copy];
    mPt.center = M;
}

-(void)setY {
    CGFloat dMX = [C4Vector distanceBetweenA:M andB:X];
    CGFloat dBM = [C4Vector distanceBetweenA:B andB:M];
    CGFloat dBC = [C4Vector distanceBetweenA:B andB:C];
    CGFloat dCM = [C4Vector distanceBetweenA:C andB:M];
    
    s = (dBM + dBC + dCM)/2;
    h = 2/dBC * [C4Math sqrt:s * (s-dBM) * (s-dBC) * (s-dCM)];
    
    dX = M.x - X.x;
    dY = M.y - X.y;
    
    Y = CGPointMake(X.x + dX * (dMX + h)/dMX, X.y + dY * (dMX + h)/dMX);
    
    yPt = [mPt copy];
    yPt.center = Y;
}

-(void)setPQ {
    slope = dY / dX;
    b = M.y;
    
    CGFloat dr = [C4Math sqrt:(dX*dX+dY*dY)];
    CGFloat bigD = X.x*M.y - M.x*X.y;
    
    CGFloat x, y;
    
    //equ for x via wolfram
    //x = (D*dY +- sgn(dY)*dx *sqrt(r2*dr2-D2))/dr2;
    
    CGFloat sgn = dY / [C4Math absf:dY];
    x = (bigD*dY+sgn*dX*[C4Math sqrt:radius*radius*dr*dr-bigD*bigD])/(dr*dr);
    y = slope*x + b;
    
    P = CGPointMake(x, y);
    
    x = (bigD*dY-sgn*dX*[C4Math sqrt:radius*radius*dr*dr-bigD*bigD])/(dr*dr);
    y = slope*x + b;
    Q = CGPointMake(x, y);
    
    pPt = [yPt copy];
    pPt.center = P;
    
    qPt = [pPt copy];
    qPt.center = Q;
}

-(void)addShapesToPoly {
    CGPoint linePts[2] = {P,Q};
    C4Shape *linePQ = [C4Shape line:linePts];
    linePQ.style = circle.style;
    
    [poly addObjects:@[linePQ,mPt,xPt,yPt,pPt,qPt]];
}

-(void)setAngleBD {
    CGFloat dAD = [C4Vector distanceBetweenA:A andB:D];
    CGFloat dAM = [C4Vector distanceBetweenA:A andB:M];
    theta = [C4Math asin:dAM / dAD];
    
    CGFloat rot;
    CGFloat dBD = [C4Vector distanceBetweenA:B andB:D];
    CGFloat dDM = [C4Vector distanceBetweenA:D andB:M];
    h = [C4Math sqrt:dDM*dDM-dBD*dBD/4.0f];
    rot = [C4Math asin:h/dDM];
    
    C4Shape *angleD = [C4Shape ellipse:CGRectMake(0, 0, 80, 80)];
    angleD.style = circle.style;
    angleD.center = D;
    angleD.strokeEnd = theta/TWO_PI;
    angleD.rotation = TWO_PI-rot-theta;
    [poly addShape:angleD];
    
    C4Shape *angleB = [angleD copy];
    angleB.rotation = PI + rot;
    angleB.center = B;
    [poly addShape:angleB];
}

-(void)addLabels {
    lblA = [C4Label labelWithText:@"A" font:[C4Font fontWithName:@"Avenir" size:16.0f]];
    lblA.center = CGPointMake(A.x - 6.0f, A.y - 8.0f);
    [poly addLabel:lblA];
    lblA.rotation = -circle.rotation;
    
    lblB = [C4Label labelWithText:@"B" font:lblA.font];
    lblB.center = CGPointMake(B.x + 5.0f, B.y + 8.0f);
    [poly addLabel:lblB];
    lblB.rotation = -circle.rotation;
    
    lblC = [C4Label labelWithText:@"C" font:lblA.font];
    lblC.center = CGPointMake(C.x + 6.0f, C.y - 8.0f);
    [poly addLabel:lblC];
    lblC.rotation = -circle.rotation;
    
    lblD = [C4Label labelWithText:@"D" font:lblA.font];
    lblD.center = CGPointMake(D.x - 6.0f, D.y + 8.0f);
    [poly addLabel:lblD];
    lblD.rotation = -circle.rotation;
    
    lblP = [C4Label labelWithText:@"P" font:lblA.font];
    lblP.center = CGPointMake(P.x - 16.0f, P.y + 4.0f);
    [poly addLabel:lblP];
    lblP.rotation = -circle.rotation;
    
    lblQ = [C4Label labelWithText:@"Q" font:lblA.font];
    lblQ.center = CGPointMake(Q.x + 14.0f, Q.y - 4.0f);
    [poly addLabel:lblQ];
    lblQ.rotation = -circle.rotation;
    
    lblM = [C4Label labelWithText:@"M" font:lblA.font];
    lblM.center = CGPointMake(M.x-1.0f, M.y-16.0f);
    [poly addLabel:lblM];
    lblM.rotation = -circle.rotation;
    
    lblX = [C4Label labelWithText:@"X" font:lblA.font];
    lblX.center = CGPointMake(X.x-10.0f, X.y-8.0f);
    [poly addLabel:lblX];
    lblX.rotation = -circle.rotation;
    
    lblY = [C4Label labelWithText:@"Y" font:lblA.font];
    lblY.center = CGPointMake(Y.x+12.0f, Y.y+8.0f);
    [poly addLabel:lblY];
    lblY.rotation = -circle.rotation;
}

-(void)rotate:(UIPanGestureRecognizer *)gesture {
    CGPoint p = [gesture translationInView:self.canvas];
    CGFloat rot = p.x / self.canvas.width * TWO_PI;
    [gesture setTranslation:CGPointZero inView:self.canvas];
    
    circle.rotation += rot;
    lblA.rotation = -circle.rotation;
    lblB.rotation = -circle.rotation;
    lblC.rotation = -circle.rotation;
    lblD.rotation = -circle.rotation;
    lblM.rotation = -circle.rotation;
    lblP.rotation = -circle.rotation;
    lblQ.rotation = -circle.rotation;
    lblX.rotation = -circle.rotation;
    lblY.rotation = -circle.rotation;

}

@end