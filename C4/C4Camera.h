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

#import "C4Control.h"

@class C4Image;


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
+ (instancetype)cameraWithFrame:(CGRect)frame;

#pragma mark - Initializing Capture
///@name Initializing Capture
/** Initializes a C4Camera object, making it ready to capture images.
 */
- (void)initCapture;

/** Initializes camera capture for a given camera position.
 
 @param position The position of the camera to use upon initialization.
 */
- (void)initCapture:(C4CameraPosition)position;

/**Specifies whether or not the receiver has already been initialized.
 */
@property(nonatomic, readonly, getter = isInitialized) BOOL initialized;

#pragma mark - Capturing Images
///@name Capturing Images
/** Captures an image.
 
 This method also posts a notification when an image has been captured.
 */
- (void)captureImage;

/** The receiver’s most recently captured image. (read-only)
 
 When a camera object captures an image it overwrites any other image that was previously captured.
 */
@property(nonatomic, readonly, strong) C4Image *capturedImage;

#pragma mark - Layer

/** The receiver’s view's backing layer.
 */
@property(nonatomic, readonly, strong) AVCaptureVideoPreviewLayer *previewLayer;

#pragma mark - Camera Position & Quality
///@name Camera Position & Quality
/** Specifies the current position of the receiver's camera.
 
 A camera's position can be either `CAMERAFRONT` or `CAMERABACK`, setting this property will change to the specified camera position.
 */
@property(nonatomic) C4CameraPosition cameraPosition;

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
@property(nonatomic, strong) NSString *captureQuality;

#pragma mark - Capture Session
///@name Capture Session
/**An AVCaptureSession object used to coordinate the flow of data from AV input devices to outputs.
 
 This property is used by `C4Camera` to access and coordinate with its underlying controller.
 
 You should never have to access this property, but it is available for if you really want to work with the capture session. Other methods and properties in `C4Camera` should provide sufficient control over the capture session.
 
 See AVCaptureSession for more details.
 */
@property(nonatomic, strong) AVCaptureSession *captureSession;

@end