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
-(void)setImage:(C4Image *)image forState:(C4ControlState)state;

-(C4Image *)maximumTrackImageForState:(C4ControlState)state;
-(void)setMaximumTrackImage:(C4Image *)image forState:(C4ControlState)state;
-(C4Image *)minimumTrackImageForState:(C4ControlState)state;
-(void)setMinimumTrackImage:(C4Image *)image forState:(C4ControlState)state;
-(C4Image *)thumbImageForState:(C4ControlState)state;
-(void)setThumbImage:(C4Image *)image forState:(C4ControlState)state;

@property (readonly, weak, nonatomic) C4Image *currentMaximumTrackImage, *currentMinimumTrackImage, *currentThumbImage;
@property (readwrite, nonatomic, strong) UIColor *thumbColor, *minimumTrackColor, *maximumTrackColor;

//FIXME: Decide whether or not to keep the majority of these properties...
//NOTE: realized that it's silly to have properties for each "kind" of image... when it comes to buttons there's soooo many options
@property (readwrite, nonatomic, strong) C4Image *maximumValueImage, *minimumValueImage;
@property (readwrite, nonatomic, strong) C4Image *thumbImage, *thumbImageHighlighted, *thumbImageDisabled, *thumbImageSelected;
@property (readwrite, nonatomic, strong) C4Image *minimumTrackImage, *minimumTrackImageHighlighted, *minimumTrackImageDisabled, *minimumTrackImageSelected;
@property (readwrite, nonatomic, strong) C4Image *maximumTrackImage, *maximumTrackImageHighlighted, *maximumTrackImageDisabled, *maximumTrackImageSelected;
@property (readonly, nonatomic) UISlider *UISlider;
@property (readonly, nonatomic) CGFloat value, minimumValue, maximumValue;
-(void)setValue:(CGFloat)value animated:(BOOL)animated;
@property (readwrite, nonatomic) NSDictionary *style;

@end