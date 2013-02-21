//
//  UIColor+CIColorFix.m
//  C4iOS
//
//  Created by moi on 13-02-21.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "UIColor+CIColorFix.h"

@implementation UIColor (CIColorFix)
-(CIColor *)CIColor {
    CGFloat rgba[4];
    [self getRed:&rgba[0] green:&rgba[1] blue:&rgba[2] alpha:&rgba[3]];
    return [CIColor colorWithRed:rgba[0] green:rgba[1] blue:rgba[2] alpha:rgba[3]];
}
@end
