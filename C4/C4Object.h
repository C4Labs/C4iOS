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

#import <Foundation/Foundation.h>

/** C4Object is the root class of any object in the C4 framework that does not have a visual representation. For example, a C4Font cannot be represented visually so it is a C4Object, whereas a C4Label is something to be seen on screen so it is instead a C4Control.
 
 This class inherits directly from NSObject.
 
 C4Objects conform to the C4Notification protocol which means that all objects will have the ability to post and receive notifications.
 */
@interface C4Object : NSObject <C4MethodDelay, C4Notification>

/** A basic method within which basic variable and parameter setup can happen outside of an object's initialization methods.
 
 A convenience method so that initialization of subclasses can happen in this method rather than overriding (id)init, (id)initWithFrame:, etc...
 */
- (void)setup;

@end
