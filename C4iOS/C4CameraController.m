//
//  C4CameraController.m
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4CameraController.h"

@interface C4CameraController ()
@property (readwrite, strong, atomic) AVCaptureSession *captureSession;
@property (readwrite, strong, atomic) AVCaptureStillImageOutput *stillImageOutput;
@property (readwrite, strong, atomic) AVAssetWriter *assetWriter;
@end

@implementation C4CameraController

- (id)init {
	self = [super init];
	if (self) {
		_previewLayer = nil;
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
	/*We setup the input*/
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *frontCamera;
    for(AVCaptureDevice *device in cameras) {
        if([device position] == AVCaptureDevicePositionFront) {
            frontCamera = device;
        }
    }
    
	AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput 
										  deviceInputWithDevice:frontCamera
										  error:nil];
    
	/*We setupt the output*/
	AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
    
	/*While a frame is processes in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
	 If you don't want this behaviour set the property to NO */
	captureOutput.alwaysDiscardsLateVideoFrames = YES; 

	/*We create a serial queue to handle the processing of our frames*/
	dispatch_queue_t queue;
	queue = dispatch_queue_create("cameraQueue", NULL);
	[captureOutput setSampleBufferDelegate:self queue:queue];
    
	// Set the video output to store frame in BGRA (It is supposed to be faster)
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = @{AVVideoCodecKey: AVVideoCodecJPEG};
    [self.stillImageOutput setOutputSettings:outputSettings];
    
	/*And we create a capture session*/
	self.captureSession = [[AVCaptureSession alloc] init];
    
    /*We use medium quality, on the iPhone 4 this demo would be laging too much, the conversion in UIImage and CGImage demands too much ressources for a 720p resolution.*/
    [self.captureSession setSessionPreset:AVCaptureSessionPresetPhoto];

	/*We add input and output*/
	[self.captureSession addInput:captureInput];
    [self.captureSession addOutput:self.stillImageOutput];
    
    /*We add the preview layer*/
    self.previewLayer.session = self.captureSession;
	self.previewLayer.frame = CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.width);
    
	self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
	/*We start the capture*/
	[self.captureSession startRunning];
}

-(void)captureImage {
    AVCaptureConnection *av = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    typedef void (^AVBufferBlock)(CMSampleBufferRef, NSError *);
    AVBufferBlock avb = ^(CMSampleBufferRef buf, NSError *err) {
        err = [NSError errorWithDomain:@"captureImage error" code:0 userInfo:nil];
        NSData *d = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buf];
        _capturedImage = nil;
        _capturedImage = [C4Image imageWithData:d];
        [self postNotification:@"imageWasCaptured"];
    };
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:av
                                                       completionHandler:avb];
}

#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    captureOutput = captureOutput;
    sampleBuffer = sampleBuffer;
    connection = connection;
} 

@end