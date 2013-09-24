//
//  C4Vector.h
//  vectors
//
//  Created by Travis Kirton on 12-05-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"
#import <Accelerate/Accelerate.h>

/**The C4Vector class is a basic system used for coordinate values and direction vectors.
 
 C4Vector wraps the vDSP and cblas portions of the Accelerate framework. The vDSP header provides a number of functions related to digital signal processing, including vector and matrix arithmetic. The cblas header contains interfaces for Apple’s implementation of the Basic Linear Algebra Subprograms (BLAS) API.
 
 For More Information
 Documentation on the BLAS standard, including reference implementations, can be found on the web starting from the BLAS FAQ page at these URLs (verified live as of July 2005): http://www.netlib.org/blas/faq.html and http://www.netlib.org/blas/blast-forum/blast-forum.html
 
 */
@interface C4Vector : C4Object

/**Calculates the distance between two coordinates.
 
 @param pointA The first point
 @param pointB The second point
 @return A distance value, measured in points, between pointA and pointB
 */
+(CGFloat)distanceBetweenA:(CGPoint)pointA andB:(CGPoint)pointB;

/**Calculates the angle between two coordinates
 
 @param pointA The first point
 @param pointB The second point
 @return An angle value, measured in radians, between pointA and pointB
 */
+(CGFloat)angleBetweenA:(CGPoint)pointA andB:(CGPoint)pointB;

/**Creates and returns a new C4Vector object.
 
 @param x The x coordinate of the vector
 @param y The y coordinate of the vector
 @param z The z coordinate of the vector
 @return A new C4Vector object
 */
+(C4Vector *)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

/**Initializes a new C4Vector object.
 
 @param x The x coordinate of the vector
 @param y The y coordinate of the vector
 @param z The z coordinate of the vector
 */
-(id)initWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

/**Sets all three coordinate values of a vector.
 
 @param x The x coordinate of the vector
 @param y The y coordinate of the vector
 @param z The z coordinate of the vector
 */
-(void)setX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

/**Adds the value of a specified vector to the receiver.
 
 @param aVec The vector whose coordinate values will be added to the receiver.
 */
-(void)add:(C4Vector *)aVec;

/**Adds a scalar value to the coordinates of the receiver.
 
 @param scalar The value to which will be added to the coordinates of the receiver.
 */
-(void)addScalar:(float)scalar;

/**Divides the value of the receiver's coordinates by those of the specified vector.
 
 @param aVec The vector whose coordinate values will be used to divide from those of the receiver.
 */
-(void)divide:(C4Vector *)aVec;

/**Divides the values of the coordinates of the receiver by a scalar.
 
 @param scalar The value that will be used to divide from those of the receiver.
 */
-(void)divideScalar:(float)scalar;

/**Multiplies the value of the receiver's coordinates by those of the specified vector.
 
 @param aVec The vector whose coordinate values will be used to multiply those of the receiver.
 */
-(void)multiply:(C4Vector *)aVec;

/**Multiplies the values of the coordinates of the receiver by a scalar.
 
 @param scalar The value that will be used to multiply those of the receiver.
 */
-(void)multiplyScalar:(float)scalar;

/**Subtracts the value of a specified vector's coordinates from those of the receiver.
 
 @param aVec The vector whose coordinate values will be subtracted from those of the receiver.
 */
-(void)subtract:(C4Vector *)aVec;

/**Subtracts a scalar value from the coordinates of the receiver.
 
 @param scalar The scalar value that will be subtracted from the coordinates of the receiver.
 */
-(void)subtractScalar:(float)scalar;

/**Calculates the distance between the receiver and a specified vector.
 
 @param aVec the vector to which the distance will be calculated from the receiver.
 @return A distance value, measured in points, between the receiver and aVec
 */
-(CGFloat)distance:(C4Vector *)aVec;

/**Calculates the dot product of the reciever with a specified vector.
 
 @param aVec the vector that will be used to calculate the dot product of the receiver.
 @return A float value which is the dot product of the receiver and aVec
 */
-(CGFloat)dot:(C4Vector *)aVec;

/**Calculates the angle between the receiver and a specified coordinate
 
 @param aVec The point against which the receiver's angle will be calculated
 @return An angle value, measured in radians, between pointA and pointB
 */
-(CGFloat)angleBetween:(C4Vector *)aVec;

/**Calculates the cross product of the reciever with a specified vector.
 
 @param aVec the vector that will be used to calculate the cross product of the receiver
 @return A float value which is the cross product of the receiver and aVec
 */
-(void)cross:(C4Vector *)aVec;

/**Normalizes the receiver's coordinates
 */
-(void)normalize;

/**Limits the receiver's coordinates.
 
 @param max The maximum value possible for each coordinate.
 */
-(void)limit:(CGFloat)max;

/**Calculates the heading of a vector based on a 2-dimensional coordinate.
 
 @param p The point used to determine the receiver's heading.
 @return A float value representing the heading of the receiver.
 */
-(CGFloat)headingBasedOn:(CGPoint)p;

#pragma mark Properties
///@name Properties

/**An array of variables representing the coordinates of the vector.
 */
@property (readonly) float *vec;

/**The x-coordinate of the vector.
 */
@property (readwrite, nonatomic) CGFloat x;

/**The y-coordinate of the vector.
 */
@property (readwrite, nonatomic) CGFloat y;

/**The z-coordinate of the vector.
 */
@property (readwrite, nonatomic) CGFloat z;

/**The magnitude of the vector.
 
 sqrt(x*x+y*y+z*z)
 */
@property (readonly, nonatomic) CGFloat magnitude;

/**Returns the heading of a vector based on {0,0}.
 */
@property (readonly, nonatomic) CGFloat heading;

/**Returns the displaced heading of a vector based on {0,0}.
 */
@property (readonly, nonatomic) CGFloat displacedHeading;

/**Returns the 2-dimensional coordinate of a vector.
 */
@property (readonly, nonatomic) CGPoint CGPoint;
@end
