//
//  NewSlider.h
//  C4iOS
//
//  Created by moi on 13-02-27.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//
#import "C4Control.h"

@interface C4Slider : C4Control <C4UIElement>

+(C4Slider *)defaultStyle;
+(C4Slider *)slider:(CGRect)rect;
-(id)initWithFrame:(CGRect)frame defaults:(BOOL)useDefaults;

-(C4Image *)maximumTrackImageForState:(C4ControlState)state;
-(void)setMaximumTrackImage:(C4Image *)image forState:(C4ControlState)state;

-(C4Image *)minimumTrackImageForState:(C4ControlState)state;
-(void)setMinimumTrackImage:(C4Image *)image forState:(C4ControlState)state;

-(C4Image *)thumbImageForState:(C4ControlState)state;
-(void)setThumbImage:(C4Image *)image forState:(C4ControlState)state;

-(void)setValue:(CGFloat)value animated:(BOOL)animated;

@property (readonly, nonatomic) UISlider *UISlider;
@property (readwrite, nonatomic) CGFloat maximumValue, minimumValue, value;
@property(nonatomic, weak) C4Image *minimumValueImage, *maximumValueImage;
@property(nonatomic,getter=isContinuous) BOOL continuous;
@property(readwrite, nonatomic,weak) UIColor *minimumTrackTintColor, *maximumTrackTintColor, *thumbTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property(readonly, nonatomic, weak) C4Image* currentThumbImage;
@property(readonly, nonatomic, weak) C4Image* currentMinimumTrackImage;
@property(readonly, nonatomic, weak) C4Image* currentMaximumTrackImage;

@end