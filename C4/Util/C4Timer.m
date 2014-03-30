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

#import "C4Timer.h"

@interface C4Timer ()
-(id)initScheduledTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;
-(id)initWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats;
-(id)initWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)target method:(NSString *)methodName userInfo:(id)userInfo repeats:(BOOL)repeats;

@property(nonatomic, strong) NSTimer *timer;
@property(nonatomic) BOOL timerCanStart;
@property(nonatomic, strong) NSMutableDictionary *propertiesDictionary;
@end

@implementation C4Timer

+ (instancetype)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats {
    return [C4Timer automaticTimerWithInterval:seconds
                                        target:object
                                        method:methodName
                                      userInfo:nil
                                       repeats:repeats];
}

+ (instancetype)automaticTimerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats {
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

+ (instancetype)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats {
    return [C4Timer timerWithInterval:seconds
                               target:object
                               method:methodName
                             userInfo:nil
                              repeats:repeats];
}

+ (instancetype)timerWithInterval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats {
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

+ (instancetype)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName repeats:(BOOL)repeats {
    C4Timer *timer = [[C4Timer alloc] initWithFireDate:date
                                              interval:seconds
                                                target:object
                                                method:methodName
                                              userInfo:nil
                                               repeats:repeats];
    return timer;
}
+ (instancetype)timerWithFireDate:(NSDate *)date interval:(CGFloat)seconds target:(id)object method:(NSString *)methodName userInfo:(id)infoObject repeats:(BOOL)repeats {
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
