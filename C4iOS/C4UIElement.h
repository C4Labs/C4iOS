//
//  C4UIElement.h
//  C4iOS
//
//  Created by moi on 13-02-28.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>
/** C4UIElement protocol groups methods that are fundamental to basic interaction user interface objects in C4.
 
 If an object conforms to this protocol that object can trigger methods associated with various control events.
 */
@protocol C4UIElement <NSObject>
///@name User Interface Methods
/**Attaches a method to a specific control event for the receiver.
 
 You may call this method multiple times, and you may specify multiple target-action pairs for a particular event. The action message may optionally include the sender and the event as parameters, in that order.
 
 When you call this method, target is not retained.
 
 @methodName A string-version of a selector (i.e. the name of a method) identifying an action message. It cannot be NULL.
 @param object The target object—that is, the object from which the method is run. If this is nil, the responder chain is searched for an object willing to respond to the action message.
 @event A bitmask specifying the control events for which the action message is sent. See “Control Events” for bitmask constants.
 */
-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event;

/**Removes a target and action for a particular event (or events) from an internal dispatch table.
 
 @methodName A string-version of a selector (i.e. the name of a method) identifying an action message. It cannot be NULL.
 @param object The target object—that is, the object from which the method is run. Pass nil to remove all targets paired with action and the specified control events.
 @event A bitmask specifying the control events for which the action message is sent. See “Control Events” for bitmask constants.
 */
-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event;
@end
