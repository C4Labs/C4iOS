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

#import "C4Object.h"

/** This document describes the C4Timer, a subclass of C4Object which contains an NSTimer.
 
 This class acts as a wrapper for NSTimer, providing extra functionality of starting, stoping and firing the timer. It also provides easy access to the timer's interval and its userInfo object.
 */

@interface C4Timer : C4Object
#pragma mark - Creating a Timer
///@name Creating a Timer
/**Creates and returns a new C4Timer object that will begin firing automatically.
 
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+ (instancetype)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing automatically, it will also pass an object to the method it triggers.
 
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param infoObject The object to pass to the method being called
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+ (instancetype)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing automatically.
 
 You will need to explicitly start this timer.
 
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+ (instancetype)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing automatically, it will also pass an object to the method it triggers.
 
 You will need to explicitly start this timer.
 
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param infoObject The object to pass to the method being called
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+ (instancetype)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing at a specified date.
 
 @param date An NSDate object stating when the timer will begin firing
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+ (instancetype)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing at a specified date, it will also pass an object to the method it triggers.
 
 @param date An NSDate object stating when the timer will begin firing
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param infoObject The object to pass to the method being called
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+ (instancetype)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;

#pragma mark - Firing a Timer
///@name Firing a Timer
/**Causes the receiver’s message to be sent to its target.
 
 You can use this method to fire a repeating timer without interrupting its regular firing schedule. If the timer is non-repeating, it is automatically invalidated after firing, even if its scheduled fire date has not arrived.
 */
-(void)fire;
#pragma mark - Starting & Stopping a Timer
///@name Starting & Stopping a Timer
/**Calling this method will start the timer firing, if it is supposed to repeat it will continue to fire.
 
 This method creates a new instance of an NSTimer, based on the stored properties in the reciever, and starts firing immediately.
 */
-(void)start;

/**Calling this method will stop a timer from firing continuously.
 
 This method effectively invalidates the timer.
 */
-(void)stop;

/**Stops the receiver from ever firing again and requests its removal from its run loop.
 
 This method is the only way to remove a timer from an NSRunLoop object. The NSRunLoop object removes and releases the timer, either just before the invalidate method returns or at some later point.
 
 If it was configured with target and user info objects, the receiver releases its references to those objects as well.
 */
-(void)invalidate;
#pragma mark - Information About a Timer
///@name Information About a Timer

/**Returns a Boolean value that indicates whether the receiver is currently valid.
 
 @return YES if the receiver is still capable of firing or NO if the timer has been invalidated and is no longer capable of firing.
 */
@property(nonatomic, readonly) BOOL isValid;

/**Returns the date at which the receiver will fire.
 
 You can use this property to adjust the firing time of a repeating timer. Although resetting a timer’s next firing time is a relatively expensive operation, it may be more efficient in some situations. For example, you could use it in situations where you want to repeat an action multiple times in the future, but at irregular time intervals. Adjusting the firing time of a single timer would likely incur less expense than creating multiple timer objects, scheduling each one on a run loop, and then destroying them.
 
 You can pass this property a new NSDate object. If the new date is in the past, this method sets the fire time to the current time.
 
 @return The date at which the receiver will fire. If the timer is no longer valid, this method returns the last date at which the timer fired.
 */
@property(nonatomic, strong) NSDate *fireDate;

/**Returns the receiver’s time interval.
 
 The receiver’s time interval. If the receiver is a non-repeating timer, returns 0 (even if a time interval was set).
 */
@property(nonatomic, readonly) CGFloat timeInterval;

/**Returns the receiver's userInfo object. The userInfo is the object that will be passed to the method the timer is targeting.
 
 Do not invoke this method after the timer is invalidated. Use isValid to test whether the timer is valid.
 */
@property(nonatomic, readonly) id userInfo;

@end