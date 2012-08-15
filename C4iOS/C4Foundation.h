//
//  C4Foundation.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

/** This document describes a set of basic functions that are available to use throughout the C4 framework.
 *  
 *  This methods listed in this document are used for sorting, comparing, and most importantly logging messages to the console.
 */

@interface C4Foundation : NSObject {
    NSComparator floatSortComparator;
}

/// @name Foundation Methods
#pragma mark Foundation Methods

+(C4Foundation *)sharedManager;

/** Logs an error message to the console.
 
 Takes a string and a list of arguments, formats it into an NSString and then prints it to the console by calling fprintf
 
 In general, this function is formatted without the added information that NSLog provides. However, you could use the NSLog function instead of calling this function directly.
 */
void C4Log(NSString *logString,...);

/** Returns a pre-defined comparator for sorting float values.
 */
+(NSComparator)floatComparator;

/** Returns a pre-defined comparator for sorting float values.
 */
-(NSComparator)floatComparator;

/** Sorts two undefined objects.
 
 Takes two undefined objects (i.e. cast as id) and determines their class kinds. It then sorts the two based on the kinds of objects that they are. 
 
 This method can deal with strings, floats and NSNumbers. This method defaults to sorting by float value.
 
 */
NSInteger   basicSort(id obj1, id obj2, void *context);

#pragma mark New Stuff
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

@end
