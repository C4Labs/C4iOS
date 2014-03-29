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
@property (nonatomic, strong) C4Control *canvas;
@property (nonatomic, strong) NSString *longPressMethodName;
@property (nonatomic, strong) NSMutableDictionary *gestureDictionary;
@end

@implementation C4CanvasController

- (id)init {
    self = [super init];
    if(self != nil) {
        [self listenFor:@"movieIsReadyForPlayback" andRunMethod:@"movieIsReadyForPlayback:"];
    }
    return self;
}

- (void)dealloc {
    for (UIGestureRecognizer *g in [self.gestureDictionary allValues]) {
        [g removeTarget:self action:nil];
        [self.view removeGestureRecognizer:g];
    }
}

- (void)loadView {
    UIControl* control = [[UIControl alloc] init];;
    self.view = control;
    _canvas = [[C4Control alloc] initWithView:control];
}

-(void)setup {
}

-(void)addCamera:(C4Camera *)camera {
    C4Assert([camera isKindOfClass:[C4Camera class]],
             @"You tried to add a %@ using [canvas addCamera:]", [camera class]);
    [self.view addSubview:camera.view];
    [camera initCapture];
    [self listenFor:@"imageWasCaptured" fromObject:camera andRunMethod:@"imageWasCaptured"];
}

-(void)addShape:(C4Shape *)shape {
    [(C4Control *)self.view addShape:shape];
}

-(void)addSubview:(UIView *)subview {
    [self.view addSubview:subview];
}

-(void)addLabel:(C4Label *)label {
    [(C4Control *)self.view addLabel:label];
}

-(void)addGL:(C4GL *)gl {
    [(C4Control *)self.view addGL:gl];
}

-(void)addImage:(C4Image *)image {
    [(C4Control *)self.view addImage:image];
}

-(void)addMovie:(C4Movie *)movie {
    [(C4Control *)self.view addMovie:movie];
}

-(void)addUIElement:(id<C4UIElement>)object {
    [self.view addSubview:((C4Control *)object).view];
}

-(void)addObjects:(NSArray *)array {
    for(id obj in array) {
        if([obj isKindOfClass:[C4Shape class]]) {
            [self addShape:obj];
        }
        else if([obj isKindOfClass:[C4GL class]]) {
            [self addGL:obj];
        }
        else if([obj isKindOfClass:[C4Image class]]) {
            [self addImage:obj];
        }
        else if([obj isKindOfClass:[C4Movie class]]) {
            [self addMovie:obj];
        }
        else if([obj isKindOfClass:[C4Camera class]]) {
            [self addCamera:obj];
        }
        else if([obj isKindOfClass:[UIView class]]) {
            [self addSubview:obj];
        }
        else if([obj conformsToProtocol:NSProtocolFromString(@"C4UIElement")]) {
            [self addSubview:obj];
        }
        else {
            C4Log(@"unable to determine type of class");
        }
    }
}

-(void)removeObject:(id)visualObject {
    C4Assert(self != visualObject, @"You tried to remove %@ from itself, don't be silly", visualObject);
    if ([visualObject isKindOfClass:[UIView class]])
        [visualObject removeFromSuperview];
    else if ([visualObject isKindOfClass:[C4Control class]])
        [((C4Control*)visualObject).view removeFromSuperview];
    else
        C4Log(@"object (%@) you wish to remove is not a visual object", visualObject);
}

-(void)removeObjects:(NSArray *)array {
    for(id obj in array) {
        [self removeObject:obj];
    }
}

#pragma mark Notification Methods
-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName {
    [self listenFor:notification fromObject:nil andRunMethod:methodName];
}

-(void)listenFor:(NSString *)notification fromObject:(id)object andRunMethod:(NSString *)methodName {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
}

-(void)listenFor:(NSString *)notification fromObjects:(NSArray *)objectArray andRunMethod:(NSString *)methodName {
    for (id object in objectArray) {
        [self listenFor:notification fromObject:object andRunMethod:methodName];
    }
}

-(void)stopListeningFor:(NSString *)notification {
    [self stopListeningFor:notification object:nil];
}

-(void)stopListeningFor:(NSString *)notification object:(id)object {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:notification object:object];
}

-(void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {
    for(id object in objectArray) {
        [self stopListeningFor:methodName object:object];
    }
}

-(void)postNotification:(NSString *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

#pragma mark New Stuff

-(void)imageWasCaptured {
    
}

-(void)move:(id)sender {
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

-(void)movieIsReadyForPlayback:(NSNotification *)notification {
    C4Movie *currentMovie = (C4Movie *)[notification object];
    [self movieIsReady:currentMovie];
    [self stopListeningFor:@"movieIsReadyForPlayback" object:currentMovie];
}

-(void)movieIsReady:(C4Movie *)movie {
}

@end