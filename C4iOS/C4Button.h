//
//  C4Button.h
//  C4iOS
//
//  Created by moi on 13-02-28.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Control.h"

@interface C4Button : C4Control <C4UIElement>

+(C4Button *)defaultStyle;
+(C4Button *)buttonWithType:(C4ButtonType)type;
-(id)initWithType:(C4ButtonType)type;

-(NSString *)titleForState:(C4ControlState)state; // these getters only take a single state value
-(void)setTitle:(NSString *)title forState:(C4ControlState)state;

-(UIColor *)titleColorForState:(C4ControlState)state;
-(void)setTitleColor:(UIColor *)color forState:(C4ControlState)state;

-(UIColor *)titleShadowColorForState:(C4ControlState)state;
-(void)setTitleShadowColor:(UIColor *)color forState:(C4ControlState)state;

-(C4Image *)imageForState:(C4ControlState)state;
-(void)setImage:(C4Image *)image forState:(C4ControlState)state;

-(C4Image *)backgroundImageForState:(C4ControlState)state;
-(void)setBackgroundImage:(C4Image *)image forState:(C4ControlState)state;

-(NSAttributedString *)attributedTitleForState:(C4ControlState)state NS_AVAILABLE_IOS(6_0);
-(void)setAttributedTitle:(NSAttributedString *)title forState:(C4ControlState)state NS_AVAILABLE_IOS(6_0);

@property (readwrite, nonatomic, weak) C4Font *font;
@property (readonly, strong, nonatomic) UIButton *UIButton;
@property (readwrite, nonatomic) UIEdgeInsets contentEdgeInsets, titleEdgeInsets, imageEdgeInsets;
@property (readwrite, nonatomic) BOOL reversesTitleShadowWhenHighlighted, adjustsImageWhenHighlighted,adjustsImageWhenDisabled,showsTouchWhenHighlighted;
@property (readwrite, nonatomic, strong) UIColor *tintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (readonly, nonatomic) C4ButtonType buttonType;
@property (readonly, nonatomic, weak) NSString *currentTitle;
@property (readonly, nonatomic, weak) NSAttributedString *currentAttributedTitle NS_AVAILABLE_IOS(6_0);
@property (readonly, nonatomic, weak) UIColor *currentTitleColor, *currentTitleShadowColor;
@property (readonly, nonatomic, weak) C4Image *currentImage, *currentBackgroundImage;

@end
