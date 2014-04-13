// Copyright © 2012 Travis Kirton
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import "C4AnimationHelper.h"
#import "C4Shape.h"
#import "C4UIShapeControl.h"

@interface C4Shape()
@property(nonatomic, readonly) BOOL initialized, shouldClose;
@property(nonatomic, readonly, copy) NSArray *localStylePropertyNames;
@end

@implementation C4Shape {
    CGPoint _pointA;
    CGPoint _pointB;
}

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithView:[[C4UIShapeControl alloc] initWithFrame:frame]];
    if(self != nil) {
        _initialized = NO;
        self.animationOptions = BEGINCURRENT | EASEINOUT;
        [self setup];
    }
    return self;
}

-(void)willChangeShape {
    _arc = NO;
    _line = NO;
    _bezierCurve = NO;
    _quadCurve = NO;
    _closed = NO;
    _shouldClose = NO;
}

+ (instancetype)ellipse:(CGRect)rect {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:rect];
    [newShape _ellipse:[NSValue valueWithCGRect:rect]];
    return newShape;
}

+ (instancetype)rect:(CGRect)rect {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:rect];
    [newShape _rect:[NSValue valueWithCGRect:rect]];
    return newShape;
}

+ (instancetype)line:(CGPoint *)pointArray {
    CGRect lineFrame = CGRectMakeFromPointArray(pointArray, 2);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:lineFrame];
    [newShape _line:@[[NSValue valueWithCGPoint:pointArray[0]],
                      [NSValue valueWithCGPoint:pointArray[1]]]];
    return newShape;
}

+ (instancetype)triangle:(CGPoint *)pointArray {
    CGRect polygonFrame = CGRectMakeFromPointArray(pointArray, 3);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:polygonFrame];
    [newShape _triangle:@[[NSValue valueWithCGPoint:pointArray[0]],
                          [NSValue valueWithCGPoint:pointArray[1]],
                          [NSValue valueWithCGPoint:pointArray[2]]]];
    return newShape;
}

+ (instancetype)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount {
    CGRect polygonFrame = CGRectMakeFromPointArray(pointArray, (int)pointCount);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:polygonFrame];
    NSMutableArray *points = [@[] mutableCopy];
    for(int i = 0; i < pointCount; i++) {
        [points addObject:[NSValue valueWithCGPoint:pointArray[i]]];
    }
    [newShape _polygon:points];
    return newShape;
}

+ (instancetype)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    //I'm not sure what's going on here, but i have to invert clockwise to get the
    CGRect arcRect = CGRectMakeFromArcComponents(centerPoint,radius,startAngle,endAngle,!clockwise);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:arcRect];
    
    NSDictionary *arcDict = @{@"centerPoint":[NSValue valueWithCGPoint:centerPoint],
                              @"radius":@(radius),
                              @"startAngle":@(startAngle),
                              @"endAngle":@(endAngle),
                              @"clockwise":@(clockwise)};
    [newShape _arc:arcDict];
    return newShape;
}

+ (instancetype)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    CGRect wedgeRect = CGRectMakeFromWedgeComponents(centerPoint,radius,startAngle,endAngle,clockwise);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:wedgeRect];
    
    NSDictionary *wedgeDict = @{@"centerPoint":[NSValue valueWithCGPoint:centerPoint],
                                @"radius":@(radius),
                                @"startAngle":@(startAngle),
                                @"endAngle":@(endAngle),
                                @"clockwise":@(clockwise)};
    [newShape _wedge:wedgeDict];
    return newShape;
}
+ (instancetype)shapeFromString:(NSString *)string withFont:(C4Font *)font {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    NSDictionary *stringAndFontDictionary = @{@"string": string,@"font": font};
    [newShape _shapeFromString:stringAndFontDictionary];
    return newShape;
}

+ (instancetype)shapeFromTemplate:(C4Template*)template {
    C4Shape *shape = [[C4Shape alloc] init];
    [shape applyTemplate:template];
    return shape;
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
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
    CGPathRelease(newPath);
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    self.origin = newFrame.origin;
    _initialized = YES;
}

-(void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    NSDictionary *arcDict = @{@"centerPoint":[NSValue valueWithCGPoint:centerPoint],
                              @"radius":@(radius),
                              @"startAngle":@(startAngle),
                              @"endAngle":@(endAngle),
                              @"clockwise":@(clockwise)};
    if(self.animationDelay == 0.0f) [self _arc:arcDict];
    else [self performSelector:@selector(_arc:) withObject:arcDict afterDelay:self.animationDelay];
}

-(void)_arc:(NSDictionary *)arcDict {
    [self willChangeShape];
    _arc = YES;
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
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)translatedPath];
    CGPathRelease(translatedPath);
    _initialized = YES;
}

-(void)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    NSDictionary *wedgeDict = @{@"centerPoint":[NSValue valueWithCGPoint:centerPoint],
                                @"radius":@(radius),
                                @"startAngle":@(startAngle),
                                @"endAngle":@(endAngle),
                                @"clockwise":@(clockwise)};
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
    
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)translatedPath];
    CGPathRelease(translatedPath);
    _initialized = YES;
}

+ (instancetype)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray{
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectMakeFromPointArray(beginEndPointArray, 2)];
    NSMutableDictionary *curveDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[0]] forKey:@"beginPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[1]] forKey:@"endPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[0]] forKey:@"controlPoint1"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[1]] forKey:@"controlPoint2"];
    [newShape _curve:curveDict];
    return newShape;
}

+ (instancetype)quadCurve:(CGPoint *)beginEndPointArray controlPoint:(CGPoint)controlPoint{
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
    
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
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
    
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
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
    
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
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
    CGAffineTransform afft = CGAffineTransformMakeScale(1, -1);
    CGMutablePathRef glyphPaths = CGPathCreateMutable();
    CGPathMoveToPoint(glyphPaths, nil, 0, 0);
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, nil);
    
    CGPoint currentOrigin = CGPointZero;
    for(int i = 0; i < string.length; i++) {
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
    
    CGRect pathRect = CGPathGetBoundingBox(glyphPaths);
    const CGAffineTransform translate = CGAffineTransformMakeTranslation(-pathRect.origin.x,-pathRect.origin.y);
    
    CGMutablePathRef transFormedGlyphPaths = CGPathCreateMutableCopyByTransformingPath(glyphPaths, &translate);
    
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)transFormedGlyphPaths];
    pathRect.origin = CGPointZero;
    self.frame = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    _initialized = YES;
    
    CFRelease(ctFont);
    CGPathRelease(glyphPaths);
    CGPathRelease(transFormedGlyphPaths);
}

-(void)line:(CGPoint *)pointArray {
    NSArray *linePointArray = @[[NSValue valueWithCGPoint:pointArray[0]],[NSValue valueWithCGPoint:pointArray[1]]];
    [self _line:linePointArray];
}
-(void)_line:(NSArray *)pointArray {
    [self willChangeShape];
    _line = YES;
    _closed = YES;
    
    CGPoint points[2];
    
    points[0] = [pointArray[0] CGPointValue];
    points[1] = [pointArray[1] CGPointValue];
    
    _pointA = points[0];
    _pointB = points[1];
    
    CGRect lineRect = CGRectMakeFromPointArray(points, 2);
    self.frame = lineRect;
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
    
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)triangle:(CGPoint *)pointArray {
    NSArray *trianglePointArray = @[[NSValue valueWithCGPoint:pointArray[0]],
                                    [NSValue valueWithCGPoint:pointArray[1]],
                                    [NSValue valueWithCGPoint:pointArray[2]]];
    [self _triangle:trianglePointArray];
}

-(void)_triangle:(NSArray *)pointArray {
    [self willChangeShape];
    //create a c-array of points
    NSInteger pointCount = [pointArray count];
    CGPoint points[pointCount];
    
    for (int i = 0; i < pointCount; i++) {
        points[i] = [pointArray[i] CGPointValue];
    }
    
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, points[0].x, points[0].y);
    for(int i = 1; i < pointCount; i++) {
        CGPathAddLineToPoint(newPath, nil, points[i].x, points[i].y);
    }
    
    //the only difference between this and _arc
    CGPathCloseSubpath(newPath);
    _closed = YES;
    
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
//    self.origin = self.frame.origin;
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
    CGFloat animDur = self.animationDuration;
    self.animationDuration = 0;
    self.origin = pathRect.origin;
    self.animationDuration = animDur;
    
    CGPathRelease(newPath);
    _initialized = YES;
}
/*
 CGFloat xOrigin = [C4Math minOfA:trianglePoints[0].x B:trianglePoints[1].x C:trianglePoints[2].x];
 
 CGFloat yOrigin = [C4Math minOfA:trianglePoints[0].y B:trianglePoints[1].y C:trianglePoints[2].y];
 
 triangleFrame = CGRectMake(xOrigin, yOrigin, triangle.bounds.size.width, triangle.bounds.size.height);
 
 [triangle setFrame:triangleFrame]; */

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
    [self _polygon:points];
}

-(void)_polygon:(NSArray *)pointArray {
    [self willChangeShape];
    //create a c-array of points
    NSInteger pointCount = [pointArray count];
    CGPoint points[pointCount];
    
    for (int i = 0; i < pointCount; i++) {
        points[i] = [pointArray[i] CGPointValue];
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
    
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
    CGRect pathRect = CGPathGetBoundingBox(newPath);
    self.bounds = pathRect; //Need this step to sync the appearance of the paths to the frame of the shape
//    _origin = self.frame.origin;
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)closeShape {
    _shouldClose = YES;
    if(self.animationDelay == 0.0f) [self _closeShape];
    else [self performSelector:@selector(_closeShape) withObject:nil afterDelay:self.animationDelay];
}
-(void)_closeShape {
    if(_initialized == YES && _shouldClose == YES && _closed == NO) {
        CGMutablePathRef newPath = CGPathCreateMutableCopy(self.path);
        CGPathCloseSubpath(newPath);
        [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
        CGPathRelease(newPath);
        _closed = YES;
    }
}

-(CGPathRef)path {
    return ((CAShapeLayer*)self.view.layer).path;
}


-(void)setPath:(CGPathRef)newPath {
    CGRect oldRect = self.view.frame;
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
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
    [self.animationHelper animateKeyPath:@"fillColor" toValue:(__bridge id)fillColor.CGColor];
}

-(UIColor *)fillColor {
    return [UIColor colorWithCGColor:self.shapeLayer.fillColor];
}

-(void)setFillRule:(NSString *)fillRule {
    [self.animationHelper animateKeyPath:@"fillRule" toValue:fillRule];
}

-(NSString *)fillRule {
    return self.shapeLayer.fillRule;
}

-(void)setLineCap:(NSString *)lineCap {
    [self.animationHelper animateKeyPath:@"lineCap" toValue:lineCap];
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
    self.shapeLayer.lineDashPattern = lineDashPattern == (NSArray *)[NSNull null] ? nil : lineDashPattern;
}

-(NSArray *)lineDashPattern {
    return self.shapeLayer.lineDashPattern;
}

-(void)setLineDashPhase:(CGFloat)lineDashPhase {
    [self.animationHelper animateKeyPath:@"lineDashPhase" toValue:@(lineDashPhase)];
}

-(CGFloat)lineDashPhase {
    return self.shapeLayer.lineDashPhase;
}

-(void)setLineJoin:(NSString *)lineJoin {
    [self.animationHelper animateKeyPath:@"lineJoin" toValue:lineJoin];
}

-(NSString *)lineJoin {
    return self.shapeLayer.lineJoin;
}

-(CGFloat)lineWidth {
    return self.shapeLayer.lineWidth;
}

-(void)setLineWidth:(CGFloat)lineWidth {
    [self.animationHelper animateKeyPath:@"lineWidth" toValue:@(lineWidth)];
}

- (CGFloat)miterLimit {
    return self.shapeLayer.miterLimit;
}

-(void)setMiterLimit:(CGFloat)miterLimit {
    [self.animationHelper animateKeyPath:@"miterLimit" toValue:@(miterLimit)];
}

-(void)setStrokeColor:(UIColor *)strokeColor {
    [self.animationHelper animateKeyPath:@"strokeColor" toValue:(__bridge id)strokeColor.CGColor];
}

-(UIColor *)strokeColor {
    return [UIColor colorWithCGColor:self.shapeLayer.strokeColor];
}

-(void)setStrokeEnd:(CGFloat)strokeEnd {
    [self.animationHelper animateKeyPath:@"strokeEnd" toValue:@(strokeEnd)];
}

-(CGFloat)strokeEnd {
    return self.shapeLayer.strokeEnd;
}

-(void)setStrokeStart:(CGFloat)strokeStart {
    [self.animationHelper animateKeyPath:@"strokeStart" toValue:@(strokeStart)];
}

-(CGFloat)strokeStart {
    return self.shapeLayer.strokeStart;
}

/* NOTE: YOU CAN'T HIT TEST A CGPATH which is a line */
-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    event = event;
    if (_line == YES) return NO;
    return CGPathContainsPoint(self.shapeLayer.path, nil, point, nil) ? YES : NO;
}

- (CAShapeLayer*)shapeLayer {
    return (CAShapeLayer*)self.view.layer;
}

#pragma mark Templates

+ (C4Template *)defaultTemplate {
    static C4Template* template;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        template = [C4Template templateFromBaseTemplate:[super defaultTemplate] forClass:self];
    });
    return template;
}

@end
