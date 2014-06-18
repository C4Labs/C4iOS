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

#import "C4Shape.h"

@interface C4Shape (Line)

/**Creates and returns an instance of C4Shape, whose path is a line.
 
 @warning *Note:* Lines are the only shape objects which are not touchable, draggable, etc.
 
 @param pointArray A C-Array containing 2 CGPoints like: {CGpoint,CGPoint}.
 @return The initialized C4Shape object created with a line path or nil if initialization is not successful.
 */
+ (instancetype)line:(CGPoint *)pointArray;

/**Changes the object's current shape to a line
 
 The change will happen based on the shape's current animation options, duration and delay.
 
 @param pointArray A C-Array containing 2 CGPoints like: {CGpoint,CGPoint}.
 */
- (void)line:(CGPoint *)pointArray;

/**Specifies whether or not the shape is a line.
 */
@property(nonatomic, readonly, getter = isLine) BOOL line;

@end
