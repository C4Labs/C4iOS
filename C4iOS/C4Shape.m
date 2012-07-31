//
//  C4ShapeView.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Shape.h"

@interface C4Shape() 
@property (readonly, nonatomic) BOOL initialized, shouldClose;
-(void)_ellipse:(NSValue *)ellipseValue;
-(void)_rect:(NSValue *)rectValue;
-(void)_line:(NSArray *)pointArray;
-(void)_triangle:(NSArray *)pointArray;
-(void)_polygon:(NSArray *)pointArray;
-(void)_arc:(NSDictionary *)arcDict;
-(void)_wedge:(NSDictionary *)wedgeDict;
-(void)_curve:(NSDictionary *)curveDict;
-(void)_quadCurve:(NSDictionary *)curveDict;
-(void)_shapeFromString:(NSDictionary *)stringAndFontDictionary;
-(void)_closeShape;
-(void)_setFillColor:(UIColor *)_fillColor;
-(void)_setFillRule:(NSString *)_fillRule;
-(void)_setLineCap:(NSString *)_lineCap;
-(void)_setLineDashPattern:(NSArray *)_lineDashPattern;
-(void)_setLineDashPhase:(NSNumber *)_lineDashPhase;
-(void)_setLineJoin:(NSString *)_lineJoin;
-(void)_setLineWidth:(NSNumber *)_lineWidth;
-(void)_setMiterLimit:(NSNumber *)_miterLimit;
-(void)_setStrokeColor:(UIColor *)_strokeColor;
-(void)_setStrokeStart:(NSNumber *)_strokeStart;
-(void)willChangeShape;
@property (atomic) BOOL isTriangle;
@end

@implementation C4Shape
@synthesize controlPointA = _controlPointA, controlPointB = _controlPointB, isArc = _isArc, bezierCurve = _bezierCurve, quadCurve = _quadCurve, isLine =_isLine, shapeLayer, pointA = _pointA, pointB = _pointB, wedge = _wedge;
@synthesize fillColor = _fillColor, fillRule, lineCap, lineDashPattern, lineDashPhase, lineJoin, lineWidth, miterLimit, origin = _origin, strokeColor, strokeEnd, strokeStart;
@synthesize closed = _closed, shouldClose = _shouldClose, initialized = _initialized, isTriangle = _isTriangle;
@synthesize layerTransform = _layerTransform;
@synthesize rotationX = _rotationX;
-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        _initialized = NO;
        self.animationOptions = BEGINCURRENT | EASEINOUT;
        [self willChangeShape];
        [self setup];
    }
    return self;
}

-(void)willChangeShape {
    _isArc = NO;
    _isLine = NO;
    _isTriangle = NO;
    _bezierCurve = NO;
    _quadCurve = NO;
    _closed = NO;
    _shouldClose = NO;
}

+(C4Shape *)ellipse:(CGRect)rect {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:rect];
    [newShape _ellipse:[NSValue valueWithCGRect:rect]];
    return newShape;
}

+(C4Shape *)rect:(CGRect)rect {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:rect];
    [newShape _rect:[NSValue valueWithCGRect:rect]];
    return newShape;
}

+(C4Shape *)line:(CGPoint *)pointArray {
    CGRect lineFrame = CGRectMakeFromPointArray(pointArray, 2);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:lineFrame];
    [newShape _line:[NSArray arrayWithObjects:
                     [NSValue valueWithCGPoint:pointArray[0]],
                     [NSValue valueWithCGPoint:pointArray[1]], nil]];
    return newShape;
}

+(C4Shape *)triangle:(CGPoint *)pointArray {
    CGRect polygonFrame = CGRectMakeFromPointArray(pointArray, 3);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:polygonFrame];
    [newShape _triangle:[NSArray arrayWithObjects:
                         [NSValue valueWithCGPoint:pointArray[0]],
                         [NSValue valueWithCGPoint:pointArray[1]],
                         [NSValue valueWithCGPoint:pointArray[2]], nil]];
    return newShape;
}

+(C4Shape *)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount {
    CGRect polygonFrame = CGRectMakeFromPointArray(pointArray, pointCount);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:polygonFrame];
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < pointCount; i++) {
        [points addObject:[NSValue valueWithCGPoint:pointArray[i]]];
    }
    [newShape _polygon:points];
    return newShape;
}

+(C4Shape *)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    //I'm not sure what's going on here, but i have to invert clockwise to get the 
    CGRect arcRect = CGRectMakeFromArcComponents(centerPoint,radius,startAngle,endAngle,!clockwise);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:arcRect];
    NSMutableDictionary *arcDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [arcDict setValue:[NSValue valueWithCGPoint:centerPoint] forKey:@"centerPoint"];
    [arcDict setObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
    [arcDict setObject:[NSNumber numberWithFloat:startAngle] forKey:@"startAngle"];
    [arcDict setObject:[NSNumber numberWithFloat:endAngle] forKey:@"endAngle"];
    [arcDict setObject:[NSNumber numberWithBool:clockwise] forKey:@"clockwise"];
    [newShape _arc:arcDict];
    return newShape;
}

+(C4Shape *)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    //I'm not sure what's going on here, but i have to invert clockwise to get the 
    CGRect wedgeRect = CGRectMakeFromWedgeComponents(centerPoint,radius,startAngle,endAngle,!clockwise);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:wedgeRect];
    
    NSMutableDictionary *wedgeDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [wedgeDict setValue:[NSValue valueWithCGPoint:centerPoint] forKey:@"centerPoint"];
    [wedgeDict setObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
    [wedgeDict setObject:[NSNumber numberWithFloat:startAngle] forKey:@"startAngle"];
    [wedgeDict setObject:[NSNumber numberWithFloat:endAngle] forKey:@"endAngle"];
    [wedgeDict setObject:[NSNumber numberWithBool:clockwise] forKey:@"clockwise"];
    [newShape _wedge:wedgeDict];
    return newShape;
}
+(C4Shape *)shapeFromString:(NSString *)string withFont:(C4Font *)font {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    NSDictionary *stringAndFontDictionary = [NSDictionary dictionaryWithObjectsAndKeys:string,@"string",font,@"font", nil];
    [newShape _shapeFromString:stringAndFontDictionary];
    return newShape;
}

/* the technique in both the following methods allows me to change the shape of a shape and change the shape of their view's frame automatically */
-(void)ellipse:(CGRect)rect {
    if(self.animationDelay == 0.0f) [self _ellipse:[NSValue valueWithCGRect:rect]];
    else [self performSelector:@selector(_ellipse:) withObject:[NSValue valueWithCGRect:rect] afterDelay:self.animationDelay];
}

-(void)_ellipse:(NSValue *)ellipseValue {
    [self willChangeShape];
    _closed = YES;
    CGRect aRect = [ellipseValue CGRectValue];
    aRect.origin = CGPointZero;
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(newPath, nil, aRect);
    [self.shapeLayer animatePath:newPath];
    CGPathRelease(newPath);
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    _initialized = YES;
}

-(void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    NSMutableDictionary *arcDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [arcDict setValue:[NSValue valueWithCGPoint:centerPoint] forKey:@"centerPoint"];
    [arcDict setObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
    [arcDict setObject:[NSNumber numberWithFloat:startAngle] forKey:@"startAngle"];
    [arcDict setObject:[NSNumber numberWithFloat:endAngle] forKey:@"endAngle"];
    [arcDict setObject:[NSNumber numberWithBool:clockwise] forKey:@"clockwise"];
    if(self.animationDelay == 0.0f) [self _arc:arcDict];
    else [self performSelector:@selector(_arc:) withObject:arcDict afterDelay:self.animationDelay];
}

-(void)_arc:(NSDictionary *)arcDict {
    [self willChangeShape];
    _isArc = YES;
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPoint centerPoint = [[arcDict valueForKey:@"centerPoint"] CGPointValue];
    CGPathAddArc(newPath, nil, centerPoint.x, centerPoint.y, [[arcDict objectForKey:@"radius"] floatValue], [[arcDict objectForKey:@"startAngle"] floatValue], [[arcDict objectForKey:@"endAngle"] floatValue], [[arcDict objectForKey:@"clockwise"] boolValue]);
    CGRect arcRect = CGPathGetBoundingBox(newPath);
    
    const CGAffineTransform translation = CGAffineTransformMakeTranslation(arcRect.origin.x *-1, arcRect.origin.y *-1);
    CGMutablePathRef translatedPath = CGPathCreateMutableCopyByTransformingPath(newPath, &translation);
    CGPathRelease(newPath);
    
    if (_shouldClose == YES) {
        CGPathCloseSubpath(translatedPath);
        _closed = YES;
    }
    
    [self.shapeLayer animatePath:translatedPath];
    CGRect pathRect = CGPathGetBoundingBox(translatedPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    CGPathRelease(translatedPath);
    _initialized = YES;
}

-(void)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    NSMutableDictionary *wedgeDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [wedgeDict setValue:[NSValue valueWithCGPoint:centerPoint] forKey:@"centerPoint"];
    [wedgeDict setObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
    [wedgeDict setObject:[NSNumber numberWithFloat:startAngle] forKey:@"startAngle"];
    [wedgeDict setObject:[NSNumber numberWithFloat:endAngle] forKey:@"endAngle"];
    [wedgeDict setObject:[NSNumber numberWithBool:clockwise] forKey:@"clockwise"];
    if(self.animationDelay == 0.0f) [self _wedge:wedgeDict];
    else [self performSelector:@selector(_wedge:) withObject:wedgeDict afterDelay:self.animationDelay];
}

-(void)_wedge:(NSDictionary *)arcDict {
    [self willChangeShape];
    _wedge = YES;
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPoint centerPoint = [[arcDict valueForKey:@"centerPoint"] CGPointValue];
    CGPathAddArc(newPath, nil, centerPoint.x, centerPoint.y, [[arcDict objectForKey:@"radius"] floatValue], [[arcDict objectForKey:@"startAngle"] floatValue], [[arcDict objectForKey:@"endAngle"] floatValue], [[arcDict objectForKey:@"clockwise"] boolValue]);

    CGPathAddLineToPoint(newPath, nil, centerPoint.x, centerPoint.y);

    CGRect arcRect = CGPathGetBoundingBox(newPath);
    
    const CGAffineTransform translation = CGAffineTransformMakeTranslation(arcRect.origin.x *-1, arcRect.origin.y *-1);
    CGMutablePathRef translatedPath = CGPathCreateMutableCopyByTransformingPath(newPath, &translation);
    CGPathRelease(newPath);
    
    _shouldClose = YES;
    CGPathCloseSubpath(translatedPath);
    _closed = YES;
    
    [self.shapeLayer animatePath:translatedPath];
    CGRect pathRect = CGPathGetBoundingBox(translatedPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    CGPathRelease(translatedPath);
    _initialized = YES;
}

+(C4Shape *)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray{
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectZero];
    NSMutableDictionary *curveDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[0]] forKey:@"beginPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[1]] forKey:@"endPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[0]] forKey:@"controlPoint1"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[1]] forKey:@"controlPoint2"];
    [newShape _curve:curveDict];
    return newShape;
}

+(C4Shape *)quadCurve:(CGPoint *)beginEndPointArray controlPoint:(CGPoint)controlPoint{
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectZero];
    NSMutableDictionary *curveDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[0]] forKey:@"beginPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[1]] forKey:@"endPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPoint] forKey:@"controlPoint"];
    [newShape _quadCurve:curveDict];
    return newShape;
}

-(void)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray{
    NSMutableDictionary *curveDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[0]] forKey:@"beginPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[1]] forKey:@"endPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[0]] forKey:@"controlPoint1"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[1]] forKey:@"controlPoint2"];
    if(self.animationDelay == 0.0f) [self _curve:curveDict];
    else [self performSelector:@selector(_curve:) withObject:curveDict afterDelay:self.animationDelay];
}

-(void)quadCurve:(CGPoint *)beginEndPointArray controlPoint:(CGPoint)controlPoint{
    NSMutableDictionary *quadCurveDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [quadCurveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[0]] forKey:@"beginPoint"];
    [quadCurveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[1]] forKey:@"endPoint"];
    [quadCurveDict setValue:[NSValue valueWithCGPoint:controlPoint] forKey:@"controlPoint"];
    if (self.animationDelay == 0.0f) [self _quadCurve:quadCurveDict];
    else [self performSelector:@selector(_quadCurve:) withObject:quadCurveDict afterDelay:self.animationDelay];
}

-(void)_curve:(NSDictionary *)curveDict{
    [self willChangeShape];
    _bezierCurve = YES;
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPoint beginPoint = [[curveDict valueForKey:@"beginPoint"] CGPointValue];
    CGPoint endPoint = [[curveDict valueForKey:@"endPoint"] CGPointValue];
    CGPoint controlPoint1 = [[curveDict valueForKey:@"controlPoint1"] CGPointValue];
    CGPoint controlPoint2 = [[curveDict valueForKey:@"controlPoint2"] CGPointValue];
    _pointA = beginPoint;
    _pointB = endPoint;
    _controlPointA = controlPoint1;
    _controlPointB = controlPoint2;
    CGPathMoveToPoint(newPath, nil, beginPoint.x, beginPoint.y);
    CGPathAddCurveToPoint(newPath, nil, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, endPoint.x, endPoint.y);
    CGRect tempFrame = CGPathGetPathBoundingBox(newPath);
    CGPoint tempFrameOrigin = tempFrame.origin;
    beginPoint.x -= tempFrameOrigin.x;
    beginPoint.y -= tempFrameOrigin.y;
    endPoint.x -= tempFrameOrigin.x;
    endPoint.y -= tempFrameOrigin.y;
    controlPoint1.x -= tempFrameOrigin.x;
    controlPoint1.y -= tempFrameOrigin.y;
    controlPoint2.x -= tempFrameOrigin.x;
    controlPoint2.y -= tempFrameOrigin.y;    
    CGPathRelease(newPath);
    newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, beginPoint.x, beginPoint.y);
    CGPathAddCurveToPoint(newPath, NULL, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, endPoint.x, endPoint.y);
    if (_shouldClose == YES) {
        CGPathCloseSubpath(newPath);
    }
    [self.shapeLayer animatePath:newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect;
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)_quadCurve:(NSDictionary *)curveDict{
    [self willChangeShape];
    _quadCurve = YES;
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPoint beginPoint = [[curveDict valueForKey:@"beginPoint"] CGPointValue];
    CGPoint endPoint = [[curveDict valueForKey:@"endPoint"] CGPointValue];
    CGPoint controlPoint = [[curveDict valueForKey:@"controlPoint"] CGPointValue];
    _pointA = beginPoint;
    _pointB = endPoint;
    _controlPointA = controlPoint;
    CGPathMoveToPoint(newPath, nil, beginPoint.x, beginPoint.y);
    CGPathAddQuadCurveToPoint(newPath, nil, controlPoint.x,controlPoint.y, endPoint.x, endPoint.y);
    CGRect tempFrame = CGPathGetPathBoundingBox(newPath);
    CGPoint tempFrameOrigin = tempFrame.origin;
    beginPoint.x -= tempFrameOrigin.x;
    beginPoint.y -= tempFrameOrigin.y;
    endPoint.x -= tempFrameOrigin.x;
    endPoint.y -= tempFrameOrigin.y;
    controlPoint.x -= tempFrameOrigin.x;
    controlPoint.y -= tempFrameOrigin.y;
    CGPathRelease(newPath);
    newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, beginPoint.x, beginPoint.y);
    CGPathAddQuadCurveToPoint(newPath, nil, controlPoint.x,controlPoint.y, endPoint.x, endPoint.y);
    if (_shouldClose == YES) {
        CGPathCloseSubpath(newPath);
    }
    [self.shapeLayer animatePath:newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect;
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)rect:(CGRect)rect {
    if (self.animationDelay == 0.0f) [self _rect:[NSValue valueWithCGRect:rect]];
    else [self performSelector:@selector(_rect:) withObject:[NSValue valueWithCGRect:rect] afterDelay:self.animationDelay];
}

-(void)_rect:(NSValue *)rectValue {
    [self willChangeShape];
    _closed = YES;
    CGRect aRect = [rectValue CGRectValue];
    aRect.origin = CGPointZero;
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathAddRect(newPath, nil, aRect);
    [self.shapeLayer animatePath:newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)shapeFromString:(NSString *)string withFont:(C4Font *)font {
    NSDictionary *stringAndFontDictionary = [NSDictionary dictionaryWithObjectsAndKeys:string,@"string",font,@"font", nil];
    if(self.animationDelay == 0.0f) [self _shapeFromString:stringAndFontDictionary];
    else [self performSelector:@selector(_shapeFromString:) withObject:stringAndFontDictionary];
}

-(void)_shapeFromString:(NSDictionary *)stringAndFontDictionary {
    [self willChangeShape];
    _closed = YES;
    NSString *string = [stringAndFontDictionary objectForKey:@"string"];
    C4Font *font = [stringAndFontDictionary objectForKey:@"font"];
    NSStringEncoding encoding = [NSString defaultCStringEncoding];
    CFStringRef stringRef = CFStringCreateWithCString(kCFAllocatorDefault, [string cStringUsingEncoding:encoding], encoding);
    CFIndex length = CFStringGetLength(stringRef);
    CFRelease(stringRef);
    CGAffineTransform afft = CGAffineTransformMakeScale(1, -1);
    CGMutablePathRef glyphPaths = CGPathCreateMutable();
    CGPathMoveToPoint(glyphPaths, nil, 0, 0);
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, nil);

    CGPoint currentOrigin = CGPointZero;
    for(int i = 0; i < length; i++) {
        CGGlyph currentGlyph;
        const unichar c = [string characterAtIndex:i];
        CTFontGetGlyphsForCharacters(ctFont, &c, &currentGlyph, 1);
        CGPathRef path = CTFontCreatePathForGlyph(ctFont, currentGlyph, &afft);
        CGSize advance = CGSizeZero;
        CGAffineTransform t = CGAffineTransformMakeTranslation(currentOrigin.x, currentOrigin.y);
        CGPathAddPath(glyphPaths, &t, path);
        CTFontGetAdvancesForGlyphs(ctFont, kCTFontDefaultOrientation, &currentGlyph, &advance, 1);
        currentOrigin.x += advance.width;
        CFRelease(path);
    }
    [self.shapeLayer animatePath:glyphPaths];
    CGRect pathRect = CGPathGetBoundingBox(glyphPaths);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    pathRect.origin = CGPointZero;
    self.frame = pathRect; 
    CGPathRelease(glyphPaths);
    _initialized = YES;
}
-(void)line:(CGPoint *)pointArray {
    NSArray *linePointArray = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:pointArray[0]],[NSValue valueWithCGPoint:pointArray[1]], nil];
    if(self.animationDelay == 0.0f) [self _line:linePointArray];
    else [self performSelector:@selector(_line:) withObject:linePointArray afterDelay:self.animationDelay];
}
-(void)_line:(NSArray *)pointArray {
    [self willChangeShape];
    _isLine = YES;
    _closed = YES;
    
    CGPoint points[2];

    points[0] = [[pointArray objectAtIndex:0] CGPointValue];
    points[1] = [[pointArray objectAtIndex:1] CGPointValue];
  
    _pointA = points[0];
    _pointB = points[1];
    
    CGRect lineRect = CGRectMakeFromPointArray(points, 2);
    if(_initialized == YES) self.frame = lineRect;
    CGPoint translation = lineRect.origin;
    translation.x *= -1;
    translation.y *= -1;
    
    for(int i = 0; i < 2; i++) {
        points[i].x += translation.x;
        points[i].y += translation.y;
    }
        
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, points[0].x,points[0].y);
    CGPathAddLineToPoint(newPath, nil, points[1].x, points[1].y);
//    CGPathMoveToPoint(newPath, nil, points[1].x,points[1].y);
//    CGPathAddLineToPoint(newPath, nil, points[0].x, points[0].y);
    

    [self.shapeLayer animatePath:newPath];
    CGRect newBounds = self.bounds;
    newBounds.origin = CGPointZero;
    self.bounds = newBounds;
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)triangle:(CGPoint *)pointArray {
    NSArray *trianglPointArray = [NSArray arrayWithObjects:
                                  [NSValue valueWithCGPoint:pointArray[0]],
                                  [NSValue valueWithCGPoint:pointArray[1]],
                                  [NSValue valueWithCGPoint:pointArray[2]],
                                  nil];
    if(self.animationDuration == 0.0f) [self _triangle:trianglPointArray];
    else [self performSelector:@selector(_triangle:) withObject:trianglPointArray afterDelay:self.animationDelay];
}

-(void)_triangle:(NSArray *)pointArray {
    [self willChangeShape];
    _isTriangle = YES;
    //create a c-array of points 
    NSInteger pointCount = [pointArray count];
    CGPoint points[pointCount];
    
    CGPoint translation = CGPointMake(self.frame.size.width,self.frame.size.height);
    if(translation.x == 0) translation.x = self.frame.origin.x;
    if(translation.y == 0) translation.y = self.frame.origin.y;
    translation.x *= -1;
    translation.y *= -1;
    
    for (int i = 0; i < pointCount; i++) {
        points[i] = [[pointArray objectAtIndex:i] CGPointValue];
        points[i].x += translation.x;
        points[i].y += translation.y;
    }
    
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, points[0].x, points[0].y);
    for(int i = 1; i < pointCount; i++) {
        CGPathAddLineToPoint(newPath, nil, points[i].x, points[i].y);
    }
    
    //the only difference between this and _arc
    CGPathCloseSubpath(newPath);
    _closed = YES;
    
    [self.shapeLayer animatePath:newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    CGPathRelease(newPath);
    _initialized = YES;
}

/* 
 for polygons, you're not given a rect right away
 so, i create a path, get the bounding box, then shift all the points to CGPointZero
 and recreate the path so that it sits at CGPointZero in its superview
 and then i move the superview to the right position and size
 */

-(void)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount {
    NSMutableArray *points = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < pointCount; i++) {
        [points addObject:[NSValue valueWithCGPoint:pointArray[i]]];
    }
    if(self.animationDelay == 0.0f) [self _polygon:points];
    else [self performSelector:@selector(_polygon:) withObject:points afterDelay:self.animationDelay];
}

-(void)_polygon:(NSArray *)pointArray {
    [self willChangeShape];
    //create a c-array of points 
    NSInteger pointCount = [pointArray count];
    CGPoint points[pointCount];
    
    CGPoint translation = CGPointMake(self.frame.size.width,self.frame.size.height);
    if(translation.x == 0) translation.x = self.frame.origin.x;
    if(translation.y == 0) translation.y = self.frame.origin.y;
    translation.x *= -1;
    translation.y *= -1;
 
    for (int i = 0; i < pointCount; i++) {
        points[i] = [[pointArray objectAtIndex:i] CGPointValue];
        points[i].x += translation.x;
        points[i].y += translation.y;
    }

    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, points[0].x, points[0].y);
    for(int i = 1; i < pointCount; i++) {
        CGPathAddLineToPoint(newPath, nil, points[i].x, points[i].y);
    }
    
    if (_shouldClose == YES) {
        CGPathCloseSubpath(newPath);
        _closed = YES;
    }
    [self.shapeLayer animatePath:newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
//    self.frame = pathRect;
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)closeShape {
    _shouldClose = YES;
    if(_initialized == YES) {
        if(self.animationDuration == 0.0f) [self _closeShape];
        else [self performSelector:@selector(_closeShape) withObject:nil afterDelay:self.animationDelay];
    }
}
-(void)_closeShape {
    if(_initialized == YES && _shouldClose == YES && _closed == NO) {
        CGMutablePathRef newPath = CGPathCreateMutableCopy(self.shapeLayer.path);
        CGPathCloseSubpath(newPath);
        [self.shapeLayer animatePath:newPath];
        CGPathRelease(newPath);
        _closed = YES;
    }
}

-(CGPoint)pointA {
    C4Assert(self.isLine || self.isBezierCurve || self.isQuadCurve, @"You tried to access pointA from a shape that isn't a line or a curve");
    return _pointA;
}

-(CGPoint)pointB {
    C4Assert(self.isLine || self.isBezierCurve || self.isQuadCurve, @"You tried to access pointA from a shape that isn't a line or a curve");
    return _pointB;
}

-(void)test {
}

-(void)setPointA:(CGPoint)pointA {
    C4Assert(self.isLine || self.isBezierCurve || self.isQuadCurve, @"You tried to set the value of pointA for a shape that isn't a line or a curve");
    _pointA = pointA;
    CGPoint points[2] = {_pointA,_pointB};
    if(self.isLine) [self line:points];
    else if(self.isBezierCurve) {
        CGPoint controlPoints[2] = {_controlPointA,_controlPointB};
        [self curve:points controlPoints:controlPoints];
    } else {
        [self quadCurve:points controlPoint:_controlPointA];
    }
}

-(void)setPointB:(CGPoint)pointB {
    C4Assert(self.isLine || self.isBezierCurve || self.isQuadCurve, @"You tried to set the value of pointB for a shape that isn't a line or a curve");
    _pointB = pointB;
    CGPoint points[2] = {_pointA, _pointB};
    if(self.isLine) [self line:points];
    else if(self.isBezierCurve) {
        CGPoint controlPoints[2] = {_controlPointA,_controlPointB};
        [self curve:points controlPoints:controlPoints];
    } else {
        [self quadCurve:points controlPoint:_controlPointA];
    }
}

-(void)setControlPointA:(CGPoint)controlPointA {
    C4Assert(self.isBezierCurve || self.isQuadCurve, @"You tried to set the value of controlPointA for a shape that isn't a curve");
    _controlPointA = controlPointA;
    CGPoint points[2] = {_pointA, _pointB};
    if(self.isBezierCurve) {
        CGPoint controlPoints[2] = {_controlPointA,_controlPointB};
        [self curve:points controlPoints:controlPoints];
    } else {
        [self quadCurve:points controlPoint:_controlPointA];
    }
}

-(void)setControlPointB:(CGPoint)controlPointB {
    C4Assert(self.isBezierCurve, @"You tried to set the value of controlPointB for a shape that isn't a bezier curve");
    _controlPointB = controlPointB;
    CGPoint points[2] = {_pointA, _pointB};
    CGPoint controlPoints[2] = {_controlPointA,_controlPointB};
    [self curve:points controlPoints:controlPoints];
}

-(void)setCenter:(CGPoint)center {
    if(self.isLine || self.isBezierCurve || self.isQuadCurve) {
        
        CGFloat dx = center.x - self.center.x;
        CGFloat dy = center.y - self.center.y;

        _pointA.x += dx;
        _pointA.y += dy;
        _pointB.x += dx;
        _pointB.y += dy;

        if(self.isBezierCurve || self.isQuadCurve) {
            _controlPointA.x += dx;
            _controlPointA.y += dy;
            _controlPointB.x += dx;
            _controlPointB.y += dy;
        }
    }
    [super setCenter:center];
}

-(void)setOrigin:(CGPoint)origin {
    _origin = origin;
    CGPoint difference = self.origin;
    difference.x += self.frame.size.width/2.0f;
    difference.y += self.frame.size.height/2.0f;
    self.center = difference;
}

-(void)setFillColor:(UIColor *)fillColor {
    if(self.animationDuration == 0.0f) [self _setFillColor:fillColor];
    else [self performSelector:@selector(_setFillColor:) withObject:fillColor afterDelay:self.animationDelay];
}
-(void)_setFillColor:(UIColor *)fillColor {
    _fillColor = fillColor;
    CGFloat components[4];
    [self.fillColor getRed:&components[0]
                    green:&components[1]
                     blue:&components[2]
                    alpha:&components[3]];
    C4Log(@"%4.2f,%4.2f,%4.2f,%4.2f",components[0],components[1],components[2],components[3]);
    [self.shapeLayer animateFillColor:_fillColor.CGColor];
}

-(UIColor *)fillColor {
    return _fillColor;
}

-(void)setFillRule:(NSString *)_fillRule {
    if(self.animationDelay == 0.0f) [self _setFillRule:_fillRule];
    else [self performSelector:@selector(_setFillRule:) withObject:_fillRule afterDelay:self.animationDelay];
}
-(void)_setFillRule:(NSString *)_fillRule {
    self.shapeLayer.fillRule = _fillRule;
}
-(NSString *)fillRule {
    return self.shapeLayer.fillRule;
}

-(void)setLineCap:(NSString *)_lineCap {
    if(self.animationDelay == 0.0f) [self _setLineCap:_lineCap];
    else [self performSelector:@selector(_setLineCap:) withObject:_lineCap afterDelay:self.animationDelay];
}
-(void)_setLineCap:(NSString *)_lineCap {
    self.shapeLayer.lineCap = _lineCap;
}
-(NSString *)lineCap {
    return self.shapeLayer.lineCap;
}

-(void)setDashPattern:(CGFloat *)dashPattern pointCount:(NSUInteger)pointCount {
    NSMutableArray *patternArray = [[NSMutableArray alloc] initWithCapacity:0];
    for(int i = 0; i < pointCount; i++) [patternArray addObject:[NSNumber numberWithFloat:dashPattern[i]]];
    if(self.animationDelay == 0.0f) [self _setLineDashPattern:patternArray];
    else [self performSelector:@selector(_setLineDashPattern:) withObject:patternArray afterDelay:self.animationDelay];
}

-(void)setLineDashPattern:(NSArray *)_lineDashPattern {
    if(self.animationDelay == 0.0f) [self _setLineDashPattern:_lineDashPattern];
    else [self performSelector:@selector(_setLineDashPattern:) withObject:_lineDashPattern afterDelay:self.animationDelay];
}
-(void)_setLineDashPattern:(NSArray *)_lineDashPattern {
    self.shapeLayer.lineDashPattern = _lineDashPattern;
}
-(NSArray *)lineDashPattern {
    return self.shapeLayer.lineDashPattern;
}

-(void)setLineDashPhase:(CGFloat)_lineDashPhase {
    if(self.animationDelay == 0.0f) [self _setLineDashPhase:[NSNumber numberWithFloat:_lineDashPhase]];
    else [self performSelector:@selector(_setLineDashPhase:) withObject:[NSNumber numberWithFloat:_lineDashPhase] afterDelay:self.animationDelay];
}
-(void)_setLineDashPhase:(NSNumber *)_lineDashPhase {
    [self.shapeLayer animateLineDashPhase:[_lineDashPhase floatValue]];
}
-(CGFloat)lineDashPhase {
    return self.shapeLayer.lineDashPhase;
}

-(void)setLineJoin:(NSString *)_lineJoin {
    if(self.animationDelay == 0.0f) [self _setLineJoin:_lineJoin];
    else [self performSelector:@selector(_setLineJoin:) withObject:_lineJoin afterDelay:self.animationDelay];
}
-(void)_setLineJoin:(NSString *)_lineJoin {
    self.shapeLayer.lineJoin = _lineJoin;
}
-(NSString *)lineJoin {
    return self.shapeLayer.lineJoin;
}

-(void)setLineWidth:(CGFloat)_lineWidth {
    if(self.animationDelay == 0.0f) [self _setLineWidth:[NSNumber numberWithFloat:_lineWidth]];
    else [self performSelector:@selector(_setLineWidth:) withObject:[NSNumber numberWithFloat:_lineWidth] afterDelay:self.animationDelay];
}
-(void)_setLineWidth:(NSNumber *)_lineWidth {
    lineWidth = [_lineWidth floatValue];
    [self.shapeLayer animateLineWidth:[_lineWidth floatValue]];
}
-(CGFloat)lineWidth {
    return lineWidth;
}

-(void)setMiterLimit:(CGFloat)_miterLimit {
    if(self.animationDelay == 0.0f) [self _setMiterLimit:[NSNumber numberWithFloat:_miterLimit]];
    else [self performSelector:@selector(_setMiterLimit:) withObject:[NSNumber numberWithFloat:_miterLimit] afterDelay:self.animationDelay];
}
-(void)_setMiterLimit:(NSNumber *)_miterLimit {
    [self.shapeLayer animateMiterLimit:[_miterLimit floatValue]];
}
-(CGFloat)miterLimit {
    return self.shapeLayer.miterLimit;
}

-(void)setStrokeColor:(UIColor *)_strokeColor {
    if(self.animationDelay == 0.0f) [self _setStrokeColor:_strokeColor];
    else [self performSelector:@selector(_setStrokeColor:) withObject:_strokeColor afterDelay:self.animationDelay];
}
-(void)_setStrokeColor:(UIColor *)_strokeColor {
    [self.shapeLayer animateStrokeColor:_strokeColor.CGColor];
}
-(UIColor *)strokeColor {
    return [UIColor colorWithCGColor:self.shapeLayer.strokeColor];
}

-(void)setStrokeEnd:(CGFloat)_strokeEnd {
    if(self.animationDelay == 0.0f ) [self _setStrokeEnd:[NSNumber numberWithFloat:_strokeEnd]];
    else [self performSelector:@selector(_setStrokeEnd:) withObject:[NSNumber numberWithFloat:_strokeEnd] afterDelay:self.animationDelay];
}
-(void)_setStrokeEnd:(NSNumber *)_strokeEnd {
    [self.shapeLayer animateStrokeEnd:[_strokeEnd floatValue]];
}
-(CGFloat)strokeEnd {
    return self.shapeLayer.strokeEnd;
}

-(void)setStrokeStart:(CGFloat)_strokeStart {
    if(self.animationDelay == 0.0f) [self _setStrokeStart:[NSNumber numberWithFloat:_strokeStart]];
    else [self performSelector:@selector(_setStrokeStart:) withObject:[NSNumber numberWithFloat:_strokeStart] afterDelay:self.animationDelay];
}
-(void)_setStrokeStart:(NSNumber *)_strokeStart {
    [self.shapeLayer animateStrokeStart:[_strokeStart floatValue]];
}
-(CGFloat)strokeStart {
    return self.shapeLayer.strokeStart;
}

/* leaving out repeat count for now... it's a bit awkward */
-(void)setRepeatCount:(CGFloat)repeatCount {
//    [super setRepeatCount:repeatCount];
//    self.shapeLayer.repeatCount = repeatCount;
}

-(void)setup {
}

/* NOTE: YOU CAN'T HIT TEST A CGPATH which is a line */
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if (_isLine == YES) return NO;
    return CGPathContainsPoint(self.shapeLayer.path, nil, point, nil) ? YES : NO;
}

#pragma mark C4Shapelayer-backed object methods
//-(void)addSubview:(UIView *)view {
//    /* NEVER ADD A SUBVIEW TO A SHAPE */
//    C4Log(@"NEVER ADD A SUBVIEW TO A SHAPE");
//}

#pragma mark Layer class methods
-(C4ShapeLayer *)shapeLayer {
    return (C4ShapeLayer *)self.layer;
}

+(Class)layerClass {
    return [C4ShapeLayer class];
}

-(id)copyWithZone:(NSZone *)zone {
    return self;
}

-(void)setLayerTransform:(CATransform3D)layerTransform {
    _layerTransform = layerTransform;
    [(C4Layer *)self.layer animateLayerTransform:_layerTransform];
}

-(void)setRotationX:(CGFloat)rotationX {
    _rotationX = rotationX;
    [(C4ShapeLayer *)self.layer animateRotationX:rotationX];
}

@end
