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

/** This document describes the mathematic methods and functions available in the C4 Framework.
 
 The C4Math class is a singleton, and does not need to be initialized.
 
 Many of the methods in the C4Math are wrappers for other simple function calls, such as the abs: and absf: methods which only return the values calculated by abs() and absf()... Other methods wrap more complicated calculations.
 
 The reason for simply wrapping functions within a method is to be consistent with other method calls, and to create a cleaner API.
 */

@interface C4Math : C4Object

#pragma mark Arithmetic
/// @Arithmetic
/** Computes the absolute value of an integer number
 
 @param value The number to be converted to its absolute value
 @return NSInteger returns the positive whole (integer), if the given number is a floating-point the method first converts it to an integer
 */
+(NSInteger)abs:(NSInteger)value;

/** Computes the absolute value of a floating-point number
 
 @param value The float number to be converted to its absolute value
 @return NSInteger returns the positive floating-point value of a given number
 */
+(CGFloat)absf:(CGFloat)value;

/** Rounds a floating-point value
 @param value The number for which to calculate ceil:
 @return NSInteger returns the smallest whole number no less than _value_
 */
+(NSInteger)ceil:(CGFloat)value;

/** Constrains a number to a given range of integer values
 
 This method makes sure a number falls within a given range of values, and converts it if it lies outside that range
 
 @param value The number to constrain
 @param min The smallest possible number in the range
 @param max The largest possible number in the range
 @return NSInteger Either _min_ or _max_ if the given number lies outside the range (e.g. if _value_ is less than _min_ this method returns _min_), otherwise this method returns _value_ (unchanged)
 */
+(NSInteger)constrain:(NSInteger)value min:(NSInteger)min max:(NSInteger)max;

/** Constrains a number to a given range of floating-point values
 
 This method makes sure a number falls within a given range of values, and converts it if it lies outside that range
 
 @param value The number to constrain
 @param min The smallest possible number in the range
 @param max The largest possible number in the range
 @return CGFloat Either _min_ or _max_ if the given number lies outside the range (e.g. if _value_ is less than _min_ this method returns _min_), otherwise this method returns _value_ (unchanged)
 */
+(CGFloat)constrainf:(CGFloat)value min:(CGFloat)min max:(CGFloat)max;

/** The natural exponential function
 
 Raises the mathematical constant e to the power of a given value [for more details](http://en.wikipedia.org/wiki/Exponential_function)
 
 @param value The value to use in the exponential function.
 
 @return CGFloat Returns the calucation of of e ^ _value_
 */
+(CGFloat)exp:(CGFloat)value;

/** Rounds a floating-point value
 
 @param value The number to round up
 @return NSInteger returns the largest whole number no greater than _value_
 */
+(NSInteger)floor:(CGFloat)value;

/** Calculates the linear interpolation of a value between two numbers
 
 Example: lerpBetweenA:0.0 B:1.0 byAmount:0.8 should return 0.8
 Example: lerpBetweenA:1.0 B:2.0 byAmount:0.8 should return 1.8
 Example: lerpBetweenA:0.0 B:2.0 byAmount:0.8 should return 1.6
 
 @param a the first value
 @param b the second value
 @param amount floating-point value (should be between 0.0 and 1.0) as a measure of relative distance between the two points
 @return CGFloat the floating point value of a number between _a_ and _b_ which is _amount_ point between those two numbers
 */
+(CGFloat)lerpBetweenA:(CGFloat)a B:(CGFloat)b byAmount:(CGFloat)amount;

/**Calculates the natural logarithm of a given value
 @param value The number to which to apply the logarithm equation
 @return CGFloat The natural logartihm of a given floating-point value
 */
+(CGFloat)log:(CGFloat)value;

/** Takes a value within a given range of numbers, and converts it to a relative value between another set of numbers.
 
 This method takes a _value_ which is within the range of _min1_ and _max1_ and maps it to a new relative value which is between _min2_ and _max2_
 
 Example: map:25 fromMin:0 max:100 toMin:0 max:200 returns 50
 Example: map:50 fromMin:0 max:100 toMin:0 max:200 returns 100
 
 @param value The number to map (should be between _min1_ and _max1_)
 @param min1 The smallest number in the original range
 @param max1 The largest number in the original range
 @param min2 The smallest number in the new range
 @param max2 The largest number in the new range
 @return CGFloat Either _min_ or _max_ if the given number lies outside the range (e.g. if _value_ is less than _min_ this method returns _min_), otherwise this method returns _value_ (unchanged)
 */
+(CGFloat)map:(CGFloat)value fromMin:(CGFloat)min1 max:(CGFloat)max1 toMin:(CGFloat)min2 max:(CGFloat)max2;

/**Calculates the larger value of two given numbers
 
 @param a A given number to compare
 @param b A given number to compare
 
 @return CGFlaot the larger value of _a_ and _b_
 */
+(CGFloat)maxOfA:(CGFloat)a B:(CGFloat)b;

/**Calculates the larger of three given numbers
 
 @param a A given number to compare
 @param b A given number to compare
 @param c A given number to compare
 @return CGFlaot the larger of _a_, _b_ and _c_
 */
+(CGFloat)maxOfA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c;

/**Calculates the smaller value of two given numbers
 
 @param a A given number to compare
 @param b A given number to compare
 @return CGFlaot the smaller value of _a_ and _b_
 */
+(CGFloat)minOfA:(CGFloat)a B:(CGFloat)b;

/**Calculates the smaller value of three given numbers
 
 @param a A given number to compare
 @param b A given number to compare
 @param c A given number to compare
 @return CGFlaot the smaller value of _a_, _b_ and _c_
 */
+(CGFloat)minOfA:(CGFloat)a B:(CGFloat)b C:(CGFloat)c;


/**Unused
 
 @param value -
 @param min -
 @param max -
 @return CGFloat returns 0
 */
+(CGFloat)norm:(CGFloat)value fromMin:(CGFloat)min toMax:(CGFloat)max;

/**Calculates the value of a number raised to a given degree
 
 Example: pow:3 raisedTo:2 = 3 * 3 = 9
 Example: pow:2 raisedTo:3 = 2 * 2 * 2 = 8
 
 @param value Any real floating-point value
 @param degree Any real floating-point value
 @return CGFloat The calculation of _value_ ^ _degree
 */
+(CGFloat)pow:(CGFloat)value raisedTo:(CGFloat)degree;

/** Rounds a floating-point value
 
 Example: round:0.3 = 0.0
 Example: round:0.8 = 1.0
 
 @param value The number to round
 @return NSInteger returns the closest whole number to a given _value_
 */
+(CGFloat)round:(CGFloat)value;

/**Squares a given value
 
 Raises a given value to the power of 2
 
 Example: square:3 = 3 * 3 = 4
 Example: square:2 = 2 * 2 = 4
 
 @param value The number to square
 
 @return CGFloat The result of _value_ multiplied by itself
 */
+(CGFloat)square:(CGFloat)value;

/**Calculates the square root of a given value
 
 Example: sqrt:9 = 3
 Example: square:4 = 2
 
 @param value The number to which to apply the square root
 @return CGFloat The square root of _value_
 */
+(CGFloat)sqrt:(CGFloat)value;

#pragma mark Trigonometry
/// @Trigonometry

/**Calculates the arc cosine of a given value.
 
 @param value The number for which to calculate the arccosine
 @return CGFloat A value in the range of (0..PI)
 */
+(CGFloat)acos:(CGFloat)value;

/**Calculates the arc sine of a given value.
 
 @param value The number for which to calculate the arcsine
 @return CGFloat A value in the range of (-PI/2..+PI/2)
 */
+(CGFloat)asin:(CGFloat)value;

/**Calculates the arc tangent of a single given value.
 
 @param value The number for which to calculate the arctanent
 @return CGFloat A value in the range of (-PI/2..+PI/2)
 */
+(CGFloat)atan:(CGFloat)value;

/**Calculates the arc tangent of a two given values.
 
 @param y The y value for which to calculate the arctangent2
 @param x The x value for which to calculate the arctangent2
 @return CGFloat The value of th earc tangent of y/x, using the signs of both arguments to determine the quadrant of the return value.
 */
+(CGFloat)atan2Y:(CGFloat)y X:(CGFloat)x;

/**Calculates the cosine of a value
 
 @param value The number for which to calculate the cosine
 @return CGFloat The cosine of _value_ measured in RADIANS.
 */
+(CGFloat)cos:(CGFloat)value;

/**Calculates the sine of a value
 
 @param value The number for which to calculate the sine
 @return CGFloat The sine of _value_ measured in RADIANS.
 */
+(CGFloat)sin:(CGFloat)value;

/**Calculates the tangent of a value
 
 @param value The number for which to calculate the tan
 @return CGFloat The tangent of _value_ measured in RADIANS.
 */
+(CGFloat)tan:(CGFloat)value;

#pragma mark Random
/// @Random

/**Calculates a random value
 
 @param value The highest possible random number to return
 @return NSInteger A random integer between 0 and _value_
 */
+(NSInteger)randomInt:(NSInteger)value;

/**Calculates a random value
 
 @param a The lowest possible random number to return
 @param b The highest possible random number to return
 @return NSInteger A random integer between _a_ and _b_
 */
+(NSInteger)randomIntBetweenA:(NSInteger)a andB:(NSInteger)b;

#pragma mark Math Conversion Functions
/// @Conversion

/**Converts a radian value to an equivalent in degrees
 
 @param radianValue A number specificed in radians to be converted to degrees
 @return NSInteger A integer, corresponding to the given _radianValue_
 */
NSInteger RadiansToDegrees(CGFloat radianValue);

/**Converts a degree value to an equivalent in radians
 
 @param degreeValue A number specificed in degrees to be converted to radians
 @return CGFloat A floating-point value, corresponding to the given _degreeValue_
 */
CGFloat DegreesToRadians(NSInteger degreeValue);

/**Converts a float value to an equivalent in RGB
 
 This conversion function assumes that the color coordinate space is 0 .. 1.0  which is mapped to the RGB space of 0 .. 255
 
 @param floatValue A number specificed in float (i.e. 0.0f to 1.0f) to be converted to an RGB value (i.e. 0 to 255)
 @return NSInteger A integer limited to the range (0..255), corresponding to the given _floatValue_
 */
NSInteger FloatToRGB(CGFloat floatValue);

/**Converts an integer value to an equivalent floating-point value
 
 This conversion function assumes that the color coordinate space is 0 .. 1.0  which is mapped to the RGB space of 0 .. 255
 
 @param rgbValue A number specificed in RGB value (i.e. 0 to 255) to be converted to a float (i.e. 0.0f to 1.0f)
 @return NSInteger A floating limited to the range (0.0f..1.0f), corresponding to the given _rgbValue_
 */
CGFloat RGBToFloat(NSInteger rgbValue);

@end
