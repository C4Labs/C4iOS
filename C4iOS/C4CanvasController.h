//
//  ViewController.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class C4Window;

/** The C4CanvasController class provides control over the main canvas in C4.
 
 This class is the superclass of C4WorkSpace and handles all the dirty work that isn't present therein.
 
 @warning This class should only be used internally by the C4WorkSpace object and not subclassed or used explicitly.
 */
@interface C4CanvasController : UIViewController <AVAudioSessionDelegate, C4Gesture, C4Notification, C4MethodDelay, C4AddSubview> {
}

///@name Instance Methods
/** The setup method for the canvas.
 
 This method is called at the end of the application's launch cycle.
 
 You should code everything you want your application to do, prior to loading, in this method.
 */
-(void)setup;

#pragma mark C4Camera Callback

/** A callback method for the current C4Camera object.
 
 After a C4Camera captures an image it posts a notification. The canvas listens for when the camera's image is ready to use and then automatically triggers this method.
 
 For instance, if you call:
 
 `[camera captureImage];`
 
 ... a few moments later, when the captured image is ready to use, the canvas will *automatically* call:
 
 `[self imageWasCaptured];`
 */
-(void)imageWasCaptured;

///@name Properties
/** The application's main canvas.
 
 This property references the main canvas for the application, you can access the canvas to perform actions such as:
 
 `[self.canvas addShape:s];`
 
 or to set properties such as:
 
 `self.canvas.backgroundColor = [UIColor ...];`
 */
@property (readonly, strong, nonatomic) C4Window *canvas;

@end