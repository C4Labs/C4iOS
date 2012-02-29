//
//  C4Control.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 should add https://developer.apple.com/library/ios/#qa/qa1673/_index.html
 and animating along a path 
 */

@interface C4Control : UIControl <C4NotificationMethods, C4GestureMethods> {
}

@property CGFloat animationDuration, animationDelay;
@property (nonatomic) NSUInteger animationOptions;
@property (nonatomic) CGFloat repeatCount;
@property (readonly, nonatomic) BOOL isAnimating;
@property (readonly, strong) NSMutableDictionary *gestureDictionary;
@property (nonatomic) CGPoint origin;
@end
