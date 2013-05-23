//
//  C4CameraController.h
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C4CameraLayer.h"

/** The C4CameraController class provides control over the image, view and preview layer for a C4Camera object.
 
 @warning This class should only be used internally by the C4Camera object and not subclasses or used explicitly.
 */
@interface C4CameraController : C4ViewController <AVCaptureVideoDataOutputSampleBufferDelegate, C4Notification> {
}

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

/** The receiver’s view.
 */
@property (readwrite, strong, nonatomic) C4View *view;

/** The receiver’s view's backing layer.
 */
@property (readwrite, strong, nonatomic) C4CameraLayer *previewLayer;

/** Initializes camera capture for a given camera position.
 
 The default is CAMERAFRONT.
 
 @param position The position of the camera to use upon initialization.
 */
-(void)initCapture:(C4CameraPosition)position;

/**Specifies and returns the current position of the receiver. 
 
 Use this property to set or determine the current position of a given C4Camera object.
 */
@property (readonly, nonatomic) C4CameraPosition cameraPosition;

/**Specifies whether or not the receiver has already been initialized. 
 */
@property (readonly, nonatomic, getter = isInitialized) BOOL initialized;

/**Specifies the current capture quality of the receiver. The following list of qualities is available:
 
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

/**Switches the camera's position to the front or back. 
 
 This method will switch the camera on a given device from the front to the back (e.g. iPhone) depending on the value of the `position` being passed into it.
 
 The camera will switch only if the `position` is different than the camera's actual current position. For example, it will not switch to the front if te camera 
 
 @param position A position (CAMERAFRONT or CAMERABACK) to which the camera should switch.
 */
-(void)switchCameraPosition:(C4CameraPosition)position;

/**An AVCaptureSession object used to coordinate the flow of data from AV input devices to outputs.
 
 This property is used by `C4Camera` to access and coordinate with its underlying controller.
 
 You should never have to access this property, but it is available for if you really want to work with the capture session. Other methods and properties in `C4Camera` should provide sufficient control over the capture session.

 See AVCaptureSession for more details.
 */
@property (readwrite, strong, atomic) AVCaptureSession *captureSession;

@end
