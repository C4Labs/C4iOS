//
//  C4CaptureVideoPreviewLayer.h
//  cameraVieweriPhone
//
//  Created by Travis Kirton on 12-05-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/**This document describes the C4CaptureVideoPreviewLayer class.
 
 C4CaptureVideoPreviewLayer is a subclass of AVCaptureVideoPreviewLayer and conforms to the C4LayerAnimation protocol. It is the default backing layer for a C4Movie object.
 
 @warning You should never access this object directly.
 */
@interface C4CaptureVideoPreviewLayer : AVCaptureVideoPreviewLayer <C4LayerAnimation>

@end
