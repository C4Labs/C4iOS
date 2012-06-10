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
@end

@interface C4Shape()
-(void)_ellipse:(NSValue *)ellipseValue;
-(void)_rect:(NSValue *)rectValue;
-(void)_line:(NSArray *)pointArray;
-(void)_triangle:(NSArray *)pointArray;
-(void)_polygon:(NSArray *)pointArray;
-(void)_arc:(NSDictionary *)arcDict;
-(void)_curve:(NSDictionary *)curveDict;
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
-(void)_setShadowColor:(UIColor *)_shadowColor;
-(void)_setStrokeColor:(UIColor *)_strokeColor;
-(void)_setStrokeStart:(NSNumber *)_strokeStart;
-(void)_setShadowOffSet:(NSValue *)_shadowOffset;
-(void)_setShadowOpacity:(NSNumber *)_shadowOpacity;
-(void)_setShadowPath:(id)shadowPath;
-(void)_setShadowRadius:(NSNumber *)_shadowRadius;

@property (atomic) BOOL isTriangle;
@end

@implementation C4Shape
@synthesize isLine =_isLine, shapeLayer, pointA = _pointA, pointB = _pointB;
@synthesize fillColor, fillRule, lineCap, lineDashPattern, lineDashPhase, lineJoin, lineWidth, miterLimit, origin = _origin, strokeColor, strokeEnd, strokeStart, shadowOffset, shadowOpacity, shadowRadius, shadowPath, shadowColor;
@synthesize closed = _closed, shouldClose = _shouldClose, initialized = _initialized, isTriangle = _isTriangle;

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        _isLine = NO;
        _isTriangle = NO;
        _closed = NO;
        _shouldClose = NO;
        _initialized = NO;
        [self setup];
    }
    return self;
}

+(C4Shape *)ellipse:(CGRect)rect {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:rect];
    [newShape ellipse:rect];
    return newShape;
}

+(C4Shape *)rect:(CGRect)rect {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:rect];
    [newShape rect:rect];
    return newShape;
}

+(C4Shape *)line:(CGPoint *)pointArray {
    CGRect lineFrame = CGRectMakeFromPointArray(pointArray, 2);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:lineFrame];
    [newShape line:pointArray];
    return newShape;
}

+(C4Shape *)triangle:(CGPoint *)pointArray {
    CGRect polygonFrame = CGRectMakeFromPointArray(pointArray, 3);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:polygonFrame];
    [newShape triangle:pointArray];
    return newShape;
}

+(C4Shape *)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount {
    CGRect polygonFrame = CGRectMakeFromPointArray(pointArray, pointCount);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:polygonFrame];
    [newShape polygon:pointArray pointCount:pointCount];
    return newShape;
}

+(C4Shape *)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise {
    //I'm not sure what's going on here, but i have to invert clockwise to get the 
    CGRect arcRect = CGRectMakeFromArcComponents(centerPoint,radius,startAngle,endAngle,!clockwise);
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:arcRect];
    [newShape arcWithCenter:centerPoint radius:radius startAngle:startAngle endAngle:endAngle clockwise:!clockwise];
    return newShape;
}

+(C4Shape *)shapeFromString:(NSString *)string withFont:(C4Font *)font {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [newShape shapeFromString:string withFont:font];
    return newShape;
}

/* the technique in both the following methods allows me to change the shape of a shape and change the shape of their view's frame automatically */
-(void)ellipse:(CGRect)rect {
    [self performSelector:@selector(_ellipse:) withObject:[NSValue valueWithCGRect:rect] afterDelay:self.animationDelay];
}

-(void)_ellipse:(NSValue *)ellipseValue {
    C4Log(@"_ellipse");
    _isLine = NO;
    _closed = YES;
    CGRect aRect = [ellipseValue CGRectValue];
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathAddEllipseInRect(newPath, nil, aRect);
    [self.shapeLayer animatePath:newPath];
    CGPathRelease(newPath);
}

-(void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise{
    NSMutableDictionary *arcDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [arcDict setValue:[NSValue valueWithCGPoint:centerPoint] forKey:@"centerPoint"];
    [arcDict setObject:[NSNumber numberWithFloat:radius] forKey:@"radius"];
    [arcDict setObject:[NSNumber numberWithFloat:startAngle] forKey:@"startAngle"];
    [arcDict setObject:[NSNumber numberWithFloat:endAngle] forKey:@"endAngle"];
    [arcDict setObject:[NSNumber numberWithBool:clockwise] forKey:@"clockwise"];
    [self performSelector:@selector(_arc:) withObject:arcDict afterDelay:self.animationDelay];
}

-(void)_arc:(NSDictionary *)arcDict {
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPoint centerPoint = [[arcDict valueForKey:@"centerPoint"] CGPointValue];
    CGPathAddArc(newPath, nil, centerPoint.x, centerPoint.y, [[arcDict objectForKey:@"radius"] floatValue], [[arcDict objectForKey:@"startAngle"] floatValue], [[arcDict objectForKey:@"endAngle"] floatValue], [[arcDict objectForKey:@"clockwise"] boolValue]);
    CGRect arcRect = CGPathGetBoundingBox(newPath);
    const CGAffineTransform translation = CGAffineTransformMakeTranslation(arcRect.origin.x *-1, arcRect.origin.y *-1);
    CGMutablePathRef translatedPath = CGPathCreateMutableCopyByTransformingPath(newPath, &translation);
    CGPathRelease(newPath);
    
    [self.shapeLayer animatePath:translatedPath];
    if (_shouldClose == YES) {
        CGPathCloseSubpath(newPath);
    }
    CGPathRelease(translatedPath);
    _initialized = YES;
}

+(C4Shape *)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray{
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:CGRectZero];
    [newShape curve:beginEndPointArray controlPoints:controlPointArray];
    return newShape;
}
-(void)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray{
    NSMutableDictionary *curveDict = [[NSMutableDictionary alloc] initWithCapacity:0];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[0]] forKey:@"beginPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:beginEndPointArray[1]] forKey:@"endPoint"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[0]] forKey:@"controlPoint1"];
    [curveDict setValue:[NSValue valueWithCGPoint:controlPointArray[1]] forKey:@"controlPoint2"];
    [self _curve:curveDict];
}
-(void)_curve:(NSDictionary *)curveDict{
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPoint beginPoint = [[curveDict valueForKey:@"beginPoint"] CGPointValue];
    CGPoint endPoint = [[curveDict valueForKey:@"endPoint"] CGPointValue];
    CGPoint controlPoint1 = [[curveDict valueForKey:@"controlPoint1"] CGPointValue];
    CGPoint controlPoint2 = [[curveDict valueForKey:@"controlPoint2"] CGPointValue];
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
    // not sure why the following doesn't affect curves the same way it affects other shapes 
    // (i.e. by not allowing .center to be set during setup{})
    self.frame = tempFrame; 
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)rect:(CGRect)rect {
    [self performSelector:@selector(_rect:) withObject:[NSValue valueWithCGRect:rect] afterDelay:self.animationDelay];
}

-(void)_rect:(NSValue *)rectValue {
    _isLine = NO;
    _closed = YES;
    CGRect aRect = [rectValue CGRectValue];
    aRect.origin = CGPointZero;
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathAddRect(newPath, nil, aRect);
    [self.shapeLayer animatePath:newPath];
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)shapeFromString:(NSString *)string withFont:(C4Font *)font {
    NSDictionary *stringAndFontDictionary = [NSDictionary dictionaryWithObjectsAndKeys:string,@"string",font,@"font", nil];
    [self performSelector:@selector(_shapeFromString:) withObject:stringAndFontDictionary];
}

-(void)_shapeFromString:(NSDictionary *)stringAndFontDictionary {
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
    _closed = YES;
}
-(void)line:(CGPoint *)pointArray {
    [self performSelector:@selector(_line:) withObject:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:pointArray[0]],[NSValue valueWithCGPoint:pointArray[1]], nil] afterDelay:self.animationDelay];
}
-(void)_line:(NSArray *)pointArray {
    _isLine = YES;
    _closed = YES;

    NSInteger pointCount = [pointArray count];
    CGPoint points[pointCount];
    
    for (int i = 0; i < pointCount; i++) {
        points[i] = [[pointArray objectAtIndex:i] CGPointValue];
    }

    CGRect lineRect = CGRectMakeFromPointArray(points, 2);
    CGPoint translation = lineRect.origin;
    translation.x *= -1;
    translation.y *= -1;
    
    for(int i = 0; i < 2; i++) {
        points[i].x += translation.x;
        points[i].y += translation.y;
    }
    
    _pointA = CGPointMake(points[0].x, points[0].y);
    _pointB = CGPointMake(points[1].x, points[1].y);
        
    CGMutablePathRef newPath = CGPathCreateMutable();
    CGPathMoveToPoint(newPath, nil, points[0].x, points[0].y);
    for(int i = 1; i < pointCount; i++) {
        CGPathAddLineToPoint(newPath, nil, points[i].x, points[i].y);
    }
    
    if (_isTriangle == YES && _closed == NO) {
        CGPathCloseSubpath(newPath);
        _closed = YES;
    }

    
    [self.shapeLayer animatePath:newPath];
    CGRect newBounds = self.bounds;
    newBounds.origin = CGPointZero;
    self.bounds = newBounds;
    self.backgroundColor = [UIColor lightGrayColor];
    CGPathRelease(newPath);
    _initialized = YES;
}

-(void)triangle:(CGPoint *)pointArray {
    [self performSelector:@selector(_triangle:) withObject:[NSArray arrayWithObjects:[NSValue valueWithCGPoint:pointArray[0]],[NSValue valueWithCGPoint:pointArray[1]],[NSValue valueWithCGPoint:pointArray[2]], nil] afterDelay:self.animationDelay];
}
-(void)_triangle:(NSArray *)pointArray {
    _isLine = NO;
    _isTriangle = YES;
    _shouldClose = YES;
    [self _polygon:pointArray];
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
    [self performSelector:@selector(_polygon:) withObject:points afterDelay:self.animationDelay];
}

-(void)_polygon:(NSArray *)pointArray {
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
    }
    [self.shapeLayer animatePath:newPath];
    CGPathRelease(newPath);
    _initialized = YES;

}

-(void)closeShape {
    _shouldClose = YES;
    if(_initialized == YES) {
        [self performSelector:@selector(_closeShape) withObject:nil afterDelay:self.animationDelay];
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
    if (self.isLine == YES) {
        return _pointA;
    }
    return CGPointZero;
}

-(CGPoint)pointB {
    if (self.isLine == YES) {
        return _pointB;
    }
    return CGPointZero;
}

-(void)test {
}

-(void)setPointA:(CGPoint)pointA {
    /* there should be some option to deal with points in lines if the view has already been transformed */
    if(self.isLine == YES) {
        _pointA = pointA;
        CGPoint points[2] = {_pointA, _pointB};
        [self line:points];
    }
}

-(void)setPointB:(CGPoint)pointB {
    if(self.isLine == YES) {
        _pointB = pointB;
        CGPoint points[2] = {_pointA, _pointB};
        [self line:points];
    }
}

-(void)setOrigin:(CGPoint)origin {
    _origin = origin;
    CGPoint difference = self.origin;
    difference.x += self.frame.size.width/2.0f;
    difference.y += self.frame.size.height/2.0f;
    self.center = difference;
}

-(void)setFillColor:(UIColor *)_fillColor {
    [self performSelector:@selector(_setFillColor:) withObject:_fillColor afterDelay:self.animationDelay];
}
-(void)_setFillColor:(UIColor *)_fillColor {
    [self.shapeLayer animateFillColor:_fillColor.CGColor];
}
-(UIColor *)fillColor {
    return [UIColor colorWithCGColor:self.shapeLayer.fillColor];
}

-(void)setFillRule:(NSString *)_fillRule {
    [self performSelector:@selector(_setFillRule:) withObject:_fillRule afterDelay:self.animationDelay];
}
-(void)_setFillRule:(NSString *)_fillRule {
    self.shapeLayer.fillRule = _fillRule;
}
-(NSString *)fillRule {
    return self.shapeLayer.fillRule;
}

-(void)setLineCap:(NSString *)_lineCap {
    [self performSelector:@selector(_setLineCap:) withObject:_lineCap afterDelay:self.animationDelay];
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
    [self performSelector:@selector(_setLineDashPattern:) withObject:patternArray afterDelay:self.animationDelay];
    patternArray = nil;
}

-(void)setLineDashPattern:(NSArray *)_lineDashPattern {
    [self performSelector:@selector(_setLineDashPattern:) withObject:_lineDashPattern afterDelay:self.animationDelay];
}
-(void)_setLineDashPattern:(NSArray *)_lineDashPattern {
    self.shapeLayer.lineDashPattern = _lineDashPattern;
}
-(NSArray *)lineDashPattern {
    return self.shapeLayer.lineDashPattern;
}

-(void)setLineDashPhase:(CGFloat)_lineDashPhase {
    [self performSelector:@selector(_setLineDashPhase:) withObject:[NSNumber numberWithFloat:_lineDashPhase] afterDelay:self.animationDelay];
}
-(void)_setLineDashPhase:(NSNumber *)_lineDashPhase {
    self.shapeLayer.lineDashPhase = [_lineDashPhase floatValue];
}
-(CGFloat)lineDashPhase {
    return self.shapeLayer.lineDashPhase;
}

-(void)setLineJoin:(NSString *)_lineJoin {
    [self performSelector:@selector(_setLineJoin:) withObject:_lineJoin afterDelay:self.animationDelay];
}
-(void)_setLineJoin:(NSString *)_lineJoin {
    self.shapeLayer.lineJoin = _lineJoin;
}
-(NSString *)lineJoin {
    return self.shapeLayer.lineJoin;
}

-(void)setLineWidth:(CGFloat)_lineWidth {
    [self performSelector:@selector(_setLineWidth:) withObject:[NSNumber numberWithFloat:_lineWidth] afterDelay:self.animationDelay];
}
-(void)_setLineWidth:(NSNumber *)_lineWidth {
    [self.shapeLayer animateLineWidth:[_lineWidth floatValue]];
}
-(CGFloat)lineWidth {
    return self.shapeLayer.lineWidth;
}

-(void)setMiterLimit:(CGFloat)_miterLimit {
    [self performSelector:@selector(_setMiterLimit:) withObject:[NSNumber numberWithFloat:_miterLimit] afterDelay:self.animationDelay];
}
-(void)_setMiterLimit:(NSNumber *)_miterLimit {
    [self.shapeLayer animateMiterLimit:[_miterLimit floatValue]];
}
-(CGFloat)miterLimit {
    return self.shapeLayer.miterLimit;
}

-(void)setStrokeColor:(UIColor *)_strokeColor {
    [self performSelector:@selector(_setStrokeColor:) withObject:_strokeColor afterDelay:self.animationDelay];
}
-(void)_setStrokeColor:(UIColor *)_strokeColor {
    [self.shapeLayer animateStrokeColor:_strokeColor.CGColor];
}
-(UIColor *)strokeColor {
    return [UIColor colorWithCGColor:self.shapeLayer.strokeColor];
}

-(void)setStrokeEnd:(CGFloat)_strokeEnd {
    [self performSelector:@selector(_setStrokeEnd:) withObject:[NSNumber numberWithFloat:_strokeEnd] afterDelay:self.animationDelay];
}
-(void)_setStrokeEnd:(NSNumber *)_strokeEnd {
    [self.shapeLayer animateStrokeEnd:[_strokeEnd floatValue]];
}
-(CGFloat)strokeEnd {
    return self.shapeLayer.strokeEnd;
}

-(void)setStrokeStart:(CGFloat)_strokeStart {
    [self performSelector:@selector(_setStrokeStart:) withObject:[NSNumber numberWithFloat:_strokeStart] afterDelay:self.animationDelay];
}
-(void)_setStrokeStart:(NSNumber *)_strokeStart {
    [self.shapeLayer animateStrokeStart:[_strokeStart floatValue]];
}
-(CGFloat)strokeStart {
    return self.shapeLayer.strokeStart;
}

-(void)setShadowColor:(UIColor *)_shadowColor {
    [self performSelector:@selector(_setShadowColor:) withObject:_shadowColor afterDelay:self.animationDelay];
}
-(void)_setShadowColor:(UIColor *)_shadowColor {
    [self.shapeLayer animateShadowColor:_shadowColor.CGColor];
}
-(UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.shapeLayer.shadowColor];
}

-(void)setShadowOffset:(CGSize)_shadowOffset {
    [self performSelector:@selector(_setShadowOffSet:) withObject:[NSValue valueWithCGSize:_shadowOffset] afterDelay:self.animationDelay];
}
-(void)_setShadowOffSet:(NSValue *)_shadowOffset {
    [self.shapeLayer animateShadowOffset:[_shadowOffset CGSizeValue]];
}
-(CGSize)shadowOffset {
    return self.shapeLayer.shadowOffset;
}

-(void)setShadowOpacity:(CGFloat)_shadowOpacity {
    [self performSelector:@selector(_setShadowOpacity:) withObject:[NSNumber numberWithFloat:_shadowOpacity] afterDelay:self.animationDelay];
}
-(void)_setShadowOpacity:(NSNumber *)_shadowOpacity {
    [self.shapeLayer animateShadowOpacity:[_shadowOpacity floatValue]];
}
-(CGFloat)shadowOpacity {
    return self.shapeLayer.shadowOpacity;
}

-(void)setShadowPath:(CGPathRef)_shadowPath {
    [self performSelector:@selector(_setShadowPath:) withObject:(__bridge id)_shadowPath afterDelay:self.animationDelay];
}
-(void)_setShadowPath:(id)_shadowPath {
    [self.shapeLayer animateShadowPath:(__bridge CGPathRef)_shadowPath];
}
-(CGPathRef)shadowPath {
    return self.shapeLayer.shadowPath;
}

-(void)setShadowRadius:(CGFloat)_shadowRadius {
    [self performSelector:@selector(_setShadowRadius:) withObject:[NSNumber numberWithFloat:_shadowRadius] afterDelay:self.animationDelay];
}
-(void)_setShadowRadius:(NSNumber *)_shadowRadius {
    [self.shapeLayer animateShadowRadius:[_shadowRadius floatValue]];
}
-(CGFloat)shadowRadius {
    return self.shapeLayer.shadowRadius;
}

-(void)setAnimationDuration:(CGFloat)animationDuration {
    [super setAnimationDuration:animationDuration];
    self.shapeLayer.animationDuration = animationDuration;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    [super setAnimationOptions:animationOptions];
    self.shapeLayer.animationOptions = animationOptions;
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

@end
