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
@property (readonly, strong, nonatomic) UIButton *UIButton;
@property (readonly, weak, nonatomic) C4Label *titleLabel;
@property (readwrite, nonatomic) BOOL reversesTitleShadowWhenHighlighted;

//contentVerticalAlignment  property
//contentHorizontalAlignment  property
//
//tracking  property
//touchInside  property

//Tasks
//
//Configuring the Button Title
//titleLabel  property
//reversesTitleShadowWhenHighlighted  property
//– setTitle:forState:
//– setAttributedTitle:forState:
//– setTitleColor:forState:
//– setTitleShadowColor:forState:
//– titleColorForState:
//– titleForState:
//– attributedTitleForState:
//– titleShadowColorForState:
//Configuring Button Presentation
//adjustsImageWhenHighlighted  property
//adjustsImageWhenDisabled  property
//showsTouchWhenHighlighted  property
//– backgroundImageForState:
//– imageForState:
//– setBackgroundImage:forState:
//– setImage:forState:
//tintColor  property
//Configuring Edge Insets
//contentEdgeInsets  property
//titleEdgeInsets  property
//imageEdgeInsets  property
//Getting the Current State
//buttonType  property
//currentTitle  property
//currentAttributedTitle  property
//currentTitleColor  property
//currentTitleShadowColor  property
//currentImage  property
//currentBackgroundImage  property
//imageView  property
//Getting Dimensions
//– backgroundRectForBounds:
//– contentRectForBounds:
//– titleRectForContentRect:
//– imageRectForContentRect:
//Deprecated Properties
//font  property Deprecated in iOS 3.0
//lineBreakMode  property Deprecated in iOS 3.0
//titleShadowOffset  property Deprecated in iOS 3.0

@end
