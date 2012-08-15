//
//  C4Camera.h
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Control.h"

/** The C4Camera class provides easy access to a devices cameras. 
 
 Creating and adding a C4Camera object to the canvas will let you play around with the images your device is pulling from its camera. 
 
 The captureImage method is tied to another method called imageWasCaptured which is located on the canvas. When captureImage is called, the device takes some time to capture and format the image. When it is done it posts a notification. Then, when the canvas hears this notification it runs its imageWasCaptured method.
 
 If you want to do something immediately after an image is taken, put your code in the canvas' imageWasCaptured method. This ensures that it will be called *only after* the image is ready to be used.
 
 @warning This class is in development and is not complete.
 
 */
@interface C4Camera : C4Control <AVCaptureVideoDataOutputSampleBufferDelegate>

/** Creates and returns a camera object in the specified frame.
  
 @param frame The frame into which the camera image will be scaled, or cropped depending on the dimensions of the frame.
 
 @return A C4Camera object of the specified size;
 */
+(C4Camera *)cameraWithFrame:(CGRect)frame;

/** Initializes a C4Camera object, making it ready to capture images.
 */
-(void)initCapture;

/** Captures an image.
 
 This method also posts a notification when an image has been captured.
 */
-(void)captureImage;

/** The receiver’s most recently captured image. (read-only)
 
 When a camera object captures an image it overwrites any other image that was previously captured.
 */
@property (readonly, strong, nonatomic) C4Image *capturedImage;
@end