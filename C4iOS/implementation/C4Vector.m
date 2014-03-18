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
-(void)update;
@end

@implementation C4Vector {
    float vec3[3];
    CGFloat pVec3[3];
    float *vec;
    CGFloat pDisplacedHeading;
}

@synthesize x, y, z, magnitude, heading, displacedHeading;
@synthesize CGPoint;

+(CGFloat)distanceBetweenA:(CGPoint)pointA andB:(CGPoint)pointB {
    __block CGFloat value;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        C4Vector *a = [C4Vector vectorWithX:pointA.x Y:pointA.y Z:0];
        C4Vector *b = [C4Vector vectorWithX:pointB.x Y:pointB.y Z:0];
        value = [a distance:b];
    });
    return value;
}

+(CGFloat)angleBetweenA:(CGPoint)pointA andB:(CGPoint)pointB {
    __block CGFloat value;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        C4Vector *a = [C4Vector vectorWithX:pointA.x Y:pointA.y Z:0];
        C4Vector *b = [C4Vector vectorWithX:pointB.x Y:pointB.y Z:0];
        value =  [a angleBetween:b];
    });
    return value;
}

+(C4Vector *)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z {
    C4Vector *v = [[C4Vector alloc] initWithX:x Y:y Z:z];
	return v;
}

-(id)initWithX:(CGFloat)_x Y:(CGFloat)_y Z:(CGFloat)_z {
    self = [super init];
	if(self != nil) {
        vec3[0] = _x;
        vec3[1] = _y;
        vec3[2] = _z;
        
        pVec3[0] = 0;
        pVec3[1] = 0;
        pVec3[2] = 0;
        
        pDisplacedHeading = 0;
        [self setup];
	}
	return self;
}

-(void)update {
    pVec3[0] = vec3[0];
    pVec3[1] = vec3[1];
    pVec3[2] = vec3[2];
}

-(void)setX:(CGFloat)_x Y:(CGFloat)_y Z:(CGFloat)_z {
    [self update];
	vec3[0] = _x;
	vec3[1] = _y;
	vec3[2] = _z;
}

-(void)setX:(CGFloat)newX {
    pVec3[0] = vec3[0];
    vec3[0] = newX;
}

-(void)setY:(CGFloat)newY {
    pVec3[1] = vec3[1];
    vec3[1] = newY;
}

-(void)setZ:(CGFloat)newZ {
    pVec3[2] = vec3[2];
    vec3[2] = newZ;
}

-(CGFloat)x {
	return vec3[0];
}

-(CGFloat)y {
	return vec3[1];
}

-(CGFloat)z {
	return vec3[2];
}

-(void)add:(C4Vector *)aVec {
    [self update];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        vDSP_vadd(vec3, 1, aVec.vec, 1, vec3, 1, 3);
    });
}

-(void)addScalar:(float)scalar {
    [self update];
    float *s = &scalar;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        vDSP_vsadd(vec3, 1, s, vec3, 1, 3);
    });
}

-(void)divide:(C4Vector *)aVec {
    [self update];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        vDSP_vdiv(aVec.vec, 1, vec3, 1, vec3, 1, 3);
    });
}

-(void)divideScalar:(float)scalar {
    [self update];
    float *s = &scalar;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        vDSP_vsdiv(vec3, 1, s, vec3, 1, 3);
    });
}

-(void)multiply:(C4Vector *)aVec {
    [self update];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        vDSP_vmul(vec3, 1, aVec.vec, 1, vec3, 1, 3);
    });
}

-(void)multiplyScalar:(float)scalar {
    [self update];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        vDSP_vsmul(vec3, 1, &scalar, vec3, 1, 3);
    });
}

-(void)subtract:(C4Vector *)aVec {
    [self update];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        vDSP_vsub(vec3, 1, aVec.vec, 1, vec3, 1, 3);
    });
}

-(void)subtractScalar:(float)scalar {
    [self update];
	[self addScalar:-1*scalar];
}

-(CGFloat)distance:(C4Vector *)aVec {
    __block CGFloat value;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        value = (CGFloat)sqrt(pow(vec3[0]-(aVec.vec)[0], 2)+pow(vec3[1]-(aVec.vec)[1], 2)+pow(vec3[2]-(aVec.vec)[2], 2));
    });
    return value;
}

-(CGFloat)dot:(C4Vector *)aVec {
    __block CGFloat value;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        value = (CGFloat)cblas_sdot(3, vec3, 1, aVec.vec, 1);
    });
    return value;
}

-(CGFloat)magnitude {
    __block CGFloat value;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        value = (CGFloat)sqrt(pow(vec3[0], 2)+pow(vec3[1], 2)+pow(vec3[2], 2));
    });
    return value;
}

-(CGFloat)angleBetween:(C4Vector *)aVec {
    __block CGFloat value;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        float dotProduct = [self dot:aVec];
        float cosTheta = dotProduct/([self magnitude]*[aVec magnitude]);
        value = acosf(cosTheta);
    });
    return value;
}

-(void)cross:(C4Vector *)aVec {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        float newVec[3];
        newVec[0] = vec3[1]*(aVec.vec)[2] - vec3[2]*(aVec.vec)[1];
        newVec[1] = vec3[2]*(aVec.vec)[0] - vec3[0]*(aVec.vec)[2];
        newVec[2] = vec3[0]*(aVec.vec)[1] - vec3[1]*(aVec.vec)[0];
        vec3[0] = newVec[0];
        vec3[1] = newVec[1];
        vec3[2] = newVec[2];
    });
}

-(void)normalize {
	[self limit:1.0f];
}

-(void)limit:(CGFloat)max {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        cblas_sscal(3, max/cblas_snrm2(3, vec3, 1), vec3, 1);
    });
}

-(CGPoint)CGPoint {
	return CGPointMake(vec3[0], vec3[1]);
}

-(CGFloat)heading {
    __block CGFloat value;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        CGFloat angle = [C4Math atan2Y:vec3[1] X:vec3[0]]; //always against 0
        value = angle;
    });
    return value;
}

-(CGFloat)displacedHeading {
    if([self distance:[C4Vector vectorWithX:pVec3[0] Y:pVec3[1] Z:pVec3[2]]] > .5) {
        __block CGFloat value;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_sync(queue, ^(void) {
            CGFloat angle = [C4Math atan2Y:vec3[1]-pVec3[1] X:vec3[0]-pVec3[0]]; //always against 0
            value = angle;
        });
        pDisplacedHeading = value;
    }
    return pDisplacedHeading;
}

-(CGFloat)headingBasedOn:(CGPoint)p {
    __block CGFloat value;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_sync(queue, ^(void) {
        CGFloat angle = [C4Math atan2Y:(vec3[1]-p.y) X:(vec3[0]-p.x)]; //always against 0
        value = angle;
    });
    return value;
}

-(float*)vec {
	return vec3;
}

-(NSString *)description {
	return [NSString stringWithFormat:@"vec(%4.2f,%4.2f,%4.2f)",vec3[0],vec3[1],vec3[2]];
}
@end
