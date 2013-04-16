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
    [self initCapture:C4CameraFront];
}

- (void)initCapture:(C4CameraPosition)position {
    if(position != self.position && self.initializing == NO) {
        _initializing = YES;
        /*We setup the input*/
        NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
        AVCaptureDevice *camera;
        _position = position;
        for(AVCaptureDevice *device in cameras) {
            if([device position] == (AVCaptureDevicePosition)position) {
                camera = device;
            }
        }
        
        AVCaptureDeviceInput *captureInput = [AVCaptureDeviceInput
                                              deviceInputWithDevice:camera
                                              error:nil];
        
        /*We setupt the output*/
        AVCaptureVideoDataOutput *captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        
        /*While a frame is processes in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
         If you don't want this behaviour set the property to NO */
        captureOutput.alwaysDiscardsLateVideoFrames = YES;
        
        /*We create a serial queue to handle the processing of our frames*/
        __block dispatch_queue_t queue;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            queue = dispatch_queue_create("cameraQueue", NULL);
        });
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
        self.previewLayer.backgroundColor = [UIColor clearColor].CGColor;
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        
        /*We start the capture*/
        [self.captureSession startRunning];
        [self runMethod:@"initialized" afterDelay:0.5f];
    }
}

-(void)swapCameraPosition:(C4CameraPosition)position {
    //FIXME: tweak the switching of camera positions
    //make sure that you're not always initiailizing if you don't need to.
}

-(void)initialized {
    _initializing = NO;
}

-(void)captureImage {
    if(!self.stillImageOutput.isCapturingStillImage) {
        AVCaptureConnection *captureConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        typedef void (^AVBufferBlock)(CMSampleBufferRef, NSError *);
        AVBufferBlock bufferBlock = ^(CMSampleBufferRef buf, NSError *err) {
            err = [NSError errorWithDomain:@"captureImage error" code:0 userInfo:nil];
            NSData *d = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:buf];

            if(self.position == C4CameraFront) {
                //Orient the image so its the same as the preview layer
                UIImage *img = [UIImage imageWithData:d];
                CGImageRef imgRef = [img CGImage];
                UIImage *flipped = [UIImage imageWithCGImage:imgRef
                                                       scale:img.scale
                                                 orientation:UIImageOrientationLeftMirrored];
                _capturedImage = [C4Image imageWithUIImage:flipped];
                C4Log(@"%d",img.imageOrientation);
                img = nil;
                flipped = nil;
                CGImageRelease(imgRef);
            } else {
                _capturedImage = [C4Image imageWithData:d];
            }
            
            [self postNotification:@"imageWasCaptured"];
        };
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:captureConnection
                                                           completionHandler:bufferBlock];
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