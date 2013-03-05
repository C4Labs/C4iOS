//
//  UISlider+CopyWithZone.m
//  C4iOS
//
//  Created by travis on 2013-03-04.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "UISlider+CopyWithZone.h"

@implementation UISlider (CopyWithZone)
-(UISlider *)copyWithZone:(NSZone *)zone {
    UISlider *newSlider = [[UISlider allocWithZone:zone] initWithFrame:self.frame];

    [newSlider setMaximumTrackImage:[self maximumTrackImageForState:UIControlStateApplication] forState:UIControlStateApplication];
    [newSlider setMaximumTrackImage:[self maximumTrackImageForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [newSlider setMaximumTrackImage:[self maximumTrackImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [newSlider setMaximumTrackImage:[self maximumTrackImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [newSlider setMaximumTrackImage:[self maximumTrackImageForState:UIControlStateReserved] forState:UIControlStateReserved];
    [newSlider setMaximumTrackImage:[self maximumTrackImageForState:UIControlStateSelected] forState:UIControlStateSelected];

    [newSlider setMinimumTrackImage:[self maximumTrackImageForState:UIControlStateApplication] forState:UIControlStateApplication];
    [newSlider setMinimumTrackImage:[self maximumTrackImageForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [newSlider setMinimumTrackImage:[self maximumTrackImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [newSlider setMinimumTrackImage:[self maximumTrackImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [newSlider setMinimumTrackImage:[self maximumTrackImageForState:UIControlStateReserved] forState:UIControlStateReserved];
    [newSlider setMinimumTrackImage:[self maximumTrackImageForState:UIControlStateSelected] forState:UIControlStateSelected];

    [newSlider setThumbImage:[self thumbImageForState:UIControlStateApplication] forState:UIControlStateApplication];
    [newSlider setThumbImage:[self thumbImageForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [newSlider setThumbImage:[self thumbImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [newSlider setThumbImage:[self thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [newSlider setThumbImage:[self thumbImageForState:UIControlStateReserved] forState:UIControlStateReserved];
    [newSlider setThumbImage:[self thumbImageForState:UIControlStateSelected] forState:UIControlStateSelected];

    [newSlider setMaximumValueImage:[self maximumValueImage]];
    [newSlider setMinimumValueImage:[self minimumValueImage]];
    
    [newSlider setMaximumTrackTintColor:[self minimumTrackTintColor]];
    [newSlider setMinimumTrackTintColor:[self minimumTrackTintColor]];
    [newSlider setThumbTintColor:[self thumbTintColor]];

    [newSlider setMaximumValue:[self maximumValue]];
    [newSlider setMinimumValue:[self minimumValue]];
    [newSlider setValue:[self value]];
    
    return newSlider;
}
@end
