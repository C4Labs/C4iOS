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
-(NSComparator)floatComparator;

/** Sorts two undefined objects.
 
 Takes two undefined objects (i.e. cast as id) and determines their class kinds. It then sorts the two based on the kinds of objects that they are. 
 
 This method can deal with strings, floats and NSNumbers. This method defaults to sorting by float value.
 
 */
NSInteger   basicSort(id obj1, id obj2, void *context);

/** Frees a given body of data.
 
 Calls free() on the given data.

 This function was taken from the book: Learning Core Audio: A Hands-On Guide to Audio Programming for Mac and iOS
 http://my.safaribooksonline.com/book/audio/9780321636973
 
 @warning *Note:* The current implementation does nothing with the _info_ and _size_ parameters. 
 
*/
void        free_data(void *info, const void *data, size_t size);

/** Checks whether an error is valid and needs printing to the console.
 
 This function was taken from the book: Learning Core Audio: A Hands-On Guide to Audio Programming for Mac and iOS
 http://my.safaribooksonline.com/book/audio/9780321636973
 
 */
void        CheckError(OSStatus error, const char *operation);

@end
