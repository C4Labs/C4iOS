//
//  C4Label.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Label.h"

@interface C4Label()
@end

@implementation C4Label
@synthesize adjustsFontSizeToFitWidth = _adjustsFontSizeToFitWidth;
@synthesize baselineAdjustment = _baselineAdjustment;
@synthesize font = _font;
@synthesize highlighted = _highlighted;
@synthesize highlightedTextColor = _highlightedTextColor;
@synthesize lineBreakMode = _lineBreakMode;
@synthesize minimumFontSize = _minimumFontSize;
@synthesize numberOfLines = _numberOfLines;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowOpacity = _shadowOpacity;
@synthesize shadowRadius = _shadowRadius;
@synthesize textAlignment = _textAlignment;
@synthesize textColor = _textColor;
@synthesize textShadowColor = _textShadowColor;
@synthesize textShadowOffset = _textShadowOffset;
@synthesize text = _text;
@synthesize label = _label;

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    if(CGRectEqualToRect(frame, CGRectZero)) frame = CGRectMake(0, 0, 1, 1);
    self = [super initWithFrame:frame];
    if(self != nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _label.textColor = [UIColor blackColor];
        _label.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
    }
    return self;
}

-(void)sizeToFit {
    [self.label sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.label.frame.size.width, self.label.frame.size.height);
}


#pragma mark C4Label Methods
-(void)setBackgroundColor:(UIColor *)backgroundColor {
    _label.backgroundColor = backgroundColor;
}

-(UIColor *)backroundColor {
    return _label.backgroundColor;
}

-(void)setText:(NSString *)text {
    self.label.text = text;
}

-(NSString *)text {
    return self.label.text;
}

-(void)setTextShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.label.shadowColor = shadowColor;
}

-(void)setTextShadowOffset:(CGSize)shadowOffset {
    _shadowOffset = shadowOffset;
    self.label.shadowOffset = shadowOffset;
}

-(void)touchesBegan {
    self.center = CGPointMake([C4Math randomInt:768], [C4Math randomInt:1024]);
}

-(void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];//weeeeeeird bug if this isn't included
    self.label.enabled = enabled;
}

-(void)setFont:(C4Font *)font {
    self.label.font = font.UIFont;
}

-(void)setTextColor:(UIColor *)textColor {
    self.label.textColor = textColor;
}

-(UIColor *)textColor {
    return self.label.textColor;
}

-(BOOL)isHighlighted {
    return self.label.isHighlighted;
}

-(void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    self.label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
}

-(BOOL)adjustsFontSizeToFitWidth {
    return self.label.adjustsFontSizeToFitWidth;
}

-(void)setBaselineAdjustment:(C4BaselineAdjustment)baselineAdjustment {
    self.label.baselineAdjustment = (UIBaselineAdjustment)baselineAdjustment;
}

-(C4BaselineAdjustment)baselineAdjustment {
    return (C4BaselineAdjustment)self.label.baselineAdjustment;
}

-(void)setTextAlignment:(C4TextAlignment)textAlignment {
    self.label.textAlignment = (UITextAlignment)textAlignment;
}

-(C4TextAlignment)textAlignment {
    return (C4TextAlignment)self.label.textAlignment;
}

-(void)setLineBreakMode:(C4LineBreakMode)lineBreakMode {
    self.label.lineBreakMode = (UILineBreakMode)lineBreakMode;
}

-(C4LineBreakMode)lineBreakMode {
    return (C4LineBreakMode)self.label.lineBreakMode;
}

-(void)setMinimumFontSize:(CGFloat)minimumFontSize {
    self.label.minimumFontSize = minimumFontSize;
}

-(CGFloat)minimumFontSize {
    return self.label.minimumFontSize;
}

-(void)setNumberOfLines:(NSUInteger)numberOfLines {
    self.label.numberOfLines = numberOfLines;
}

-(NSUInteger)numberOfLines {
    return self.label.numberOfLines;
}

-(void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    self.label.highlightedTextColor = highlightedTextColor;
}

-(UIColor *)highlightedTextColor {
    return self.label.highlightedTextColor;
}

-(void)test {
    self.text = @"texting texting 1.2.3";
    [self sizeToFit];
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

-(void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

@end
