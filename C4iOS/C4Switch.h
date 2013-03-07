//
//  C4Switch.h
//  C4iOS
//
//  Created by moi on 13-03-05.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Control.h"

@interface C4Switch : C4Control <C4UIElement>

+(C4Switch *)defaultStyle;
@property (readonly, nonatomic) UISwitch *UISwitch;

+(C4Switch *)switch:(CGRect)frame;
+(C4Switch *)switch;
-(id)initWithFrame:(CGRect)frame;
-(void)setOn:(BOOL)on animated:(BOOL)animated;

@property (readwrite, nonatomic, strong) UIColor *onTintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, strong) UIColor *tintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, strong) UIColor *thumbTintColor NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, strong) C4Image *onImage NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, strong) C4Image *offImage NS_AVAILABLE_IOS(6_0) UI_APPEARANCE_SELECTOR;
@property (readwrite, nonatomic, getter=isOn) BOOL on;
@end
