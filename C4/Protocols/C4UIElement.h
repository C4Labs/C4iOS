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
/** C4UIElement protocol groups methods that are fundamental to basic interaction user interface objects in C4.
 
 If an object conforms to this protocol that object can trigger methods associated with various control events.
 */
@protocol C4UIElement <NSObject>
///@name User Interface Methods
/**Attaches a method to a specific control event for the receiver.
 
 You may call this method multiple times, and you may specify multiple target-action pairs for a particular event. The action message may optionally include the sender and the event as parameters, in that order.
 
 When you call this method, target is not retained.
 
 @param methodName A string-version of a selector (i.e. the name of a method) identifying an action message. It cannot be NULL.
 @param object The target object—that is, the object from which the method is run. If this is nil, the responder chain is searched for an object willing to respond to the action message.
 @param event A bitmask specifying the control events for which the action message is sent. See “Control Events” for bitmask constants.
 */
-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event;

/**Removes a target and action for a particular event (or events) from an internal dispatch table.
 
 @param methodName A string-version of a selector (i.e. the name of a method) identifying an action message. It cannot be NULL.
 @param object The target object—that is, the object from which the method is run. Pass nil to remove all targets paired with action and the specified control events.
 @param event A bitmask specifying the control events for which the action message is sent. See “Control Events” for bitmask constants.
 */
-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event;
@end
