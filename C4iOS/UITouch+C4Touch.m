//
//  UITouch+C4Touch.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-08.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "UITouch+C4Touch.h"

@implementation UITouch (C4Touch) 
-(CGFloat)majorRadius {
    return _pathMajorRadius;
}
-(NSTimeInterval)timeStamp {
    return _timestamp;
}
@end
