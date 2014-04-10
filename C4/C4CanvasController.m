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
    [self listenFor:@"movieIsReadyForPlayback" andRunMethod:@"movieIsReadyForPlayback:"];
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (!self)
        return nil;
    [self createCanvas];
    [self listenFor:@"movieIsReadyForPlayback" andRunMethod:@"movieIsReadyForPlayback:"];
    return self;
}

- (id)initWithNibName:(NSString *)nibName bundle:(NSBundle *)nibBundle {
    self = [super initWithNibName:nibName bundle:nibBundle];
    if (!self)
        return nil;
    [self createCanvas];
    [self listenFor:@"movieIsReadyForPlayback" andRunMethod:@"movieIsReadyForPlayback:"];
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
}

- (void)setup {
}

- (void)viewDidLoad {
    CGSize size = self.view.bounds.size;
    self.canvas.frame = CGRectMake(0, 0, size.width, size.height);
    [self.view addSubview:self.canvas.view];
}


#pragma mark C4Notification Methods

- (void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName {
    [self listenFor:notification fromObject:nil andRunMethod:methodName];
}

- (void)listenFor:(NSString *)notification fromObject:(id)object andRunMethod:(NSString *)methodName {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
}

- (void)listenFor:(NSString *)notification fromObjects:(NSArray *)objectArray andRunMethod:(NSString *)methodName {
    for (id object in objectArray) {
        [self listenFor:notification fromObject:object andRunMethod:methodName];
    }
}

- (void)stopListeningFor:(NSString *)notification {
    [self stopListeningFor:notification object:nil];
}

- (void)stopListeningFor:(NSString *)notification object:(id)object {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification object:object];
}

- (void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {
    for(id object in objectArray) {
        [self stopListeningFor:methodName object:object];
    }
}

- (void)postNotification:(NSString *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}


#pragma mark C4MethodDelay methods

- (void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

- (void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
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

@end