//
//  C4CommonMethods.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol C4NotificationMethods <NSObject>

#pragma mark Notification Methods
-(void)setup;
-(void)listenFor:(NSString *)aNotification andRunMethod:(NSString *)aMethodName;
-(void)listenFor:(NSString *)aNotification fromObject:(id)anObject andRunMethod:(NSString *)aMethodName;
-(void)stopListeningFor:(NSString *)aMethodName;
-(void)postNotification:(NSString *)aNotification;

@end
