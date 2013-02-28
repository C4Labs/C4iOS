//
//  C4UISlider.m
//  C4iOS
//
//  Created by moi on 13-02-27.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4UISlider.h"

@implementation C4UISlider

- (id)initWithFrame:(CGRect)frame delegate:(NewSlider *)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
    }
    return self;
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    return [super beginTrackingWithTouch:touch withEvent:event];
}
@end
