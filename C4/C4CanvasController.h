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

@class C4Control;

/** The C4CanvasController class provides control over the main canvas in C4.
 
 This class is the superclass of C4WorkSpace and handles all the dirty work that isn't present therein.
 
 @warning This class should only be used internally by the C4WorkSpace object and not subclassed or used explicitly.
 */
@interface C4CanvasController : UIViewController <AVAudioSessionDelegate, C4Notification, C4MethodDelay>

#pragma mark - Setup
///@name Setup
/** The setup method for the canvas.
 
 This method is called at the end of the application's launch cycle.
 
 You should code everything you want your application to do, prior to loading, in this method.
 */
-(void)setup;

#pragma mark - The Canvas
///@name The Canvas
/** The application's main canvas.
 
 This property references the main canvas for the application, you can access the canvas to perform actions such as:
 
 `[self.canvas addShape:s];`
 
 or to set properties such as:
 
 `self.canvas.backgroundColor = [UIColor ...];`
 */
@property(nonatomic, readonly, strong) C4Control *canvas;

#pragma mark C4Camera Callback
#pragma mark - Callbacks
///@name Callbacks
/** A callback method for the current C4Camera object.
 
 After a C4Camera captures an image it posts a notification. The canvas listens for when the camera's image is ready to use and then automatically triggers this method.
 
 For instance, if you call:
 
 `[camera captureImage];`
 
 ... a few moments later, when the captured image is ready to use, the canvas will *automatically* call:
 
 `[self imageWasCaptured];`
 */
-(void)imageWasCaptured;

#pragma - mark Gesture Additions
-(void)tapped;
-(void)tapped:(CGPoint)location;
-(void)panned;
-(void)panned:(CGPoint)location translation:(CGPoint)translation velocity:(CGPoint)velocity;
-(void)pinched;
-(void)pinched:(CGPoint)location scale:(CGFloat)scale velocity:(CGFloat)velocity;
-(void)rotated;
-(void)rotated:(CGPoint)location rotation:(CGFloat)rotation velocity:(CGFloat)velocity;
-(void)swipedLeft;
-(void)swipedRight;
-(void)swipedUp;
-(void)swipedDown;
-(void)longPressStarted;
-(void)longPressStarted:(CGPoint)location;
-(void)longPressEnded;
-(void)longPressEnded:(CGPoint)location;

@end