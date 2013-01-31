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
@property (atomic) BOOL isTriangle;
@property (readonly, atomic) NSArray *localStylePropertyNames;
@end

@implementation C4Shape
@synthesize pointA = _pointA, pointB = _pointB; //need to synth because we have implemented both the setter and getter

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        _initialized = NO;
        _localStylePropertyNames = @[
        @"fillColor",
        @"fillRule",
        @"lineCap",
        @"lineDashPattern",
        @"lineDashPhase",
        @"lineJoin",
        @"lineWidth",
        @"miterLimit",
        @"strokeColor",
        @"strokeEnd",
        @"strokeStart"
        ];
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
    [newShape _line:@[[NSValue valueWithCGPoint:pointArray[0]],
                     [NSValue valueWithCGPoint:pointArray[1]]]];
    return newShape;
}

+(C4Shape *)triangle:(CGPoint *)pointArray {
    CGRect polygonFrame = CGRectMakeFromPointArray(pointArray, 3);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:polygonFrame];
    [newShape _triangle:@[[NSValue valueWithCGPoint:pointArray[0]],
                         [NSValue valueWithCGPoint:pointArray[1]],
                         [NSValue valueWithCGPoint:pointArray[2]]]];
    return newShape;
}

+(C4Shape *)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount {
    CGRect polygonFrame = CGRectMakeFromPointArray(pointArray, pointCount);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:polygonFrame];
    NSMutableArray *points = [@[] mutableCopy];
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
    NSMutableDictionary *arcDict = [@[] mutableCopy];
    [arcDict setValue:[NSValue valueWithCGPoint:centerPoint] forKey:@"centerPoint"];
    arcDict[@"radius"] = @(radius);
    arcDict[@"startAngle"] = @(startAngle);
    arcDict[@"endAngle"] = @(endAngle);
    arcDict[@"clockwise"] = @(clockwise);
    [newShape _arc:arcDict];
    return newShape;
}

+(C4Shape *)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    CGRect wedgeRect = CGRectMakeFromWedgeComponents(centerPoint,radius,startAngle,endAngle,clockwise);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:wedgeRect];
    
    NSMutableDictionary *wedgeDict = [@[] mutableCopy];
    [wedgeDict setValue:[NSValue valueWithCGPoint:centerPoint] forKey:@"centerPoint"];
    wedgeDict[@"radius"] = @(radius);
    wedgeDict[@"startAngle"] = @(startAngle);
    wedgeDict[@"endAngle"] = @(endAngle);
    wedgeDict[@"clockwise"] = @(clockwise);
    [newShape _wedge:wedgeDict];
    return newShape;
}
+(C4Shape *)shapeFromString:(NSString *)string withFont:(C4Font *)font {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    NSDictionary *stringAndFontDictionary = @{@"string": string,@"font": font};
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
    
    CGRect newFrame = [ellipseValue CGRectValue];
    CGRect newBounds = CGRectMake(0, 0, newFrame.size.width, newFrame.size.height);
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(newPath, nil, newBounds);
    if(self.animationDuration == 0.0f) self.shapeLayer.path = newPath;
    else [self.shapeLayer animatePath:newPath];
    CGPathRelease(newPath);
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    self.origin = newFrame.origin;
    _initialized = YES;
}

-(void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    NSMutableDictionary *arcDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [arcDict setValue:[NSValue valueWithCGPoint:centerPoint] forKey:@"centerPoint"];
    arcDict[@"radius"] = @(radius);
    arcDict[@"startAngle"] = @(startAngle);
    arcDict[@"endAngle"] = @(endAngle);
    arcDict[@"clockwise"] = @(clockwise);
    if(self.animationDelay == 0.0f) [self _arc:arcDict];
    else [self performSelector:@selector(_arc:) withObject:arcDict afterDelay:self.animationDelay];
}

-(void)_arc:(NSDictionary *)arcDict {
    [self willChangeShape];
    _isArc = YES;
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPoint centerPoint = [[arcDict valueForKey:@"centerPoint"] CGPointValue];
    //strage, i have to invert the Bool value for clockwise
    CGPathAddArc(newPath, nil, centerPoint.x, centerPoint.y, [arcDict[@"radius"] floatValue], [arcDict[@"startAngle"] floatValue], [arcDict[@"endAngle"] floatValue], ![arcDict[@"clockwise"] boolValue]);
    CGRect arcRect = CGPathGetBoundingBox(newPath);
    
    const CGAffineTransform translation = CGAffineTransformMakeTranslation(arcRect.origin.x *-1, arcRect.origin.y *-1);
    CGMutablePathRef translatedPath = CGPathCreateMutableCopyByTransformingPath(newPath, &translation);
    CGPathRelease(newPath);
    
    if (_shouldClose == YES) {
        CGPathCloseSubpath(translatedPath);
        _closed = YES;
    }
    if(self.animationDuration == 0.0f) self.shapeLayer.path = translatedPath;
    else [self.shapeLayer animatePath:translatedPath];
    CGPathRelease(translatedPath);
    _initialized = YES;
}

-(void)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    NSMutableDictionary *wedgeDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [wedgeDict setValue:[NSValue valueWithCGPoint:centerPoint] forKey:@"centerPoint"];
    wedgeDict[@"radius"] = @(radius);
    wedgeDict[@"startAngle"] = @(startAngle);
    wedgeDict[@"endAngle"] = @(endAngle);
    wedgeDict[@"clockwise"] = @(clockwise);
    if(self.animationDelay == 0.0f) [self _wedge:wedgeDict];
    else [self performSelector:@selector(_wedge:) withObject:wedgeDict afterDelay:self.animationDelay];
}

-(void)_wedge:(NSDictionary *)arcDict {
    [self willChangeShape];
    _wedge = YES;
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPoint centerPoint = [[arcDict valueForKey:@"centerPoint"] CGPointValue];
    //strage, i have to invert the Bool value for clockwise
    CGPathAddArc(newPath, nil, centerPoint.x, centerPoint.y, [arcDict[@"radius"] floatValue], [arcDict[@"startAngle"] floatValue], [arcDict[@"endAngle"] floatValue], ![arcDict[@"clockwise"] boolValue]);

    CGPathAddLineToPoint(newPath, nil, centerPoint.x, centerPoint.y);

    CGRect arcRect = CGPathGetBoundingBox(newPath);
    
    const CGAffineTransform translation = CGAffineTransformMakeTranslation(arcRect.origin.x *-1, arcRect.origin.y *-1);
    CGMutablePathRef translatedPath = CGPathCreateMutableCopyByTransformingPath(newPath, &translation);
    CGPathRelease(newPath);
    
    _shouldClose = YES;
    CGPathCloseSubpath(translatedPath);
    _closed = YES;
    
    if(self.animationDuration == 0.0f) self.shapeLayer.path = translatedPath;
    else [self.shapeLayer animatePath:translatedPath];
    CGPathRelease(translatedPath);
    _initialized = YES;
}

+(C4Shape *)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray{
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectMakeFromPointArray(beginEndPointArray, 2)];
    NSMutableDictionary *curveDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[0]] forKey:@"beginPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[1]] forKey:@"endPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[0]] forKey:@"controlPoint1"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[1]] forKey:@"controlPoint2"];
    [newShape _curve:curveDict];
    return newShape;
}

+(C4Shape *)quadCurve:(CGPoint *)beginEndPointArray controlPoint:(CGPoint)controlPoint{
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectMakeFromPointArray(beginEndPointArray, 2)];
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
    CGPathMoveToPoint(newPath, nil, 0,0);
    const CGAffineTransform translation = CGAffineTransformMakeTranslation(-1*beginPoint.x, -1*beginPoint.y);
    CGPathAddCurveToPoint(newPath, &translation, controlPoint1.x, controlPoint1.y, controlPoint2.x, controlPoint2.y, endPoint.x, endPoint.y);
    if(self.animationDuration == 0.0f) self.shapeLayer.path = newPath;
    else [self.shapeLayer animatePath:newPath];
//    CGRect pathRect = CGPathGetBoundingBox(newPath);
//    self.bounds = pathRect;
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
    CGPathMoveToPoint(newPath, nil,0,0);
    const CGAffineTransform translation = CGAffineTransformMakeTranslation(-1*beginPoint.x, -1*beginPoint.y);
    CGPathAddQuadCurveToPoint(newPath, &translation, controlPoint.x,controlPoint.y, endPoint.x, endPoint.y);
    if(self.animationDuration == 0.0f) self.shapeLayer.path = newPath;
    else [self.shapeLayer animatePath:newPath];
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
    CGRect newRect = [rectValue CGRectValue];
    CGRect newBounds = CGRectMake(0, 0, newRect.size.width, newRect.size.height);
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathAddRect(newPath, nil, newBounds);
    if(self.animationDuration == 0.0f) self.shapeLayer.path = newPath;
    else [self.shapeLayer animatePath:newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    self.origin = newRect.origin;
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)shapeFromString:(NSString *)string withFont:(C4Font *)font {
    NSDictionary *stringAndFontDictionary = @{@"string": string,@"font": font};
    if(self.animationDelay == 0.0f) [self _shapeFromString:stringAndFontDictionary];
    else [self performSelector:@selector(_shapeFromString:) withObject:stringAndFontDictionary];
}

-(void)_shapeFromString:(NSDictionary *)stringAndFontDictionary {
    [self willChangeShape];
    _closed = YES;
    NSString *string = stringAndFontDictionary[@"string"];
    C4Font *font = stringAndFontDictionary[@"font"];
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
        CGPathRef fontPath = CTFontCreatePathForGlyph(ctFont, currentGlyph, &afft);
        CGSize advance = CGSizeZero;
        CGAffineTransform t = CGAffineTransformMakeTranslation(currentOrigin.x, currentOrigin.y);
        CGPathAddPath(glyphPaths, &t, fontPath);
        CTFontGetAdvancesForGlyphs(ctFont, kCTFontDefaultOrientation, &currentGlyph, &advance, 1);
        currentOrigin.x += advance.width;
        CFRelease(fontPath);
    }
    if(self.animationDuration == 0.0f) self.shapeLayer.path = glyphPaths;
    else [self.shapeLayer animatePath:glyphPaths];
    CGRect pathRect = CGPathGetBoundingBox(glyphPaths);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    pathRect.origin = CGPointZero;
    self.frame = pathRect; 
    CGPathRelease(glyphPaths);
    _initialized = YES;
}
-(void)line:(CGPoint *)pointArray {
    NSArray *linePointArray = @[[NSValue valueWithCGPoint:pointArray[0]],[NSValue valueWithCGPoint:pointArray[1]]];
    if(self.animationDelay == 0.0f) [self _line:linePointArray];
    else [self performSelector:@selector(_line:) withObject:linePointArray afterDelay:self.animationDelay];
}
-(void)_line:(NSArray *)pointArray {
    [self willChangeShape];
    _isLine = YES;
    _closed = YES;
    
    CGPoint points[2];

    points[0] = [pointArray[0] CGPointValue];
    points[1] = [pointArray[1] CGPointValue];
  
    _pointA = points[0];
    _pointB = points[1];
    
    CGRect lineRect = CGRectMakeFromPointArray(points, 2);
    if(_initialized == YES) self.frame = lineRect;
    self.origin = self.frame.origin;
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
    

    if(self.animationDuration == 0.0f) self.shapeLayer.path = newPath;
    else [self.shapeLayer animatePath:newPath];
    CGRect newBounds = self.bounds;
    newBounds.origin = CGPointZero;
    self.bounds = newBounds;
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)triangle:(CGPoint *)pointArray {
    NSArray *trianglePointArray = @[[NSValue valueWithCGPoint:pointArray[0]],
                                  [NSValue valueWithCGPoint:pointArray[1]],
                                  [NSValue valueWithCGPoint:pointArray[2]]];
    if(self.animationDuration == 0.0f) [self _triangle:trianglePointArray];
    else [self performSelector:@selector(_triangle:) withObject:trianglePointArray afterDelay:self.animationDelay];
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
        points[i] = [pointArray[i] CGPointValue];
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
    
    if(self.animationDuration == 0.0f) self.shapeLayer.path = newPath;
    else [self.shapeLayer animatePath:newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
//    self.origin = self.frame.origin;
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
    NSMutableArray *points = [@[] mutableCopy];
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
        points[i] = [pointArray[i] CGPointValue];
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
    if(self.animationDuration == 0.0f) self.shapeLayer.path = newPath;
    else [self.shapeLayer animatePath:newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
//    _origin = self.frame.origin;
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)closeShape {
    _shouldClose = YES;
        if(self.animationDuration == 0.0f) [self _closeShape];
        else [self performSelector:@selector(_closeShape) withObject:nil afterDelay:self.animationDelay];
}
-(void)_closeShape {
    if(_initialized == YES && _shouldClose == YES && _closed == NO) {
        CGMutablePathRef newPath = CGPathCreateMutableCopy(self.shapeLayer.path);
        CGPathCloseSubpath(newPath);
        if(self.animationDuration == 0.0f) self.shapeLayer.path = newPath;
        else [self.shapeLayer animatePath:newPath];
        CGPathRelease(newPath);
        _closed = YES;
    }
}

-(void)test {
}

-(CGPathRef)path {
    return self.shapeLayer.path;
}


-(void)setPath:(CGPathRef)newPath {
    CGRect oldRect = self.frame;
    if(self.animationDuration == 0.0f) self.shapeLayer.path = newPath;
    else [self.shapeLayer animatePath:newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    pathRect.origin = CGPointZero;
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    self.origin = oldRect.origin;
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

-(CGPoint)pointA {
    C4Assert(self.isLine || self.isBezierCurve || self.isQuadCurve, @"You tried to access pointA from a shape that isn't a line or a curve");
    return _pointA;
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

-(CGPoint)pointB {
    C4Assert(self.isLine || self.isBezierCurve || self.isQuadCurve, @"You tried to access pointA from a shape that isn't a line or a curve");
    return _pointB;
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

-(void)setFillColor:(UIColor *)fillColor {
    if(self.animationDuration == 0.0f) [self _setFillColor:fillColor];
    else [self performSelector:@selector(_setFillColor:) withObject:fillColor afterDelay:self.animationDelay];
}
-(void)_setFillColor:(UIColor *)fillColor {
    [self.shapeLayer animateFillColor:fillColor.CGColor];
}

-(UIColor *)fillColor {
    return [UIColor colorWithCGColor:self.shapeLayer.fillColor];
}

-(void)setFillRule:(NSString *)fillRule {
    if(self.animationDelay == 0.0f) [self _setFillRule:fillRule];
    else [self performSelector:@selector(_setFillRule:) withObject:fillRule afterDelay:self.animationDelay];
}
-(void)_setFillRule:(NSString *)fillRule {
    self.shapeLayer.fillRule = fillRule;
}
-(NSString *)fillRule {
    return self.shapeLayer.fillRule;
}

-(void)setLineCap:(NSString *)lineCap {
    if(self.animationDelay == 0.0f) [self _setLineCap:lineCap];
    else [self performSelector:@selector(_setLineCap:) withObject:lineCap afterDelay:self.animationDelay];
}
-(void)_setLineCap:(NSString *)lineCap {
    self.shapeLayer.lineCap = lineCap;
}
-(NSString *)lineCap {
    return self.shapeLayer.lineCap;
}

-(void)setDashPattern:(CGFloat *)dashPattern pointCount:(NSUInteger)pointCount {
    NSMutableArray *patternArray = [@[] mutableCopy];
    for(int i = 0; i < pointCount; i++) [patternArray addObject:@(dashPattern[i])];
    if(self.animationDelay == 0.0f) [self _setLineDashPattern:patternArray];
    else [self performSelector:@selector(_setLineDashPattern:) withObject:patternArray afterDelay:self.animationDelay];
}

-(void)setLineDashPattern:(NSArray *)lineDashPattern {
    if(self.animationDelay == 0.0f) [self _setLineDashPattern:lineDashPattern];
    else [self performSelector:@selector(_setLineDashPattern:) withObject:lineDashPattern afterDelay:self.animationDelay];
}

-(void)_setLineDashPattern:(NSArray *)lineDashPattern {
    self.shapeLayer.lineDashPattern = lineDashPattern;
}

-(NSArray *)lineDashPattern {
    return self.shapeLayer.lineDashPattern;
}

-(void)setLineDashPhase:(CGFloat)lineDashPhase {
    if(self.animationDelay == 0.0f) [self _setLineDashPhase:@(lineDashPhase)];
    else [self performSelector:@selector(_setLineDashPhase:) withObject:@(lineDashPhase) afterDelay:self.animationDelay];
}

-(void)_setLineDashPhase:(NSNumber *)lineDashPhase {
    [self.shapeLayer animateLineDashPhase:[lineDashPhase floatValue]];
}

-(CGFloat)lineDashPhase {
    return self.shapeLayer.lineDashPhase;
}

-(void)setLineJoin:(NSString *)lineJoin {
    if(self.animationDelay == 0.0f) [self _setLineJoin:lineJoin];
    else [self performSelector:@selector(_setLineJoin:) withObject:lineJoin afterDelay:self.animationDelay];
}
-(void)_setLineJoin:(NSString *)lineJoin {
    self.shapeLayer.lineJoin = lineJoin;
}

-(NSString *)lineJoin {
    return self.shapeLayer.lineJoin;
}

-(void)setLineWidth:(CGFloat)lineWidth {
    if(self.animationDelay == 0.0f) [self _setLineWidth:@(lineWidth)];
    else [self performSelector:@selector(_setLineWidth:) withObject:@(lineWidth) afterDelay:self.animationDelay];
}
-(void)_setLineWidth:(NSNumber *)lineWidth {
    [self.shapeLayer animateLineWidth:[lineWidth floatValue]];
}
-(CGFloat)lineWidth {
    return self.shapeLayer.lineWidth;
}

-(void)setMiterLimit:(CGFloat)miterLimit {
    if(self.animationDelay == 0.0f) [self _setMiterLimit:@(miterLimit)];
    else [self performSelector:@selector(_setMiterLimit:) withObject:@(miterLimit) afterDelay:self.animationDelay];
}
-(void)_setMiterLimit:(NSNumber *)miterLimit {
    [self.shapeLayer animateMiterLimit:[miterLimit floatValue]];
}
-(CGFloat)miterLimit {
    return self.shapeLayer.miterLimit;
}

-(void)setStrokeColor:(UIColor *)strokeColor {
    if(self.animationDelay == 0.0f) [self _setStrokeColor:strokeColor];
    else [self performSelector:@selector(_setStrokeColor:) withObject:strokeColor afterDelay:self.animationDelay];
}
-(void)_setStrokeColor:(UIColor *)strokeColor {
    [self.shapeLayer animateStrokeColor:strokeColor.CGColor];
}
-(UIColor *)strokeColor {
    return [UIColor colorWithCGColor:self.shapeLayer.strokeColor];
}

-(void)setStrokeEnd:(CGFloat)strokeEnd {
    if(self.animationDelay == 0.0f ) [self _setStrokeEnd:@(strokeEnd)];
    else [self performSelector:@selector(_setStrokeEnd:) withObject:@(strokeEnd) afterDelay:self.animationDelay];
}
-(void)_setStrokeEnd:(NSNumber *)strokeEnd {
    [self.shapeLayer animateStrokeEnd:[strokeEnd floatValue]];
}
-(CGFloat)strokeEnd {
    return self.shapeLayer.strokeEnd;
}

-(void)setStrokeStart:(CGFloat)strokeStart {
    if(self.animationDelay == 0.0f) [self _setStrokeStart:@(strokeStart)];
    else [self performSelector:@selector(_setStrokeStart:) withObject:@(strokeStart) afterDelay:self.animationDelay];
}
-(void)_setStrokeStart:(NSNumber *)strokeStart {
    [self.shapeLayer animateStrokeStart:[strokeStart floatValue]];
}
-(CGFloat)strokeStart {
    return self.shapeLayer.strokeStart;
}

///* leaving out repeat count for now... it's a bit awkward */
//-(void)setRepeatCount:(CGFloat)repeatCount {
//    [super setRepeatCount:repeatCount];
//    self.shapeLayer.repeatCount = repeatCount;
//}

-(void)setup {
}

/* NOTE: YOU CAN'T HIT TEST A CGPATH which is a line */
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    event = event;
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

+(C4Shape *)defaultStyle {
    return (C4Shape *)[C4Shape appearance];
}
//-(void)setAnimationOptions:(NSUInteger)animationOptions {
//    /*
//     This method needs to be in all C4Control subclasses, not sure why it doesn't inherit properly
//     
//     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
//     i.e. reversing without having set REPEAT
//     
//     UIView animation will flicker if we don't do this...
//     */
//    ((id <C4LayerAnimation>)self.layer).animationOptions = _animationOptions;
//
//    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
//        self.shouldAutoreverse = YES;
//        animationOptions &= ~AUTOREVERSE;
//    }
//    
//    _animationOptions = animationOptions | BEGINCURRENT;
//}

-(NSDictionary *)style {
    NSDictionary *localStyle = @{
    @"fillColor":self.fillColor,
    @"fillRule":self.fillRule,
    @"lineCap": self.lineCap,
    @"lineDashPattern": self.lineDashPattern == nil ? [NSNull null] : self.lineDashPattern,
    @"lineDashPhase":@(self.lineDashPhase),
    @"lineJoin":self.lineJoin,
    @"lineWidth":@(self.lineWidth),
    @"miterLimit":@(self.miterLimit),
    @"strokeColor":self.strokeColor,
    @"strokeEnd":@(self.strokeEnd),
    @"strokeStart":@(self.strokeStart)
    };
    
    NSMutableDictionary *localAndSuperStyle = [NSMutableDictionary dictionaryWithDictionary:localStyle];
    localStyle = nil;
    
    [localAndSuperStyle addEntriesFromDictionary:[super style]];

    return (NSDictionary *)localAndSuperStyle;
}

-(void)setStyle:(NSDictionary *)style {
    [super setStyle:style];
    for(NSString *key in [style allKeys]) {
        if([_localStylePropertyNames containsObject:key]) {
            if(key == @"fillColor") {
                self.fillColor = [style objectForKey:key];
            } else if (key == @"fillRule") {
                self.fillRule = [style objectForKey:key];
            } else if (key == @"lineCap") {
                self.lineCap = [style objectForKey:key];
            } else if (key == @"lineDashPattern") {
                if([style objectForKey:key] == [NSNull null])
                    self.lineDashPattern = nil;
                else
                    self.lineDashPattern = [style objectForKey:key];
            } else if (key == @"lineDashPhase") {
                self.lineDashPhase = [[style objectForKey:key] floatValue];
            } else if(key == @"lineJoin") {
                self.lineJoin = [style valueForKey:key];
            } else if(key == @"lineWidth") {
                self.lineWidth = [[style valueForKey:key] floatValue];
            } else if (key == @"miterLimit") {
                self.miterLimit = [[style objectForKey:key] floatValue];
            } else if (key == @"strokeColor") {
                self.strokeColor = [style objectForKey:key];
            } else if (key == @"strokeEnd") {
                self.strokeEnd = [[style objectForKey:key] floatValue];
            } else if (key == @"strokeStart") {
                self.strokeStart = [[style objectForKey:key] floatValue];
            }
        }
    }
}

//-(void)path:(CGPathRef)newPath {
//    if(self.animationDelay == 0.0f) [self _path:(__bridge UIBezierPath *)newPath];
//    else [self performSelector:@selector(_path:) withObject:(__bridge UIBezierPath *)newPath afterDelay:self.animationDelay];
//}
//
//-(void)_path:(UIBezierPath *)newPath {
//    CGPathRef newCGPath = (__bridge CGPathRef)newPath;
//    [self willChangeShape];    
//    if(self.animationDuration == 0.0f) self.shapeLayer.path = newCGPath;
//    else [self.shapeLayer animatePath:newCGPath];
//    CGRect pathRect = CGPathGetBoundingBox(newCGPath);
//    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
//    CGPathRelease(newCGPath);
//    _initialized = YES;
//}

-(id)copyWithZone:(NSZone *)zone {
    C4Shape *newCopy = [[C4Shape allocWithZone:zone] initWithFrame:self.frame];
    newCopy.path = self.path;
    newCopy.style = self.style;
    return newCopy;
}
@end
