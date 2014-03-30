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

/** This document describes a set of basic functions that are available to use throughout the C4 framework.
 *
 *  This methods listed in this document are used for sorting, comparing, and most importantly logging messages to the console.
 */

@interface C4Foundation : NSObject

#pragma mark Foundation Methods
/// @name Foundation Methods

/** Logs an error message to the console.
 
 Takes a string and a list of arguments, formats it into an NSString and then prints it to the console by calling fprintf
 
 In general, this function is formatted without the added information that NSLog provides. However, you could use the NSLog function instead of calling this function directly.
 */
void C4Log(NSString *logString,...);

/** Returns a pre-defined comparator for sorting float values.
 */
+(NSComparator)floatComparator;

/** Sorts two undefined objects.
 
 Takes two undefined objects (i.e. cast as id) and determines their class kinds. It then sorts the two based on the kinds of objects that they are.
 
 This method can deal with strings, floats and NSNumbers. This method defaults to sorting by float value.
 
 */
NSInteger   basicSort(id obj1, id obj2, void *context);

/** Sorts two NSString objects.
 
 Takes two string objects and sorts them using NSString's localizedStandardCompare method.
 */
NSInteger strSort(id obj1, id obj2, void *context);

/**Returns a frame that encompasses the all the points in the specified pointArray
 
 @param pointArray a c-array of CGPoint structures
 @param pointCount the number of elements in the array
 @return a CGRect structure
 */
CGRect CGRectMakeFromPointArray(CGPoint *pointArray, int pointCount);

/**Returns a frame that encompasses an arc created from the specified parameters
 
 @param centerPoint a CGPoint structure that specifies the center of the circle from which the arc will be drawn
 @param radius the radius of the circle from which the arc will be drawn
 @param startAngle the angle (in radians) to start the arc
 @param endAngle the angle (in radians) towards which the arc will be drawn
 @param clockwise the choice, YES or NO, for whether the arc will be drawn clockwise or counterclockwise
 @return a CGRect structure that encompasses the arc
 */
CGRect CGRectMakeFromArcComponents(CGPoint centerPoint, CGFloat radius, CGFloat startAngle, CGFloat endAngle, BOOL clockwise);

/**Returns a frame that encompasses a wedge created from the specified parameters
 
 @param centerPoint a CGPoint structure that specifies the center of the circle from which the wedge will be drawn
 @param radius the radius of the circle from which the wedge will be drawn
 @param startAngle the angle (in radians) to start the wedge
 @param endAngle the angle (in radians) towards which the wedge will be drawn
 @param clockwise the choice, YES or NO, for whether the wedge will be drawn clockwise or counterclockwise
 @return a CGRect structure that encompasses the wedge
 */
CGRect CGRectMakeFromWedgeComponents(CGPoint centerPoint, CGFloat radius, CGFloat startAngle, CGFloat endAngle, BOOL clockwise);

/**Returns a string that describes the current device model. For example, running this method from the simulator returns "x86_64" because the simulator is on a Macbook Pro whereas running this on an iPhone 5 returns "iPhone5,1".
 
 @return an NSString describing the current device model
 */
+(NSString *)currentDeviceModel;
@end
