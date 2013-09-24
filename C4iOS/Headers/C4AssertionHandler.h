//
//  C4AssertionHandler.h
//  C4iOS
//
//  Created by Travis Kirton on 12-07-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>

/** This document describes a class that overrides NSAssertionHandler.
 *
 *  The methods listed in this document are used for better formatting logged messages for asserts and exceptions.
 */

@interface C4AssertionHandler : NSAssertionHandler
/** Logs (using C4Log) an error message that includes the name of the function, the name of the file, and the line number.

 Raises NSInternalInconsistencyException.

 -(void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...
 
 @param functionName The function that failed.
 @param fileName The name of the source file.
 @param line The line in which the failure occurred.
 @param format A format string followed by a comma-separated list of arguments to substitute into the format string. See Formatting String Objects for more information.
 @param ... The variables for the format string
 */
-(void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...;

/** Logs (using C4Log) an error message that includes the name of the method that failed, the class name of the object, the name of the source file, and the line number.
 
 Raises NSInternalInconsistencyException.
 
 -(void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...
 
 @param selector The selector for the method that failed The function that failed.
 @param object The object that failed.
 @param fileName The name of the source file.
 @param line The line in which the failure occurred.
 @param format A format string followed by a comma-separated list of arguments to substitute into the format string. See Formatting String Objects for more information.
 @param ... The variables for the format string
 */
-(void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...;

@end
