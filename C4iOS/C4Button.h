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

@property (readonly, strong, nonatomic) UIButton *UIButton;
@property(nonatomic) UIEdgeInsets contentEdgeInsets, titleEdgeInsets, imageEdgeInsets;
@property(nonatomic) BOOL reversesTitleShadowWhenHighlighted, adjustsImageWhenHighlighted,adjustsImageWhenDisabled,showsTouchWhenHighlighted;
@property(nonatomic,retain) UIColor *tintColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; 
@property(nonatomic,readonly) C4ButtonType buttonType;
@property(nonatomic,readonly, weak) NSString *currentTitle;
@property(nonatomic,readonly, weak) NSAttributedString *currentAttributedTitle NS_AVAILABLE_IOS(6_0);
@property(nonatomic,readonly, weak) UIColor *currentTitleColor, *currentTitleShadowColor;
@property(nonatomic,readonly, weak) C4Image *currentImage, *currentBackgroundImage;

@end
