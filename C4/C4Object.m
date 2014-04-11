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

@implementation C4Object

- (id)init {
    self = [super init];
    [self setup];
    return self;
}

- (void)setup {
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Notifications
- (void)listenFor:(NSString *)notification andRun:(NotificationBlock)block {
    [self listenFor:notification fromObject:nil andRun:block];
}

- (void)listenFor:(NSString *)notification fromObject:(id)object andRun:(NotificationBlock)block {
    [[NSNotificationCenter defaultCenter] addObserverForName:notification object:self queue:nil usingBlock:block];
}

- (void)listenFor:(NSString *)notification fromObjects:(NSArray *)objectArray andRun:(NotificationBlock)block {
    for (id object in objectArray) {
        [[NSNotificationCenter defaultCenter] addObserverForName:notification object:object queue:nil usingBlock:block];
    }
}

- (void)stopListeningFor:(NSString *)methodName {
    [self stopListeningFor:methodName object:nil];
}

- (void)stopListeningFor:(NSString *)methodName object:(id)object {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
}

- (void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {
    for(id object in objectArray) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
    }
}

- (void)postNotification:(NSString *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

#pragma mark - MethodDelay

-(void)run:(void (^)())block afterDelay:(CGFloat)seconds {
    NSDictionary *d = @{@"block": block};
    [self performSelector:@selector(executeBlockUsingDictionary:) withObject:d afterDelay:seconds];
}

-(void)executeBlockUsingDictionary:(NSDictionary *)d {
    void (^block)(void) = d[@"block"];
    block();
    d = nil;
}

@end
