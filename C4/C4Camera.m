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

#import "C4Camera.h"

@interface C4Camera ()
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, strong) AVCaptureDevice *currentCamera;
@property(nonatomic, strong) AVCaptureDeviceInput *input;
@property(nonatomic, strong) AVCaptureVideoDataOutput *output;
@property(nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@end


@implementation C4Camera

+ (instancetype)cameraWithFrame:(CGRect)frame {
    return [[C4Camera alloc] initWithFrame:frame];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _cameraPosition = CAMERAFRONT;
        _captureQuality = C4CameraQualityPhoto;
        [self initializePreviewLayer];
        [self initCapture];
    }
    return self;
}

- (void)initializePreviewLayer {
    _previewLayer = [AVCaptureVideoPreviewLayer layer];
    _previewLayer.frame = self.view.bounds;
    _previewLayer.backgroundColor = [UIColor clearColor].CGColor;
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_previewLayer];
}

- (void)initCapture {
    [self initCapture:self.cameraPosition];
}

- (void)initCapture:(C4CameraPosition)position {
    self.cameraPosition = position;
    self.currentCamera = [self cameraForPosition:self.cameraPosition];
    [self initializeInputOutputForCamera:self.currentCamera];
    [self initializeCaptureSession];
    [self.captureSession startRunning];
    _initialized = YES;
}

- (AVCaptureDevice *)cameraForPosition:(C4CameraPosition)position {
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras) {
        if([device position] == (AVCaptureDevicePosition)position) {
            return device;
        }
    }
    return nil;
}

- (void)initializeInputOutputForCamera:(AVCaptureDevice *)camera {
    if (self.input == nil) {
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:camera error:nil];
    }
    
    if (self.output == nil) {
        self.output = [[AVCaptureVideoDataOutput alloc] init];
        self.output.alwaysDiscardsLateVideoFrames = YES;
    }
    
    if (self.stillImageOutput == nil) {
        // Set the video output to store frame in BGRA (It is supposed to be faster)
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        [self.stillImageOutput setOutputSettings:@{ AVVideoCodecKey: AVVideoCodecJPEG }];
    }
}

- (void)initializeCaptureSession {
    if (self.captureSession == nil) {
        self.captureSession = [[AVCaptureSession alloc] init];
        self.previewLayer.session = self.captureSession;
    }
    
    /*We use medium quality, on the iPhone 4 this demo would be laging too much, the conversion in UIImage and CGImage demands too much ressources for a 720p resolution.*/
    [self.captureSession setSessionPreset:self.captureQuality];
    
    /*We add input and output*/
    if([self.captureSession.inputs count] > 0) {
        [self.captureSession removeInput:self.captureSession.inputs[0]];
    }
    [self.captureSession addInput:self.input];
    
    if([self.captureSession.outputs count] > 0) {
        [self.captureSession removeOutput:self.captureSession.outputs[0]];
    }
    [self.captureSession addOutput:self.stillImageOutput];
}

- (void)captureImage {
    if (self.stillImageOutput.isCapturingStillImage)
        return;

    AVCaptureConnection *captureConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    typedef void (^AVBufferBlock)(CMSampleBufferRef, NSError *);
    AVBufferBlock bufferBlock = ^(CMSampleBufferRef buf, NSError *err) {
        NSData *d = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buf];
        
        if(self.cameraPosition == CAMERAFRONT) {
            //Orient the image so its the same as the preview layer
            UIImage *img = [UIImage imageWithData:d];
            CGImageRef imgRef = [img CGImage];
            UIImage *flipped = [UIImage imageWithCGImage:imgRef
                                                   scale:img.scale
                                             orientation:UIImageOrientationLeftMirrored];
            _capturedImage = [C4Image imageWithUIImage:flipped];
        } else {
            _capturedImage = [C4Image imageWithData:d];
        }
        
        [self postNotification:@"imageWasCaptured"];
    };
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection
                                                       completionHandler:bufferBlock];
}

- (void)setCaptureQuality:(NSString *)captureQuality {
    if ([self.captureSession canSetSessionPreset:captureQuality]) {
        _captureQuality = captureQuality;
        if (self.isInitialized) {
            [self.captureSession stopRunning];
            [self initializeCaptureSession];
            [self.captureSession startRunning];
        }
    } else {
        NSString *currentCameraPosition;
        switch (self.cameraPosition) {
            case CAMERABACK:
                currentCameraPosition = @"CAMERABACK";
                break;
            case CAMERAFRONT:
                currentCameraPosition = @"CAMERAFRONT";
                break;
            default:
                currentCameraPosition = @"CAMERAUNSPECIFIED";
                break;
        }
        C4Log(@"Cannot set capture quality: %@ for current camera: %@ on current device: %@", captureQuality, currentCameraPosition, [C4Foundation currentDeviceModel]);
    }
}

- (void)setCameraPosition:(C4CameraPosition)position {
    if (_cameraPosition == position)
        return;
    
    _cameraPosition = position;
    if (self.isInitialized) {
        [self.captureSession stopRunning];
        self.currentCamera = [self cameraForPosition:_cameraPosition];
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.currentCamera error:nil];
        [self initializeCaptureSession];
        [self.captureSession startRunning];
    }
}


#pragma mark - Templates

+ (C4Template *)defaultTemplate {
    static C4Template* template;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        template = [C4Template templateFromBaseTemplate:[super defaultTemplate] forClass:self];
    });
    return template;
}

@end
