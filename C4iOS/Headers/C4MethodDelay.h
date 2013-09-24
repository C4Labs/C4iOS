//
//  C4MethodDelay.h
//  C4iOS
//
//  Created by Travis Kirton on 12-06-05.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

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
