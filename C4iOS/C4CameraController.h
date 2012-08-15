//
//  C4CameraController.h
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C4CaptureVideoPreviewLayer.h"

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
@property (readwrite, strong, nonatomic) C4CaptureVideoPreviewLayer *previewLayer;
@end
