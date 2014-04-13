//
//  UIView+C4AddControl.h
//  C4iOS
//
//  Created by Slant on 2014-04-12.
//  Copyright (c) 2014 Slant. All rights reserved.
//

#import <UIKit/UIKit.h>

@class C4Control;
@interface UIView (C4AddControl)
-(void)addSubview:(id)view;
-(void)addControl:(C4Control *)control;
@end
