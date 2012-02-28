//
//  C4Label.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Label.h"

@implementation C4Label
@synthesize C4Font, UIFont, textAlignment, lineBreakMode, baselineAdjustment;
-(void)setup {}

-(void)listenFor:(NSString *)aNotification andRunMethod:(NSString *)aMethodName{
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(aMethodName) name:aNotification object:nil];
}

-(void)listenFor:(NSString *)aNotification fromObject:(id)anObject andRunMethod:(NSString *)aMethodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(aMethodName) name:aNotification object:anObject];
}

-(void)stopListeningFor:(NSString *)aMethodName {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:aMethodName object:nil];
}

-(void)postNotification:(NSString *)aNotification {
	[[NSNotificationCenter defaultCenter] postNotificationName:aNotification object:self];
}
@end
