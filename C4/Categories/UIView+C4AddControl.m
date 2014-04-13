//
//  UIView+C4AddControl.m
//  C4iOS
//
//  Created by Slant on 2014-04-12.
//  Copyright (c) 2014 Slant. All rights reserved.
//

#import "UIView+C4AddControl.h"

@implementation UIView (C4AddControl)

-(void)addSubview:(id)view {
    UIView *_view;
    if([view isKindOfClass:[C4Control class]]) {
        _view = ((C4Control *)view).view;
    } else {
        _view = view;
    }
    [self insertSubview:_view atIndex:self.subviews.count];
}

@end
