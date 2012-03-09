//
//  C4CommonMethods.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>

/** C4Notification protocol groups methods that are fundamental to basic ability for all C4 objects, visible or otherwise, to post, listen and stop listening for notifications.
 
 If an object conforms to this protocol, it has the ability to create and listen for messages which pass through the NSNotification center.
 
 The C4 Framework is built with the idea that all objects of any kind should be able to broadcast and respond to notifications, and to communicate with one another directly if necessary. All C4 objects conform to the methods defined below. 
 
 @warning *Note:* It is assumed that the object which includes this protocol is a subclass of NSObject.
 */
@protocol C4Notification <NSObject>

#pragma mark Listen Methods
/// @name Listen Methods

/** Sets up a given object to listen for a given notification, and run a specific method.
 
 This method is a basic wrapper for setting up an observer which listens for a specific notification.
 
 This method calls the addObserver:selector:name:object method of the default NotificationCenter, passing _nil_ for the object.
 
 @param notification the name of a notification for which the object should listen
 @param methodName a string which represents the name of a method defined in the object's class or any of its superclasses, this parameter should be written as a string (e.g. @"test", @"changePosition:")

 @warning *Note:* To listen for messages coming from a specific object, use listenFor:fromObject:andRunMethod 
 */
-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName;

/** Sets up a given object to listen for a given notification _from a specific object_, and runs a specific method.
 
 This method is a basic wrapper for setting up an observer which listens for a specific notification from a specified object.
 
 This method calls the addObserver:selector:name:object method of the default NotificationCenter.
 
 @param notification the name of a notification for which the object should listen
 @param object a specific object to listen to
 @param methodName a string which represents the name of a method defined in the object's class or any of its superclasses, this parameter should be written as a string (e.g. @"test", @"changePosition:")
 
 @warning *Note:* To listen for messages coming from a specific object, use listenFor:fromObject:andRunMethod 
 */
-(void)listenFor:(NSString *)notification fromObject:(id)object andRunMethod:(NSString *)methodName;

/** Stops an object from listening for a given notification.
 
 This method is a basic wrapper for removing an observer from the notification center.
 
 This method calls the removeObserver:name:object: method of the default notification center, passing nil for the object.
 
 @param methodName the name of a notification for which the object should stop listening
 */
-(void)stopListeningFor:(NSString *)methodName;

/** Stops an object from listening for a given notification which originates from a specific object.
 
 This method is a basic wrapper for removing an observer from the notification center.
 
 This method calls the removeObserver:name:object: method of the default notification center passing a specific object.
 
 @param methodName the name of a notification for which the object should stop listening
 @param object the object for which to stop listening
 */
-(void)stopListeningFor:(NSString *)methodName object:(id)object;

#pragma mark Broadcast Methods
/// @name Broadcast Methods

/** Creates a notification with a given string and posts it to the default notification center.
  
 This method calls the postNotification:object: method of the default notification center passing a itself as the object.
 
 @param notification the name of a notification to be broadcast
 */
-(void)postNotification:(NSString *)notification;

@end
