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

#import <UIKit/UIKit.h>

/** This document describes the basic C4AppDelegate, a subclass of UIResponder which conforms to the UIApplicationDelegate protocol.
 
 The C4AppDelegate class is used to define the main window of an application, and to specify the a canvas controller of the C4CanvasController type (rather than the defaults for both).
 */

@interface C4AppDelegate : UIResponder <UIApplicationDelegate, UIScrollViewDelegate>

/** The main application window.
 */
@property(nonatomic, strong) UIWindow *window;

/** The root view controller of the main application window. A UIViewController customized specifically for the C4 Framework.
 */
@property(nonatomic, strong) C4WorkSpace *workspace;

@end