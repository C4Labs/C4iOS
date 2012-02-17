//
//  UITouch+C4Touch.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-08.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class C4Foundation;

@interface UITouch (C4Touch) 
-(CGFloat)majorRadius;
-(NSTimeInterval)timeStamp;
@end