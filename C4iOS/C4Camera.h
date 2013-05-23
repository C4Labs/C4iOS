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
#pragma mark - Creating Cameras
///@name Creating Cameras
/** Creates and returns a camera object in the specified frame.
  
 @param frame The frame into which the camera image will be scaled, or cropped depending on the dimensions of the frame.
 
 @return A C4Camera object of the specified size;
 */
+(C4Camera *)cameraWithFrame:(CGRect)frame;

#pragma mark - Initializing Capture
///@name Initializing Capture
/** Initializes a C4Camera object, making it ready to capture images.
 */
-(void)initCapture;

#pragma mark - Capturing Images
///@name Capturing Images
/** Captures an image.
 
 This method also posts a notification when an image has been captured.
 */
-(void)captureImage;

/** The receiver’s most recently captured image. (read-only)
 
 When a camera object captures an image it overwrites any other image that was previously captured.
 */
@property (readonly, strong, nonatomic) C4Image *capturedImage;

#pragma mark - Camera Position & Quality
///@name Camera Position & Quality
/** Specifies the current position of the receiver's camera.
 
 A camera's position can be either `CAMERAFRONT` or `CAMERABACK`, setting this property will change to the specified camera position.
 */
@property (readwrite, nonatomic) C4CameraPosition cameraPosition;

/**Specifies the current capture quality of the camera. The following list of qualities is available:
 
 - C4CameraQualityPhoto
 - C4CameraQualityHigh
 - C4CameraQualityLow
 - C4CameraQuality352x288
 - C4CameraQuality640x480
 - C4CameraQuality1280x720
 - C4CameraQuality1920x1080
 - C4CameraQualityiFrame960x540
 - C4CameraQualityiFrame1280x720

 See C4Defines for more information.
 */
@property (readwrite, nonatomic) NSString *captureQuality;

#pragma mark - Default Style
///@name Default Style
/**Returns the appearance proxy for the object, cast as a C4Camera rather than the standard (id) cast provided by UIAppearance.
 
 You use this method to grab the appearance object that allows you to change the default style for C4Camera objects.
 
 @return The appearance proxy for the receiver, cast as a C4Camera.
 */
+(C4Camera *)defaultStyle;
@end