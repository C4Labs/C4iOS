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
#import "C4CameraLayer.h"

/** The C4CameraController class provides control over the image, view and preview layer for a C4Camera object.
 
 @warning This class should only be used internally by the C4Camera object and not subclasses or used explicitly.
 */
@interface C4CameraController : C4ViewController <AVCaptureVideoDataOutputSampleBufferDelegate, C4Notification> {
}
#pragma mark - Initializing Capture
///@name Initializing Capture
/** Initializes a C4Camera object, making it ready to capture images.

 The default is CAMERAFRONT.
 */
-(void)initCapture;

/** Initializes camera capture for a given camera position.

 @param position The position of the camera to use upon initialization.
 */
-(void)initCapture:(C4CameraPosition)position;

/**Specifies whether or not the receiver has already been initialized.
 */
@property (readonly, nonatomic, getter = isInitialized) BOOL initialized;

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

#pragma mark - View & Layer
///@name View & Layer
/** The receiver’s view.
 */
@property (readwrite, strong, nonatomic) C4View *view;

/** The receiver’s view's backing layer.
 */
@property (readwrite, strong, nonatomic) C4CameraLayer *previewLayer;

#pragma mark - Camera Position & Quality
///@name Camera Position & Quality
/**Specifies and returns the current position of the receiver. 
 
 Use this property to set or determine the current position of a given C4Camera object.
 */
@property (readonly, nonatomic) C4CameraPosition cameraPosition;

/**Switches the camera's position to the front or back.
 
 This method will switch the camera on a given device from the front to the back (e.g. iPhone) depending on the value of the `position` being passed into it.
 
 The camera will switch only if the `position` is different than the camera's actual current position. For example, it will not switch to the front if te camera 
 
 @param position A position (CAMERAFRONT or CAMERABACK) to which the camera should switch.
 */
-(void)switchCameraPosition:(C4CameraPosition)position;

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

#pragma mark - Capture Session
///@name Capture Session
/**An AVCaptureSession object used to coordinate the flow of data from AV input devices to outputs.
 
 This property is used by `C4Camera` to access and coordinate with its underlying controller.
 
 You should never have to access this property, but it is available for if you really want to work with the capture session. Other methods and properties in `C4Camera` should provide sufficient control over the capture session.

 See AVCaptureSession for more details.
 */
@property (readwrite, strong, atomic) AVCaptureSession *captureSession;

@end
