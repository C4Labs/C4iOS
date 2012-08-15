//
//  C4Timer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-06-05.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"

/** This document describes the C4Timer, a subclass of C4Object which contains an NSTimer.
 
 This class acts as a wrapper for NSTimer, providing extra functionality of starting, stoping and firing the timer. It also provides easy access to the timer's interval and its userInfo object.
 */

@interface C4Timer : C4Object

/**Creates and returns a new C4Timer object that will begin firing automatically.
 
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+(C4Timer *)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing automatically, it will also pass an object to the method it triggers.
 
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param infoObject The object to pass to the method being called
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+(C4Timer *)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing automatically.
 
 You will need to explicitly start this timer.
 
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+(C4Timer *)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing automatically, it will also pass an object to the method it triggers.
 
 You will need to explicitly start this timer.

 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param infoObject The object to pass to the method being called
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+(C4Timer *)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing at a specified date.

 @param date An NSDate object stating when the timer will begin firing
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+(C4Timer *)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats;

/**Creates and returns a new C4Timer object that will begin firing at a specified date, it will also pass an object to the method it triggers.
 
 @param date An NSDate object stating when the timer will begin firing
 @param seconds The time interval for the timer
 @param object The object to which the timer will send a message
 @param methodName The name of the method that will be sent to the object
 @param infoObject The object to pass to the method being called
 @param repeats A boolean value that specifies whether or not the timer will continuously fire
 */
+(C4Timer *)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;

/**Calling this method will trigger the timer.
 */
-(void)fire;

/**Calling this method will start the timer firing, if it is supposed to repeat it will continue to fire.
 */
-(void)start;

/**Calling this method will stop a timer from firing continuously.
 */
-(void)stop;

/**A boolean value that specifies whether or not the timer is valid.
 
 A timer is valid when it has been added to the main run loop and is firing. It is invalid if it has been stopped.
 */
@property (readonly, nonatomic) BOOL isValid;

/**An NSDate specifying when the timer will fire.
 */
@property (readwrite, nonatomic, weak) NSDate *fireDate;

/**A CGFloat value, measured in seconds, for the duration of time between successive firing of a timer.
 */
@property (readonly, nonatomic) CGFloat timeInterval;

/**The object that will be passed to the method the timer is targeting.
 */
@property (readonly, nonatomic, weak) id userInfo;

@end