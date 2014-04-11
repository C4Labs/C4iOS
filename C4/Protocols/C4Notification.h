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

/** C4Notification protocol groups methods that are fundamental to basic ability for all C4 objects, visible or otherwise, to post, listen and stop listening for notifications.
 
 If an object conforms to this protocol, it has the ability to create and listen for messages which pass through the NSNotification center.
 
 The C4 Framework is built with the idea that all objects of any kind should be able to broadcast and respond to notifications, and to communicate with one another directly if necessary. All C4 objects conform to the methods defined below.
 
 @warning *Note:* It is assumed that the object which includes this protocol is a subclass of NSObject.
 */
@protocol C4Notification <NSObject>

typedef void (^NotificationBlock)(NSNotification *n);

///@name Notification Methods

#pragma mark Listen Methods
/** Stops an object from listening for a given notification.
 
 This method is a basic wrapper for removing an observer from the notification center.
 
 This method calls the removeObserver:name:object: method of the default notification center, passing nil for the object.
 
 @param notification the name of a notification for which the object should stop listening
 */
-(void)stopListeningFor:(NSString *)notification;

/** Stops an object from listening for a given notification which originates from a specific object.
 
 This method is a basic wrapper for removing an observer from the notification center.
 
 This method calls the removeObserver:name:object: method of the default notification center passing a specific object.
 
 @param notification the name of a notification for which the object should stop listening
 @param object the object for which to stop listening
 */
-(void)stopListeningFor:(NSString *)notification object:(id)object;

/** Stops an object from listening for a given notification which originates from a set of specific objects.
 
 This method is a basic wrapper for removing an observer from the notification center.
 
 This method calls the removeObserver:name:object: method of the default notification center passing all of the specific objects in the given array.
 
 @param notification the name of a notification for which the object should stop listening
 @param objectArray the set of objects for which to stop listening
 */
-(void)stopListeningFor:(NSString *)notification objects:(NSArray *)objectArray;

#pragma mark Broadcast Methods
/// @name Broadcast Methods

/** Creates a notification with a given string and posts it to the default notification center.
 
 This method calls the postNotification:object: method of the default notification center passing a itself as the object.
 
 @param notification the name of a notification to be broadcast
 */
-(void)postNotification:(NSString *)notification;

#pragma mark new
/** Sets up a given object to listen for a given notification, and run a specific block of code.
 
 This method is a basic wrapper for setting up an observer which listens for a specific notification.
 
 This method calls the addObserverForName:object:queue:usingBlock: method of the default NotificationCenter, passing _nil_ for the object.

 @param notification the name of a notification for which the object should listen
 @param block a block of code to execute
 
 @warning *Note:* To listen for messages coming from a specific object, use listenFor:fromObject:andRun:
 */
- (void)listenFor:(NSString *)notification andRun:(NotificationBlock)block;

/** Sets up a given object to listen for a given notification _from a specific object_, and runs a specific method.
 
 This method is a basic wrapper for setting up an observer which listens for a specific notification from a specified object.
 
 This method calls the addObserverForName:object:queue:usingBlock: method of the default NotificationCenter.
 
 @param notification the name of a notification for which the object should listen
 @param object a specific object to listen to
 @param block a block of code to execute
 
 @warning *Note:* To listen for messages coming from a specific object, use listenFor:fromObject:andRunMethod
 */
- (void)listenFor:(NSString *)notification fromObject:(id)object andRun:(NotificationBlock)block;

/** Sets up a given object to listen for a given notification _from an array of objects_, and runs a specific method.
 
 This method is a basic wrapper for setting up an observer which listens for a specific notification from a specified set of objects.
 
 This method calls the addObserver:selector:name:object method of the default NotificationCenter for all the objects in the array.
 
 @param notification the name of a notification for which the object should listen
 @param objectArray a set of objects to listen to
 @param block a block of code to execute
 */
- (void)listenFor:(NSString *)notification fromObjects:(NSArray *)objectArray andRun:(NotificationBlock)block;

@end
