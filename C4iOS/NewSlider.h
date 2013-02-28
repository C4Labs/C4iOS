//
//  NewSlider.h
//  C4iOS
//
//  Created by moi on 13-02-27.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//
@class C4UISlider;
#import "C4Control.h"

@interface NewSlider : C4Control

+(NewSlider *)defaultStyle;
+(NewSlider *)slider:(CGRect)rect;
-(id)initWithFrame:(CGRect)frame defaults:(BOOL)useDefaults;

-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event;
-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event;

@property (readwrite, nonatomic, strong) C4Image *maximumValueImage, *minimumValueImage;
@property (readwrite, nonatomic, strong) C4Image *thumbImage, *thumbImageHighlighted, *thumbImageDisabled, *thumbImageSelected;
@property (readwrite, nonatomic, strong) C4Image *minimumTrackImage, *minimumTrackImageHighlighted, *minimumTrackImageDisabled, *minimumTrackImageSelected;
@property (readwrite, nonatomic, strong) C4Image *maximumTrackImage, *maximumTrackImageHighlighted, *maximumTrackImageDisabled, *maximumTrackImageSelected;
@property (readwrite, nonatomic, strong) UIColor *thumbColor, *minimumTrackColor, *maximumTrackColor;
@property (readonly, nonatomic) UISlider *UISlider;
@property (readonly, nonatomic) CGFloat value, minimumValue, maximumValue;
-(void)setValue:(CGFloat)value animated:(BOOL)animated;
@property (readwrite, nonatomic) NSDictionary *style;

@end