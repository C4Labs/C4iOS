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
#import "C4Shape_Private.h"
#import "C4UIShapeControl.h"

NSString* const C4ShapeTypeKey = @"type";


@interface C4Shape()
@property(nonatomic, readonly, copy) NSArray *localStylePropertyNames;
@end

@implementation C4Shape

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

+ (instancetype)rect:(CGRect)rect {
    C4Shape *newShape = [[C4Shape alloc] initWithFrame:rect];
    [newShape rect:rect];
    return newShape;
}

+ (instancetype)shapeFromTemplate:(C4Template*)template {
    C4Shape *shape = [[C4Shape alloc] init];
    [shape applyTemplate:template];
    return shape;
}

- (void)rect:(CGRect)rect {
    self.frame = rect;
    
    rect.origin.x = 0;
    rect.origin.y = 0;
    CGPathRef path = CGPathCreateWithRect(rect, nil);
    self.path = path;
    CGPathRelease(path);
}

- (CGPathRef)path {
    return ((CAShapeLayer*)self.view.layer).path;
}

- (void)setPath:(CGPathRef)newPath {
    ((CAShapeLayer*)self.view.layer).path = newPath;
    [self.animationHelper animateKeyPath:@"path" toValue:(__bridge id)newPath];
    CGRect bounds = CGPathGetBoundingBox(newPath);
    self.frame = bounds;
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

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return CGPathContainsPoint(self.shapeLayer.path, nil, point, nil);
}

- (CAShapeLayer*)shapeLayer {
    return (CAShapeLayer*)self.view.layer;
}

-(void)closeShape {
    if(_initialized == YES) {
        CGMutablePathRef newPath = CGPathCreateMutableCopy(self.path);
        CGPathCloseSubpath(newPath);
        self.path = newPath;
        CGPathRelease(newPath);
    }
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
