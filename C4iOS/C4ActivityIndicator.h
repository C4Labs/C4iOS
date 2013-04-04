//
//  C4ActivityMonitor.h
//  C4iOS
//
//  Created by moi on 13-03-06.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Control.h"

typedef NS_ENUM(NSInteger, C4ActivityIndicatorStyle) {
    WHITELARGE,
    WHITE,
    GRAY,
};

@interface C4ActivityIndicator : C4Control <C4UIElement>

+(C4ActivityIndicator *)indicatorWithStyle:(C4ActivityIndicatorStyle)style;
-(id)initWithActivityIndicatorStyle:(C4ActivityIndicatorStyle)style;
-(void)startAnimating;
-(void)stopAnimating;
-(BOOL)isAnimating;

+(C4ActivityIndicator *)defaultStyle;

@property (readonly, nonatomic, strong) UIActivityIndicatorView *UIActivityIndicatorView;
@property (readwrite, nonatomic) C4ActivityIndicatorStyle activityIndicatorStyle;
@property (readwrite, nonatomic) BOOL hidesWhenStopped;
@property (readwrite, nonatomic, strong) UIColor *color NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@end