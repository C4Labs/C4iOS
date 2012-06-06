//
//  C4Timer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-06-05.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Object.h"

@interface C4Timer : C4Object

+(C4Timer *)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats;
+(C4Timer *)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)object repeats:(BOOL)repeats;
+(C4Timer *)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats;
+(C4Timer *)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)object repeats:(BOOL)repeats;
+(C4Timer *)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats;
+(C4Timer *)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)target method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;

-(void)fire;
-(void)start;
-(void)stop;

@property (readonly, nonatomic) BOOL isValid;
@property (readwrite, nonatomic, weak) NSDate *fireDate;
@property (readonly, nonatomic) CGFloat timeInterval;
@property (readonly, nonatomic, weak) id userInfo;

@end