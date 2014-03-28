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
+ (void)handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...;

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
+ (void)handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format, ...;

@end
