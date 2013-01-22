//
//  C4Timer.m
//  C4iOS
//
//  Created by Travis Kirton on 12-06-05.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Timer.h"

@interface C4Timer ()
-(id)initScheduledTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;
-(id)initWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;
-(id)initWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)target method:(NSString *)methodName userInfo:(id)userInfo repeats:(BOOL)repeats;

@property (readwrite, atomic, strong) NSTimer *timer;
@property (readwrite, nonatomic) BOOL timerCanStart;
@property (readwrite, atomic, strong) NSMutableDictionary *propertiesDictionary;
@end

@implementation C4Timer
@synthesize timer, isValid, fireDate, timeInterval, timerCanStart, userInfo;
@synthesize propertiesDictionary;

+(C4Timer *)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats {
    return [C4Timer automaticTimerWithInterval:seconds 
                                        target:object 
                                        method:methodName 
                                      userInfo:nil 
                                       repeats:repeats];
}

+(C4Timer *)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats {
    C4Timer *timer = [[C4Timer alloc] initScheduledTimerWithInterval:seconds
                                                              target:object 
                                                              method:methodName 
                                                            userInfo:infoObject 
                                                             repeats:repeats];
    return timer;
}
-(id)initScheduledTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats {
    self = [super init];
    if(self != nil) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds 
                                                      target:object 
                                                    selector:NSSelectorFromString(methodName) 
                                                    userInfo:infoObject
                                                     repeats:repeats];
        
        if (self.propertiesDictionary != nil) {
            [self.propertiesDictionary removeAllObjects];
            self.propertiesDictionary = nil;
        }
        
        self.propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        [self.propertiesDictionary setValue:@(seconds) forKey:@"seconds"];
        (self.propertiesDictionary)[@"target"] = object;
        [self.propertiesDictionary setValue:methodName forKey:@"methodName"];
        if (infoObject == nil) {
            (self.propertiesDictionary)[@"infoObject"] = [NSNull null];
        } else {
            (self.propertiesDictionary)[@"infoObject"] = infoObject;
        }
        [self.propertiesDictionary setValue:@(repeats) forKey:@"repeats"];
        
        self.timerCanStart = NO;
    }
    return self;
}

+(C4Timer *)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats {
    return [C4Timer timerWithInterval:seconds
                               target:object 
                               method:methodName
                             userInfo:nil 
                              repeats:repeats];
}

+(C4Timer *)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats {
    C4Timer *timer = [[C4Timer alloc] initWithInterval:seconds 
                                                target:object 
                                                method:methodName 
                                              userInfo:infoObject
                                               repeats:repeats];
    return timer;
}

-(id)initWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats {
    self = [super init];
    if(self != nil) {
        if([self.timer isValid]) 
            [self.timer invalidate];

        self.timer = [NSTimer timerWithTimeInterval:seconds
                                             target:object
                                           selector:NSSelectorFromString(methodName)
                                           userInfo:infoObject
                                            repeats:repeats];
        
        if (self.propertiesDictionary != nil) {
            [self.propertiesDictionary removeAllObjects];
            self.propertiesDictionary = nil;
        }
        
        self.propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        [self.propertiesDictionary setValue:@(seconds) forKey:@"seconds"];
        (self.propertiesDictionary)[@"target"] = object;
        [self.propertiesDictionary setValue:methodName forKey:@"methodName"];
        if (infoObject == nil) {
            (self.propertiesDictionary)[@"infoObject"] = [NSNull null];
        } else {
            (self.propertiesDictionary)[@"infoObject"] = infoObject;
        }
        [self.propertiesDictionary setValue:@(repeats) forKey:@"repeats"];

        self.timerCanStart = YES;
    }
    return self;
}

+(C4Timer *)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats {
    C4Timer *timer = [[C4Timer alloc] initWithFireDate:date
                                              interval:seconds
                                                target:object
                                                method:methodName
                                              userInfo:nil
                                               repeats:repeats];
    return timer;
}
+(C4Timer *)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats {
    C4Timer *timer = [[C4Timer alloc] initWithFireDate:date
                                              interval:seconds
                                                target:object
                                                method:methodName
                                              userInfo:infoObject
                                               repeats:repeats];
    return timer;
}

-(id)initWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats {
    return [self initWithFireDate:date
                         interval:seconds
                           target:object 
                           method:methodName 
                         userInfo:nil 
                          repeats:repeats];
}
-(id)initWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats {
    self = [super init];
    if(self != nil) {
        self.timer = [[NSTimer  alloc] initWithFireDate:date
                                               interval:seconds
                                                 target:object
                                               selector:NSSelectorFromString(methodName)
                                               userInfo:infoObject
                                                repeats:repeats];

        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
        if (self.propertiesDictionary != nil) {
            [self.propertiesDictionary removeAllObjects];
            self.propertiesDictionary = nil;
        }
        
        self.propertiesDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
        [self.propertiesDictionary setValue:@(seconds) forKey:@"seconds"];
        (self.propertiesDictionary)[@"target"] = object;
        [self.propertiesDictionary setValue:methodName forKey:@"methodName"];
        if (infoObject == nil) {
            (self.propertiesDictionary)[@"infoObject"] = [NSNull null];
        } else {
            (self.propertiesDictionary)[@"infoObject"] = infoObject;
        }
        [self.propertiesDictionary setValue:@(repeats) forKey:@"repeats"];

        self.timerCanStart = YES;
    }
    return self;
}

-(void)dealloc {
    if ([self.timer isValid]) [self.timer invalidate];
    self.timer = nil;
}

-(void)fire {
    [self.timer fire];
}

-(void)start {
    if (self.timerCanStart == YES) {
        CGFloat seconds = [[self.propertiesDictionary valueForKey:@"seconds"] floatValue];
        id target = (self.propertiesDictionary)[@"target"];
        NSString *methodName = (self.propertiesDictionary)[@"methodName"];
        id infoObject = (self.propertiesDictionary)[@"infoObject"];
        BOOL repeats = [[self.propertiesDictionary valueForKey:@"repeats"] boolValue];
        
        if (self.timer.isValid) {
            [self.timer invalidate];
        }
        self.timer = [NSTimer scheduledTimerWithTimeInterval:seconds 
                                             target:target
                                           selector:NSSelectorFromString(methodName) 
                                           userInfo:infoObject 
                                            repeats:repeats];

        self.timerCanStart = NO;
    }
}

-(void)stop {
    [self.timer invalidate];
    self.timerCanStart = YES;
}

-(BOOL)isValid {
    return self.timer.isValid;
}

-(void)setFireDate:(NSDate *)_fireDate {
    if (self.isValid) {
        self.timer.fireDate = _fireDate;
    }
}

-(NSDate *)fireDate {
    return self.timer.fireDate;
}

-(CGFloat)timeInterval {
    return (CGFloat)self.timer.timeInterval;
}

-(id)userInfo {
    if(self.isValid) return self.timer.userInfo;
    return nil;
}
@end
