//
//  C4PlayerLayer.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-11.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

/** This document describes the C4PlayerLayer, an extension of AVPlayerLayer with specific additions for the C4Movie class.
 
 @warning You should never have to access or create this object directly, it is meant to be used solely within the C4Movie object.
 */

@interface C4PlayerLayer : AVPlayerLayer <C4LayerAnimation>

@end
