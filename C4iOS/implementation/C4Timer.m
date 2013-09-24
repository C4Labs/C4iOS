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
        _timer = [NSTimer scheduledTimerWithTimeInterval:seconds 
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
        
        _timerCanStart = NO;
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
        if([_timer isValid]) 
            [_timer invalidate];

        _timer = [NSTimer timerWithTimeInterval:seconds
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

        _timerCanStart = YES;
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
        _timer = [[NSTimer  alloc] initWithFireDate:date
                                               interval:seconds
                                                 target:object
                                               selector:NSSelectorFromString(methodName)
                                               userInfo:infoObject
                                                repeats:repeats];

        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
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

        _timerCanStart = YES;
    }
    return self;
}

-(void)dealloc {
    if ([_timer isValid]) [_timer invalidate];
    _timer = nil;
}

-(void)fire {
    [_timer fire];
}

-(void)start {
    if(_timer.isValid) {
        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    } else {
        CGFloat seconds = [[self.propertiesDictionary valueForKey:@"seconds"] floatValue];
        id target = (self.propertiesDictionary)[@"target"];
        NSString *methodName = (self.propertiesDictionary)[@"methodName"];
        id infoObject = (self.propertiesDictionary)[@"infoObject"];
        BOOL repeats = [[self.propertiesDictionary valueForKey:@"repeats"] boolValue];
        
        if (_timer.isValid) {
            [_timer invalidate];
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:seconds 
                                             target:target
                                           selector:NSSelectorFromString(methodName) 
                                           userInfo:infoObject 
                                            repeats:repeats];
        
        _timerCanStart = NO;
    }
}

-(void)stop {
    [_timer invalidate];
    _timerCanStart = YES;
}

-(BOOL)isValid {
    return _timer.isValid;
}

-(void)setFireDate:(NSDate *)_fireDate {
    if (self.isValid) {
        _timer.fireDate = _fireDate;
    }
}

-(NSDate *)fireDate {
    return _timer.fireDate;
}

-(CGFloat)timeInterval {
    return (CGFloat)_timer.timeInterval;
}

-(id)userInfo {
    if(self.isValid) return _timer.userInfo;
    return nil;
}

-(void)invalidate {
    [_timer invalidate];
}
@end
