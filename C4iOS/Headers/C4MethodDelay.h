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

/** The C4MethodDelay protocol defines two methods that can be used to trigger other methods after a specified amount of time.
 
 If an object conforms to this protocol, it has the ability to trigger its own methods after a specified time.
 */
@protocol C4MethodDelay <NSObject>

/** Sends a specified message to the receiver after a specified amount of time.
 
 It is assumed that the object calling this method has another method called *methodName* to run. If not, it will crash.
 
 This method wraps -(void)performSelector:(SEL)aSelector from the NSObject Protocol Reference
 
 @param methodName The name of the method to run
 @param seconds The amount of time to wait, in seconds, before running the specified method
 */
-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds;

/** Sends a message to the receiver with an object as the argument after a specific amount of time.
 
 This method wraps -(void)performSelector:(SEL)aSelector withObject:(id)object from the NSObject Protocol Reference
 
 @param methodName The name of the method to run
 @param object An object that is the sole argument of the message.
 @param seconds The amount of time to wait, in seconds, before running the specified method
 */
-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds;
@end
