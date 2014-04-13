// Copyright © 2012 Travis Kirton, Alejandro Isaza
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

#import "C4Template.h"
#import <objc/runtime.h>


@interface C4Template ()
@property(nonatomic, strong) Class targetClass;
@property(nonatomic, strong) NSMutableArray* invocations;
@end


@implementation C4Template

+ (instancetype)templateForClass:(Class)targetClass {
    C4Template* template = [[C4Template alloc] initWithTargetClass:targetClass];
    return template;
}

+ (instancetype)templateFromBaseTemplate:(C4Template*)template forClass:(Class)targetClass {
    C4Template* newTemplate = [[C4Template alloc] initWithTargetClass:targetClass];
    newTemplate.invocations = [template.invocations mutableCopy];
    return newTemplate;
}

- (id)initWithTargetClass:(Class)targetClass {
    self = [super init];
    if (!self)
        return nil;
    
    self.targetClass = targetClass;
    self.invocations = [[NSMutableArray alloc] init];
    return self;
}

- (id)copyWithZone:(NSZone *)zone {
    C4Template* copy = [[[self class] allocWithZone:zone] initWithTargetClass:self.targetClass];
    copy.invocations = [self.invocations mutableCopy];
    return copy;
}

- (id)proxy {
    return self;
}

- (void)applyToTarget:(id)target {
    for (NSInvocation* invocation in self.invocations) {
        invocation.target = target;
        [invocation invoke];
        invocation.target = nil; // Don't keep a reference to target
    }
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation retainArguments];
    [self.invocations addObject:invocation];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature* sig = [super methodSignatureForSelector:sel];
    if (sig)
        return sig;
    
    // Come up with a method signature from the target class and the selector
    Method method = class_getInstanceMethod(self.targetClass, sel);
    struct objc_method_description* desc = method_getDescription(method);
    if (desc == NULL || desc->name == NULL)
        return nil;
    
    return [NSMethodSignature signatureWithObjCTypes:desc->types];
}

@end
