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

#import "C4Object.h"

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
+ (CGFloat)distanceBetweenA:(CGPoint)pointA andB:(CGPoint)pointB;

/**Calculates the angle between two coordinates
 
 @param pointA The first point
 @param pointB The second point
 @return An angle value, measured in radians, between pointA and pointB
 */
+ (CGFloat)angleBetweenA:(CGPoint)pointA andB:(CGPoint)pointB;

/**Creates and returns a new C4Vector object.
 
 @param x The x coordinate of the vector
 @param y The y coordinate of the vector
 @param z The z coordinate of the vector
 @return A new C4Vector object
 */
+ (instancetype)vectorWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

/**Initializes a new C4Vector object.
 
 @param x The x coordinate of the vector
 @param y The y coordinate of the vector
 @param z The z coordinate of the vector
 */
- (id)initWithX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

/**Sets all three coordinate values of a vector.
 
 @param x The x coordinate of the vector
 @param y The y coordinate of the vector
 @param z The z coordinate of the vector
 */
- (void)setX:(CGFloat)x Y:(CGFloat)y Z:(CGFloat)z;

/**Adds the value of a specified vector to the receiver.
 
 @param aVec The vector whose coordinate values will be added to the receiver.
 */
- (void)add:(C4Vector *)aVec;

/**Subtracts the value of a specified vector's coordinates from those of the receiver.
 
 @param aVec The vector whose coordinate values will be subtracted from those of the receiver.
 */
- (void)subtract:(C4Vector *)aVec;

/**Multiplies the value of the receiver's coordinates by those of the specified vector.
 
 @param aVec The vector whose coordinate values will be used to multiply those of the receiver.
 */
- (void)multiply:(C4Vector *)aVec;

/**Divides the value of the receiver's coordinates by those of the specified vector.
 
 @param aVec The vector whose coordinate values will be used to divide from those of the receiver.
 */
- (void)divide:(C4Vector *)aVec;

/**Adds a scalar value to the coordinates of the receiver.
 
 @param scalar The value to which will be added to the coordinates of the receiver.
 */
- (void)addScalar:(CGFloat)scalar;

/**Subtracts a scalar value from the coordinates of the receiver.
 
 @param scalar The scalar value that will be subtracted from the coordinates of the receiver.
 */
- (void)subtractScalar:(CGFloat)scalar;

/**Multiplies the values of the coordinates of the receiver by a scalar.
 
 @param scalar The value that will be used to multiply those of the receiver.
 */
- (void)multiplyByScalar:(CGFloat)scalar;

/**Divides the values of the coordinates of the receiver by a scalar.
 
 @param scalar The value that will be used to divide from those of the receiver.
 */
- (void)divideByScalar:(CGFloat)scalar;

/**Calculates the distance between the receiver and a specified vector.
 
 @param aVec the vector to which the distance will be calculated from the receiver.
 @return A distance value, measured in points, between the receiver and aVec
 */
- (CGFloat)distance:(C4Vector *)aVec;

/**Calculates the dot product of the reciever with a specified vector.
 
 @param aVec the vector that will be used to calculate the dot product of the receiver.
 @return A float value which is the dot product of the receiver and aVec
 */
- (CGFloat)dot:(C4Vector *)aVec;

/**Calculates the angle between the receiver and a specified coordinate
 
 @param aVec The point against which the receiver's angle will be calculated
 @return An angle value, measured in radians, between pointA and pointB
 */
- (CGFloat)angleBetween:(C4Vector *)aVec;

/**Calculates the cross product of the reciever with a specified vector.
 
 @param aVec the vector that will be used to calculate the cross product of the receiver
 @return A float value which is the cross product of the receiver and aVec
 */
- (void)cross:(C4Vector *)aVec;

/**Normalizes the receiver's coordinates
 */
- (void)normalize;

/**Calculates the heading of a vector based on a 2-dimensional coordinate.
 
 @param p The point used to determine the receiver's heading.
 @return A float value representing the heading of the receiver.
 */
- (CGFloat)headingBasedOn:(CGPoint)p;

#pragma mark Properties
///@name Properties

/**The x-coordinate of the vector.
 */
@property(nonatomic) CGFloat x;

/**The y-coordinate of the vector.
 */
@property(nonatomic) CGFloat y;

/**The z-coordinate of the vector.
 */
@property(nonatomic) CGFloat z;

/**The magnitude of the vector.
 
 sqrt(x*x+y*y+z*z)
 */
@property(nonatomic, readonly) CGFloat magnitude;

/**Returns the heading of a vector based on {0,0}.
 */
@property(nonatomic, readonly) CGFloat heading;

/**Returns the 2-dimensional coordinate of a vector.
 */
@property(nonatomic, readonly) CGPoint CGPoint;
@end
