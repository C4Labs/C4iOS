//
//  C4Label.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C4Label : C4Control {
}
-(void)sizeToFit;

@property (readonly, strong, nonatomic) UILabel *label;
@property (readwrite, strong, nonatomic) NSString *text;
@property (readwrite, strong, nonatomic) C4Font *font;
@property (readwrite, nonatomic) BOOL adjustsFontSizeToFitWidth;
@property (readwrite, nonatomic) C4BaselineAdjustment baselineAdjustment;
@property (nonatomic, getter=isHighlighted) BOOL highlighted;
@property (readwrite, strong, nonatomic) UIColor *textColor;
@property (readwrite, nonatomic) C4TextAlignment textAlignment;
@property (readwrite, nonatomic) C4LineBreakMode lineBreakMode;
@property (readwrite, nonatomic) CGFloat minimumFontSize, shadowRadius, shadowOpacity;
@property (readwrite, nonatomic) NSUInteger numberOfLines;
@property (readwrite, strong, nonatomic) UIColor *highlightedTextColor;
@property (readwrite, strong, nonatomic) UIColor *shadowColor, *textShadowColor;
@property (readwrite, nonatomic) CGSize shadowOffset, textShadowOffset;

@end

