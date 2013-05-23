//
//  NewSlider.h
//  C4iOS
//
//  Created by moi on 13-02-27.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//
#import "C4Control.h"
/**This document describes the C4Slider class. An instance of the C4Slider class implements a slider on the touch screen. A slider intercepts touch events and sends an action message to a target object when its value has changed, or for other touch events.
 
 A C4Slider object is a visual control used to select a single value from a continuous range of values. Sliders are always displayed as horizontal bars. An indicator, or thumb, notes the current value of the slider and can be moved by the user to change the setting.
 
 The most common way to customize the slider’s appearance is to provide custom minimum and maximum value images. These images sit at either end of the slider control and indicate which value that end of the slider represents. For example, a slider used to control volume might display a small speaker with no sound waves emanating from it for the minimum value and display a large speaker with many sound waves emanating from it for the maximum value.
 
 The bar on which the thumb rides is referred to as the slider’s track. Slider controls draw the track using two distinct images, which are customizable. 
 
 The region between the thumb and the end of the track associated with the slider’s minimum value is drawn using the minimum track image. 
 
 The region between the thumb and the end of the track associated with the slider’s maximum value is drawn using the maximum track image.
 
 Different track images are used in order to provide context as to which end contains the minimum value. For example, the minimum track image typically contains a blue highlight while the maximum track image contains a white highlight. 
 
 You can assign different tint colors for all of the standard parts provided by the slider, or you customize the appearance further by assigning different pairs of track images to each of the control states of the slider. Assigning different images to each state lets you customize the appearance of the slider when it is enabled, disabled, highlighted, and so on.
 
 In addition to customizing the track images, you can also customize the appearance of the thumb itself. Like the track images, you can assign different thumb images to each control state of the slider.
 
 Note: The slider control provides a set of default images for both the track and thumb. If you do not specify any custom images, those images are used automatically.

 */
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