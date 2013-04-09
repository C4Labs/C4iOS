//
//  C4WorkSpace.m
//  Notification Tutorial
//
//  Created by Travis Kirton.
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    CGPoint A, B, C, D, M, P, Q, X, Y;
    CGFloat radius, theta, dX, dY, s, h, slope, b, thetaA, thetaB;
    C4Shape *circle, *poly, *mPt, *pPt, *qPt, *xPt, *yPt, *angleB, *angleD, *linePQ;
    C4Label *lblA, *lblB, *lblC, *lblD, *lblM, *lblP, *lblQ, *lblX, *lblY;
}

-(void)setup {    
    [self setupCircleAndPoly];

    xPt = [C4Shape ellipse:CGRectMake(0, 0, 7, 7)];
    xPt.lineWidth = 2.0f;
    xPt.strokeColor = C4GREY;
    xPt.fillColor = C4RED;
    [self setX];

    mPt = [xPt copy];
    [self setM];
    
    yPt = [mPt copy];
    [self setY];

    pPt = [yPt copy];
    qPt = [pPt copy];
    [self setPQ];

    [self addShapesToPoly];
    
    angleD = [C4Shape ellipse:CGRectMake(0, 0, 80, 80)];
    angleD.style = circle.style;
    angleB = [angleD copy];
    [self setAngleBD];

    [self addLabels];
    [self addGesture:PAN name:@"pan" action:@"rotate:"];
}

-(void)setupCircleAndPoly {
    circle = [C4Shape ellipse:CGRectMake(0,0,368,368)];
    circle.lineWidth = 2.0f;
    circle.strokeColor = C4GREY;
    circle.fillColor = [UIColor clearColor];
    
    radius = circle.width / 2.0f;
    theta = PI * 1.45f;
    A = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * 0.3f;
    B = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * 0.55f;
    C = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * 1.7f;
    D = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    CGPoint polypts[4] = {A,B,C,D};
    
    poly = [C4Shape polygon:polypts pointCount:4];
    poly.style = circle.style;
    poly.lineJoin = JOINBEVEL;
    
    CGPoint polyAnchor = A;
    polyAnchor.x = [C4Math map:polyAnchor.x fromMin:poly.origin.x max:poly.origin.x+poly.width toMin:0 max:1];
    polyAnchor.y = [C4Math map:polyAnchor.y fromMin:poly.origin.y max:poly.origin.y+poly.height toMin:0 max:1];
    poly.anchorPoint = polyAnchor;
    
    poly.center = CGPointMake(circle.center.x+A.x,circle.center.x+A.y);
    [poly closeShape];
    
    [circle addShape:poly];
    [self.canvas addShape:circle];
    circle.center = self.canvas.center;
}

-(void)setX {
    //X is the mid-point of the left-hand circle
    X = CGPointMake((D.x + A.x)/2.0f,(D.y+A.y)/2.0f);
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
    mPt.center = M;
}

-(void)setY {
    CGFloat angleMCB = [self angleFromA:M b:C c:B];
    CGFloat angleCMY = [self angleFromA:X b:M c:D];//because they're equal
    CGFloat angleCYM = PI - angleMCB - angleCMY;
    
    CGFloat dMX = [C4Vector distanceBetweenA:M andB:X];
    CGFloat dCM = [C4Vector distanceBetweenA:C andB:M];
    
    h = dCM/[C4Math sin:angleCYM] * [C4Math sin:angleMCB];
    
    dX = M.x - X.x;
    dY = M.y - X.y;
    
    Y = CGPointMake(X.x + dX * (dMX + h)/dMX, X.y + dY * (dMX + h)/dMX);
    yPt.center = Y;
}

-(CGFloat)angleFromA:(CGPoint)pt1 b:(CGPoint)pt2 c:(CGPoint)pt3 {
    pt1.x -= pt2.x;
    pt1.y -= pt2.y;
    pt3.x -= pt2.x;
    pt3.y -= pt2.y;
    
    return [C4Vector angleBetweenA:pt1 andB:pt3];
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
    
    if(slope > 0) {
        CGPoint temp = P;
        P = Q;
        Q = temp;
    }
    
    pPt.center = P;
    qPt.center = Q;
}

-(void)addShapesToPoly {
    CGPoint linePts[2] = {P,Q};
    linePQ = [C4Shape line:linePts];
    linePQ.style = circle.style;

    [poly addObjects:@[linePQ,mPt,xPt,yPt,pPt,qPt]];
}

-(void)setAngleBD {
    theta = [self angleFromA:A b:D c:C];
    
    CGFloat rot = [self angleFromA:C b:D c:B];
    
    angleD.center = D;
    angleD.strokeEnd = theta/TWO_PI; //normalizes to 1
    angleD.rotation = TWO_PI-rot-theta;
    [poly addShape:angleD];
    
    angleB.strokeEnd = angleD.strokeEnd;
    angleB.rotation = PI + rot;
    angleB.center = B;
    [poly addShape:angleB];
}

-(void)addLabels {
    lblA = [C4Label labelWithText:@"A" font:[C4Font fontWithName:@"TimesNewRomanPS-ItalicMT" size:16.0f]];
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

-(void)setLabelPositions {
    lblA.center = CGPointMake(A.x - 6.0f, A.y - 8.0f);
    lblA.rotation = -circle.rotation;
    
    lblB.center = CGPointMake(B.x + 5.0f, B.y + 8.0f);
    lblB.rotation = -circle.rotation;
    
    lblC.center = CGPointMake(C.x + 6.0f, C.y - 8.0f);
    lblC.rotation = -circle.rotation;
    
    lblD.center = CGPointMake(D.x - 6.0f, D.y + 8.0f);
    lblD.rotation = -circle.rotation;
    
    lblP.center = CGPointMake(P.x - 16.0f, P.y + 4.0f);
    lblP.rotation = -circle.rotation;
    
    lblQ.center = CGPointMake(Q.x + 14.0f, Q.y - 4.0f);
    lblQ.rotation = -circle.rotation;
    
    lblM.center = CGPointMake(M.x-1.0f, M.y-16.0f);
    lblM.rotation = -circle.rotation;
    
    lblX.center = CGPointMake(X.x-10.0f, X.y-8.0f);
    lblX.rotation = -circle.rotation;
    
    lblY.center = CGPointMake(Y.x+12.0f, Y.y+8.0f);
    lblY.rotation = -circle.rotation;
}

-(void)rotate:(UIPanGestureRecognizer *)gesture {
    CGPoint p = [gesture locationInView:self.canvas];
    CGFloat rot = p.x / self.canvas.width;
//    C4Log(@"%4.2f",rot);
    
    if(p.y < self.canvas.center.y) [self modifyThetaA:rot thetaB:thetaB];
    else [self modifyThetaA:1.15f thetaB:rot];

//    [gesture setTranslation:CGPointZero inView:self.canvas];
//
//    circle.rotation += rot;
//    lblA.rotation = -circle.rotation;
//    lblB.rotation = -circle.rotation;
//    lblC.rotation = -circle.rotation;
//    lblD.rotation = -circle.rotation;
//    lblM.rotation = -circle.rotation;
//    lblP.rotation = -circle.rotation;
//    lblQ.rotation = -circle.rotation;
//    lblX.rotation = -circle.rotation;
//    lblY.rotation = -circle.rotation;

}

-(void)modifyThetaA:(CGFloat)_thetaA thetaB:(CGFloat)_thetaB {
    thetaA = _thetaA;
    thetaB = _thetaB;
    
    [poly removeFromSuperview];
    poly = nil;
    
    radius = circle.width / 2.0f;
    theta = PI * thetaA;
    A = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * thetaB;
    B = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * (2.0f-thetaA);
    C = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    theta = PI * (2.0f-thetaB);
    D = CGPointMake(radius*[C4Math sin:theta], radius*[C4Math cos:theta]);
    
    CGPoint polypts[4] = {A,B,C,D};
    
    poly = [C4Shape polygon:polypts pointCount:4];
    poly.style = circle.style;
    poly.lineJoin = JOINBEVEL;
    
    CGPoint polyAnchor = A;
    polyAnchor.x = [C4Math map:polyAnchor.x fromMin:poly.origin.x max:poly.origin.x+poly.width toMin:0 max:1];
    polyAnchor.y = [C4Math map:polyAnchor.y fromMin:poly.origin.y max:poly.origin.y+poly.height toMin:0 max:1];
    poly.anchorPoint = polyAnchor;
    
    poly.center = CGPointMake(circle.width/2.0f+A.x,circle.height/2.0f+A.y);
    [poly closeShape];
    
    [circle addShape:poly];
    [self.canvas addShape:circle];
    circle.center = self.canvas.center;
    
    [self setX];
    [self setM];
    [self setY];
    [self setPQ];
    [self setAngleBD];
    
    [poly addObjects:@[lblA, lblB, lblC, lblD, lblM, lblP, lblQ, lblX, lblY]];
    [self addShapesToPoly];
    
    [self setLabelPositions];
}

@end