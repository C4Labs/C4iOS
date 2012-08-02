//
//  C4CameraController.m
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4CameraController.h"

@interface C4CameraController ()
@property (readwrite, strong, nonatomic) AVCaptureSession *captureSession;
@property (readwrite, strong, atomic) AVCaptureStillImageOutput *stillImageOutput;
@property (readwrite, strong, atomic) AVAssetWriter *assetWriter;
@end

@implementation C4CameraController
@synthesize captureSession;
@synthesize previewLayer = _previewLayer;
@synthesize view;
@synthesize stillImageOutput;
@synthesize assetWriter;
@synthesize capturedImage = _capturedImage;

- (id)init {
	self = [super init];
	if (self) {
		self.previewLayer = nil;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	[self initCapture];
}

-(void)dealloc {
    self.captureSession = nil;
    self.stillImageOutput = nil;
    self.assetWriter = nil;

    _capturedImage = nil;
    _previewLayer = nil;
}

-(void)setPreviewLayer:(C4CaptureVideoPreviewLayer *)previewLayer {
    _previewLayer = previewLayer;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return interfaceOrientation;
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
	
    /*We specify a minimum duration for each frame (play with this settings to avoid having too many frames waiting
	 in the queue because it can cause memory issues). It is similar to the inverse of the maximum framerate.
	 In this example we set a min frame duration of 1/10 seconds so a maximum framerate of 10fps. We say that
	 we are not able to process more than 10 frames per second.*/
	//captureOutput.minFrameDuration = CMTimeMake(1, 10);
	
	/*We create a serial queue to handle the processing of our frames*/
	dispatch_queue_t queue;
	queue = dispatch_queue_create("cameraQueue", NULL);
	[captureOutput setSampleBufferDelegate:self queue:queue];
	dispatch_release(queue);
    
	// Set the video output to store frame in BGRA (It is supposed to be faster)
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                    AVVideoCodecJPEG, AVVideoCodecKey, nil];
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

} 

#pragma mark -
#pragma mark Memory management

- (void)viewDidUnload {
	self.previewLayer = nil;
    self.captureSession = nil;
}
@end