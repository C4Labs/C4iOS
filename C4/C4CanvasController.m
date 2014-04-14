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

#import "C4CanvasController.h"
#import <objc/message.h>

@interface C4CanvasController ()
@property(nonatomic, strong) C4Control *canvas;
@property(nonatomic, strong) NSString *longPressMethodName;
@property(nonatomic, strong) NSMutableDictionary *gestureDictionary;
@end

@implementation C4CanvasController

- (id)init {
    self = [super init];
    if (!self)
        return nil;
    [self createCanvas];
    
    [self listenFor:@"movieIsReadyForPlayback" andRun:^(NSNotification *n) {
        [self movieIsReadyForPlayback:n];
    }];

    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self)
        return nil;
    [self createCanvas];
    [self listenFor:@"movieIsReadyForPlayback" andRun:^(NSNotification *n) {
        [self movieIsReadyForPlayback:n];
    }];
    return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (!self)
        return nil;
    [self createCanvas];
    [self listenFor:@"movieIsReadyForPlayback" andRun:^(NSNotification *n) {
        [self movieIsReadyForPlayback:n];
    }];
    return self;
}

- (void)dealloc {
    for (UIGestureRecognizer *g in [self.gestureDictionary allValues]) {
        [g removeTarget:self action:nil];
        [self.view removeGestureRecognizer:g];
    }
}

- (void)createCanvas {
    _canvas = [[C4Control alloc] init];
    _canvas.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.canvas onTap:^(CGPoint location) {
        [self tapped:location];
    }];
    
    [self.canvas onLongPressEnd:^(CGPoint location) {
        [self longPressEnded:location];
    }];
    
    [self.canvas onLongPressStart:^(CGPoint location) {
        [self longPressStarted:location];
    }];

    [self.canvas onPan:^(CGPoint location, CGPoint translation, CGPoint velocity) {
        [self panned:location translation:translation velocity:velocity];
    }];
}

- (void)setup {
}

- (void)viewDidLoad {
    CGSize size = self.view.bounds.size;
    self.canvas.frame = CGRectMake(0, 0, size.width, size.height);
    [self.view addSubview:self.canvas.view];
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

#pragma mark Other methods

- (void)imageWasCaptured {
    
}

- (void)movieIsReadyForPlayback:(NSNotification *)notification {
    C4Movie *currentMovie = (C4Movie *)[notification object];
    [self movieIsReady:currentMovie];
    [self stopListeningFor:@"movieIsReadyForPlayback" object:currentMovie];
}

- (void)movieIsReady:(C4Movie *)movie {
}

#pragma mark Gesture Additions

- (void)tapped {
    
}

- (void)tapped:(CGPoint)location {
    [self postNotification:@"tapped"];
    [self tapped];
}

- (void)pinched {
    
}

- (void)pinched:(CGPoint)location scale:(CGFloat)scale velocity:(CGFloat)velocity {
    [self postNotification:@"pinched"];
    [self pinched];
}

- (void)panned {
    
}

- (void)panned:(CGPoint)location translation:(CGPoint)translation velocity:(CGPoint)velocity {
    [self panned];
}

- (void)rotated {
    
}

-(void)rotated:(CGPoint)location rotation:(CGFloat)rotation velocity:(CGFloat)velocity {
    [self postNotification:@"rotated"];
    [self rotated];
}

- (void)swipedLeft {
    
}

- (void)swipedLeft:(CGPoint)location {
    [self postNotification:@"swipedLeft"];
    [self swipedLeft];
}

- (void)swipedRight {
    
}

- (void)swipedRight:(CGPoint)location {
    [self postNotification:@"swipedRight"];
    [self swipedRight];
}

- (void)swipedUp {
    
}

- (void)swipedUp:(CGPoint)location {
    [self postNotification:@"swipedUp"];
    [self swipedUp];
}

- (void)swipedDown {
    
}

- (void)swipedDown:(CGPoint)location {
    [self postNotification:@"swipedDown"];
    [self swipedDown];
}

- (void)longPressEnded {
    
}

-(void)longPressEnded:(CGPoint)location {
    [self postNotification:@"longPressEnded"];
    [self longPressEnded];
}

- (void)longPressStarted {
    
}

-(void)longPressStarted:(CGPoint)location {
    [self postNotification:@"longPressStarted"];
    [self longPressStarted];
}

@end