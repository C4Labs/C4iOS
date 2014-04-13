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

#import <Foundation/Foundation.h>

/**
 The C4Template stores style and other properties of a target object. When you apply a template to its target object, the target object takes all the values stored in the template.
 
 When setting the template properties, the template object acts as a proxy of the target object. You need to cast the template to the target object's class and call methods on it as if it was the actual object. For instance use this code to create a template for a C4Control:
 
     C4Template* template = [C4Template templateForClass:[C4Control class]];
     C4Control* proxy = [template proxy];
     proxy.shadowRadius = 1.5;
 */
@interface C4Template : NSObject <NSCopying>

/** The target class of this template.
 */
@property(nonatomic, readonly, strong) Class targetClass;

/** Helper method to create a new template for a target class.
 */
+ (instancetype)templateForClass:(Class)targetClass;

/** Helper method to create a new template by copying a base template targeting a superclass of targetClass.
 
 @param template The template to copy.
 @param targetClass The target class for the new template, should be a subclass of the base template's target class.
 */
+ (instancetype)templateFromBaseTemplate:(C4Template*)template forClass:(Class)targetClass;

/** Initializes a new template with a target class. This is the designated initializer.
 */
- (id)initWithTargetClass:(Class)targetClass;

/** Return the proxy object.
 */
- (id)proxy;

/** Apply the template to the target object. The target object's class need to match the class used to initialize the template.
 
 @param target The object to which the template is being applied.
 */
- (void)applyToTarget:(id)target;

@end
