//
//  C4Camera.h
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Control.h"
#import "C4CameraController.h"

@interface C4Camera : C4Control <AVCaptureVideoDataOutputSampleBufferDelegate>
+(C4Camera *)cameraWithFrame:(CGRect)frame;
-(void)initCapture;
-(void)captureImage;

@property (readonly, strong, nonatomic) C4Image *capturedImage;
@property (readwrite, nonatomic) CGFloat shadowRadius;
@property (readwrite, nonatomic) CGFloat shadowOpacity;
@property (readwrite, strong, nonatomic) UIColor *shadowColor;
@property (readwrite, nonatomic) CGSize shadowOffset;
@property (readwrite, nonatomic) CGPathRef shadowPath;
@end