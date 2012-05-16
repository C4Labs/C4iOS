//
//  C4CameraController.h
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C4CaptureVideoPreviewLayer.h"
#import "C4Image.h"
#import "C4View.h"

@interface C4CameraController : C4ViewController <AVCaptureVideoDataOutputSampleBufferDelegate, C4Notification> {
}
-(void)initCapture;
-(void)captureImage;
@property (readonly, strong) C4Image *capturedImage;
@property (readwrite, strong, nonatomic) C4View *view;
@property (readwrite, strong, nonatomic) C4CaptureVideoPreviewLayer *previewLayer;
@end
