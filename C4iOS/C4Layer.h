//
//  C4Layer.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface C4Layer : CALayer {
}

-(void)setup;

-(void)listenFor:(NSString *)aNotification andRunMethod:(NSString *)aMethodName;
-(void)stopListeningFor:(NSString *)aMethodName;
-(void)postNotification:(NSString *)aNotification;
-(void)test;

@property (nonatomic, readwrite) NSTimeInterval timeStamp;
@end