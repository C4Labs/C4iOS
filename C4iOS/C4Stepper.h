//
//  C4Stepper.h
//  C4iOS
//
//  Created by moi on 13-03-05.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Control.h"

@interface C4Stepper : C4Control <C4UIElement>

+(C4Stepper *)defaultStyle;
+(C4Stepper *)stepper;
@property (readonly, nonatomic, strong) UIStepper *UIStepper;

@property(nonatomic,getter=isContinuous) BOOL continuous;
@property(nonatomic) BOOL autorepeat, wraps;
@property(readwrite, nonatomic) CGFloat value, minimumValue, maximumValue, stepValue;
@property(readwrite, nonatomic, strong) UIColor *tintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;

-(void)setBackgroundImage:(C4Image*)image forState:(C4ControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
-(C4Image*)backgroundImageForState:(C4ControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;

-(void)setDividerImage:(C4Image*)image forLeftSegmentState:(C4ControlState)leftState rightSegmentState:(C4ControlState)rightState NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
-(C4Image*)dividerImageForLeftSegmentState:(C4ControlState)state rightSegmentState:(C4ControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;

-(void)setIncrementImage:(C4Image *)image forState:(C4ControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
-(C4Image *)incrementImageForState:(C4ControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;

-(void)setDecrementImage:(C4Image *)image forState:(C4ControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
-(C4Image *)decrementImageForState:(C4ControlState)state NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
-(BOOL)isEqual:(id)object;
@end
