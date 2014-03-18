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

#import "C4CameraController.h"

@interface C4CameraController ()
@property (readwrite, strong, atomic) AVCaptureStillImageOutput *stillImageOutput;
@property (readwrite, strong, atomic) AVAssetWriter *assetWriter;
@property (readwrite, strong, nonatomic) AVCaptureDevice *currentCamera;
@property (readwrite, strong, nonatomic) AVCaptureDeviceInput *input;
@property (readwrite, strong, nonatomic) AVCaptureVideoDataOutput *output;
@property (readwrite, strong, nonatomic) __block dispatch_queue_t cameraQueue;
@end

@implementation C4CameraController

- (id)init {
	self = [super init];
	if (self) {
		_previewLayer = nil;
        _captureQuality = C4CameraQualityPhoto;
        _cameraPosition = CAMERAFRONT;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initCapture];
}

-(void)dealloc {
    _captureSession = nil;
    _stillImageOutput = nil;
    _assetWriter = nil;
    
    _capturedImage = nil;
    _previewLayer = nil;
}

-(void)setPreviewLayer:(C4CameraLayer *)previewLayer {
    _previewLayer = previewLayer;
}

- (void)initCapture {
    [self initCapture:self.cameraPosition];
}

-(AVCaptureDevice *)cameraForPosition:(C4CameraPosition)position {
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *camera;
    _cameraPosition = position;
    for(AVCaptureDevice *device in cameras) {
        if([device position] == (AVCaptureDevicePosition)position) {
            camera = device;
        }
    }
    return camera;
}

-(void)initializeInputOutputForCamera:(AVCaptureDevice *)camera {
    if(self.input == nil) {
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:camera error:nil];
    }
    
    if(self.output == nil) {
        self.output = [[AVCaptureVideoDataOutput alloc] init];
        self.output.alwaysDiscardsLateVideoFrames = YES;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            self.cameraQueue = dispatch_queue_create("cameraQueue", NULL);
        });
        [self.output setSampleBufferDelegate:self queue:self.cameraQueue];
    }
    
    if(self.stillImageOutput == nil) {
        // Set the video output to store frame in BGRA (It is supposed to be faster)
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
        [self.stillImageOutput setOutputSettings:outputSettings];
    }
}

-(void)initializeCaptureSession {
    /*And we create a capture session*/
    if(self.captureSession == nil) {
        self.captureSession = [[AVCaptureSession alloc] init];
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

-(void)initializePreviewLayer {
    self.previewLayer.session = self.captureSession;
    self.previewLayer.backgroundColor = [UIColor clearColor].CGColor;
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
}

- (void)initCapture:(C4CameraPosition)position {
    _cameraPosition = position;
    self.currentCamera = [self cameraForPosition:self.cameraPosition];
    [self initializeInputOutputForCamera:self.currentCamera];
    [self initializeCaptureSession];
    [self initializePreviewLayer];
    [self.captureSession startRunning];
    _initialized = YES;
}

-(void)switchCameraPosition:(C4CameraPosition)position {
    if(self.cameraPosition != position) {
        _cameraPosition = position;
        if(_initialized == YES) {
            [self.captureSession stopRunning];
            self.currentCamera = [self cameraForPosition:self.cameraPosition];
            self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.currentCamera error:nil];
            [self initializeCaptureSession];
            [self initializePreviewLayer];
            [self.captureSession startRunning];
        }
    }
}

-(void)captureImage {
    if(!self.stillImageOutput.isCapturingStillImage) {
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
                img = nil;
                flipped = nil;
                imgRef = nil;
            } else {
                _capturedImage = [C4Image imageWithData:d];
            }
            
            [self postNotification:@"imageWasCaptured"];
        };
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection
                                                           completionHandler:bufferBlock];
    }
}

-(void)setCaptureQuality:(NSString *)captureQuality {
    if([self.captureSession canSetSessionPreset:captureQuality]) {
        _captureQuality = captureQuality;
        if(_initialized == YES) {
            [self.captureSession stopRunning];
            [self initializeCaptureSession];
            [self initializePreviewLayer];
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

#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    captureOutput = captureOutput;
    sampleBuffer = sampleBuffer;
    connection = connection;
} 

@end