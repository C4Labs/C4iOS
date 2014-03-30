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

#import "C4Vector.h"

@interface C4Vector ()
@end

@implementation C4Vector {
    CGFloat _x, _y, _z;
}

+ (CGFloat)distanceBetweenA:(CGPoint)pointA andB:(CGPoint)pointB {
    C4Vector *a = [C4Vector vectorWithX:pointA.x Y:pointA.y Z:0];
    C4Vector *b = [C4Vector vectorWithX:pointB.x Y:pointB.y Z:0];
    return [a distance:b];
}

+ (CGFloat)angleBetweenA:(CGPoint)pointA andB:(CGPoint)pointB {
    C4Vector *a = [C4Vector vectorWithX:pointA.x Y:pointA.y Z:0];
    C4Vector *b = [C4Vector vectorWithX:pointB.x Y:pointB.y Z:0];
    return [a angleBetween:b];
}

+ (instancetype)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
    return [[C4Vector alloc] initWithX:x Y:y Z:z];
}

- (id)initWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
    self = [super init];
    if (self != nil) {
        _x = x;
        _y = y;
        _z = z;
    }
    return self;
}

- (void)setX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
    _x = x;
    _y = y;
    _z = z;
}

- (CGFloat)x {
    return _x;
}

- (CGFloat)y {
    return _y;
}

- (CGFloat)z {
    return _z;
}

- (void)setX:(CGFloat)newX {
    _x = newX;
}

- (void)setY:(CGFloat)newY {
    _y = newY;
}

- (void)setZ:(CGFloat)newZ {
    _z = newZ;
}

- (void)add:(C4Vector *)v {
    _x += v->_x;
    _y += v->_y;
    _z += v->_z;
}

- (void)subtract:(C4Vector *)v {
    _x -= v->_x;
    _y -= v->_y;
    _z -= v->_z;
}

- (void)multiply:(C4Vector *)v {
    _x *= v->_x;
    _y *= v->_y;
    _z *= v->_z;
}

- (void)divide:(C4Vector *)v {
    _x /= v->_x;
    _y /= v->_y;
    _z /= v->_z;
}

- (void)addScalar:(CGFloat)scalar {
    _x += scalar;
    _y += scalar;
    _z += scalar;
}

- (void)subtractScalar:(CGFloat)scalar {
    _x -= scalar;
    _y -= scalar;
    _z -= scalar;
}

- (void)multiplyByScalar:(CGFloat)scalar {
    _x *= scalar;
    _y *= scalar;
    _z *= scalar;
}

- (void)divideByScalar:(CGFloat)scalar {
    _x /= scalar;
    _y /= scalar;
    _z /= scalar;
}

- (CGFloat)distance:(C4Vector *)v {
    CGFloat dx = v->_x - _x;
    CGFloat dy = v->_y - _y;
    CGFloat dz = v->_z - _z;
    return (CGFloat)sqrt(dx*dx + dy*dy + dz*dz);
}

- (CGFloat)dot:(C4Vector *)v {
    return _x * v->_x + _y * v->_y + _z * v->_z;
}

- (CGFloat)magnitude {
    return (CGFloat)sqrt(_x*_x + _y*_y + _z*_z);
}

- (CGFloat)angleBetween:(C4Vector *)v {
    CGFloat dotProduct = [self dot:v];
    CGFloat cosTheta = dotProduct/([self magnitude]*[v magnitude]);
    return acosf(cosTheta);
}

- (void)cross:(C4Vector *)v {
    CGFloat newVec[3];
    newVec[0] = _y*v.z - _z*v.y;
    newVec[1] = _z*v.x - _x*v.z;
    newVec[2] = _x*v.y - _y*v.x;
    _x = newVec[0];
    _y = newVec[1];
    _z = newVec[2];
}

- (void)normalize {
    [self divideByScalar:[self magnitude]];
}

- (CGPoint)CGPoint {
    return CGPointMake(_x, _y);
}

- (CGFloat)heading {
    return [C4Math atan2Y:_y X:_x]; //always against 0
}

- (CGFloat)headingBasedOn:(CGPoint)p {
    __block CGFloat value;
        CGFloat angle = [C4Math atan2Y:(_y-p.y) X:(_x-p.x)]; //always against 0
        value = angle;
    return value;
}

-(NSString *)description {
    return [NSString stringWithFormat:@"vec(%4.2f,%4.2f,%4.2f)",_x,_y,_z];
}

@end
