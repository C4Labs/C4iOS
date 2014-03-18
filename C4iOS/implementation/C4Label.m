//
//  C4Label.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Label.h"

@interface C4Label()
//@property (readwrite, atomic) BOOL shouldAutoreverse;
@property (readonly, atomic) NSArray *localStylePropertyNames;
@end

@implementation C4Label
@synthesize textShadowColor = _textShadowColor;
@synthesize width = _width, height = _height;
@synthesize size = _size;

-(id)init {
    return [self initWithFrame:CGRectZero];
}

+(C4Label *)labelWithText:(NSString *)text {
    return [[C4Label alloc] initWithText:text];
}

+(C4Label *)labelWithText:(NSString *)text font:(C4Font *)font {
    return [[C4Label alloc] initWithText:text font:font];
}

+(C4Label *)labelWithText:(NSString *)text font:(C4Font *)font frame:(CGRect)frame {
    return [[C4Label alloc] initWithText:text font:font frame:frame];
}

-(id)initWithText:(NSString *)text {
    return [self initWithText:text font:[C4Font systemFontOfSize:24.0f]];
}

-(id)initWithText:(NSString *)text font:(C4Font *)font {
    UILabel *newLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    newLabel.text = text;
    newLabel.font = font.UIFont;
    [newLabel sizeToFit];
    return [self initWithText:text font:font frame:newLabel.frame];
}

-(id)initWithText:(NSString *)text font:(C4Font *)font frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if(self != nil) {
        self.text = text; 
        self.font = font;
    }
    return self;
}

-(id)initWithUILabel:(UILabel *)aLabel {
    self = [super initWithFrame:aLabel.frame];
    if(self != nil) {
        _label = [aLabel copy];
        [self addSubview:_label];
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    if(CGRectEqualToRect(frame, CGRectZero)) frame = CGRectMake(0, 0, 1, 1);
    self = [super initWithFrame:frame];
    if(self != nil) {
        _label = [[UILabel alloc] initWithFrame:self.bounds];
        _label.textColor = self.textColor;
        _label.highlightedTextColor = self.highlightedTextColor;
        _label.backgroundColor = [UIColor clearColor];
        _label.shadowColor = [UIColor clearColor];

        [self addSubview:(UILabel *)_label];
        [self setup];
    }
    return self;
}

-(void)dealloc {
    self.text = nil;
    [_label removeFromSuperview];
    _label = nil;
}

-(void)sizeToFit {
    [self _sizeToFit];
}

-(void)_sizeToFit {
    [self.label sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.label.frame.size.width, self.label.frame.size.height);
}

#pragma mark C4Label Methods

-(UIColor *)backroundColor {
    return _label.backgroundColor;
}

-(void)setText:(NSString *)text {
    if(self.animationDelay == 0.0f) self.label.text = text;
    else [self performSelector:@selector(_setText:) withObject:text afterDelay:self.animationDelay];
}
-(void)_setText:(NSString *)text {
    self.label.text = text;
}

-(NSString *)text {
    return self.label.text;
}

-(UIColor *)textShadowColor {
    return self.label.shadowColor;
}

-(void)setTextShadowColor:(UIColor *)shadowColor {
    if(self.animationDelay == 0.0f) self.label.shadowColor = shadowColor;
    else [self performSelector:@selector(_setTextShadowColor:) withObject:shadowColor afterDelay:self.animationDelay];
}
-(void)_setTextShadowColor:(UIColor *)shadowColor {
    _textShadowColor = shadowColor;
    self.label.shadowColor = shadowColor;
}

-(void)setTextShadowOffset:(CGSize)shadowOffset {
    if (self.animationDelay == 0.0f) [self _setTextShadowOffset:[NSValue valueWithCGSize:shadowOffset]];
    else [self performSelector:@selector(_setTextShadowOffset:) withObject:[NSValue valueWithCGSize:shadowOffset] afterDelay:self.animationDelay];
}
-(void)_setTextShadowOffset:(NSValue *)shadowOffset {
    _textShadowOffset = [shadowOffset CGSizeValue];
    self.label.shadowOffset = [shadowOffset CGSizeValue];
}

-(void)setEnabled:(BOOL)enabled {
    if(self.animationDelay == 0.0f) [self _setEnabled:@(enabled)];
    else [self performSelector:@selector(_setEnabled:) withObject:@(enabled) afterDelay:self.animationDelay];
}

-(void)_setEnabled:(NSNumber *)enabled {
    [super setEnabled:[enabled boolValue]];//weeeeeeird bug if this isn't included
    self.label.enabled = [enabled boolValue];
}

-(C4Font *)font {
    UIFont *ui = self.label.font;
    C4Font *newFont = [C4Font fontWithName:ui.fontName size:ui.pointSize];
    return newFont;
}

-(void)setFont:(C4Font *)font {
    if(self.animationDelay == 0.0f) [self _setFont:font];
    else [self performSelector:@selector(_setFont:) withObject:font afterDelay:self.animationDelay];
}

-(void)_setFont:(C4Font *)font {
    self.label.font = font.UIFont;
}

-(void)setFrame:(CGRect)frame {
    super.frame = frame;
    self.label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

-(void)setTextColor:(UIColor *)textColor {
    if(self.animationDelay == 0.0f) [self _setTextColor:textColor];
    else [self performSelector:@selector(_setTextColor:) withObject:textColor afterDelay:self.animationDelay];

}
-(void)_setTextColor:(UIColor *)textColor {
    self.label.textColor = textColor;
}

-(UIColor *)textColor {
    return self.label.textColor;
}

-(void)setHighlighted:(BOOL)highlighted {
    self.label.highlighted = highlighted;
}

-(BOOL)isHighlighted {
    return self.label.isHighlighted;
}

-(void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    if(self.animationDelay == 0.0f) [self _setAdjustsFontSizeToFitWidth:@(adjustsFontSizeToFitWidth)];
    else [self performSelector:@selector(_setAdjustsFontSizeToFitWidth:)
                    withObject:@(adjustsFontSizeToFitWidth)
                    afterDelay:self.animationDelay];
}
-(void)_setAdjustsFontSizeToFitWidth:(NSNumber *)adjustsFontSizeToFitWidth {
    self.label.adjustsFontSizeToFitWidth = [adjustsFontSizeToFitWidth boolValue];
}

-(BOOL)adjustsFontSizeToFitWidth {
    return self.label.adjustsFontSizeToFitWidth;
}

-(void)setBaselineAdjustment:(C4BaselineAdjustment)baselineAdjustment {
    if(self.animationDelay == 0.0f) [self _setBaselineAdjustment:@(baselineAdjustment)];
    else [self performSelector:@selector(_setBaselineAdjustment:)
                    withObject:@(baselineAdjustment)
                    afterDelay:self.animationDelay];
}
-(void)_setBaselineAdjustment:(NSNumber *)baselineAdjustment {
    self.label.baselineAdjustment = (UIBaselineAdjustment)[baselineAdjustment intValue];
}

-(C4BaselineAdjustment)baselineAdjustment {
    return (C4BaselineAdjustment)self.label.baselineAdjustment;
}

-(void)setTextAlignment:(C4TextAlignment)textAlignment {
    if(self.animationDelay == 0.0f) [self _setTextAlignment:@(textAlignment)];
    else [self performSelector:@selector(_setTextAlignment:) withObject:@(textAlignment) afterDelay:self.animationDelay];
}
-(void)_setTextAlignment:(NSNumber *)textAlignment {
    self.label.textAlignment = (NSTextAlignment)[textAlignment intValue];
}

-(C4TextAlignment)textAlignment {
    return (C4TextAlignment)self.label.textAlignment;
}

-(void)setLineBreakMode:(C4LineBreakMode)lineBreakMode {
    if(self.animationDelay == 0.0f) [self _setLineBreakMode:@(lineBreakMode)];
    else [self performSelector:@selector(_setLineBreakMode:) withObject:@(lineBreakMode) afterDelay:self.animationDelay];
}
-(void)_setLineBreakMode:(NSNumber *)lineBreakMode {
    self.label.lineBreakMode = (NSLineBreakMode)[lineBreakMode integerValue];
}

-(C4LineBreakMode)lineBreakMode {
    return (C4LineBreakMode)self.label.lineBreakMode;
}

//-(void)setMinimumFontSize:(CGFloat)minimumFontSize {
//    if(self.animationDelay == 0.0f) [self _setMinimumFontSize:@(minimumFontSize)];
//    else [self performSelector:@selector(_setMinimumFontSize:)
//                    withObject:@(minimumFontSize)
//                    afterDelay:self.animationDelay];
//}

//-(void)_setMinimumFontSize:(NSNumber *)minimumFontSize {
//    self.label.minimumFontSize = [minimumFontSize floatValue];
//}

//-(CGFloat)minimumFontSize {
//    return self.label.minimumFontSize;
//}

-(void)setNumberOfLines:(NSUInteger)numberOfLines {
    if(self.animationDelay == 0.0f) [self _setNumberOfLines:@(numberOfLines)];
    else [self performSelector:@selector(_setNumberOfLines:) withObject:@(numberOfLines) afterDelay:self.animationDelay];
}
-(void)_setNumberOfLines:(NSNumber *)numberOfLines {
    self.label.numberOfLines = [numberOfLines intValue];
}

-(NSUInteger)numberOfLines {
    return self.label.numberOfLines;
}

-(void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    if(self.animationDelay == 0.0f) [self _setHighlightedTextColor:highlightedTextColor];
    else [self performSelector:@selector(_setHighlightedTextColor:) withObject:highlightedTextColor afterDelay:self.animationDelay];
}
-(void)_setHighlightedTextColor:(UIColor *)highlightedTextColor {
    self.label.highlightedTextColor = highlightedTextColor;
}

-(UIColor *)highlightedTextColor {
    return self.label.highlightedTextColor;
}

-(void)test {
}

#pragma mark C4Layer animation accessor methods

-(void)setBackgroundFilters:(NSArray *)backgroundFilters {
    if(self.animationDelay == 0.0f) [self _setBackgroundFilters:backgroundFilters];
    else [self performSelector:@selector(_setBackgroundFilters:) withObject:backgroundFilters afterDelay:self.animationDelay];
}
-(void)_setBackgroundFilters:(NSArray *)backgroundFilters {
    [self.backingLayer animateBackgroundFilters:backgroundFilters];
}

-(void)setCompositingFilter:(id)compositingFilter {
    [self.backingLayer performSelector:@selector(_setCompositingFilter:) withObject:compositingFilter afterDelay:self.animationDelay];
}
-(void)_setCompositingFilter:(id)compositingFilter {
    [self.backingLayer animateCompositingFilter:compositingFilter];
}

#pragma mark C4Layer-backed object methods
-(C4Layer *)backingLayer {
    return (C4Layer *)self.layer;
}

+(Class)layerClass {
    return [C4Layer class];
}

-(CGFloat)width {
    return self.bounds.size.width;
}

-(void)setWidth:(CGFloat)width {
    _width = width;
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

-(CGFloat)height {
    return self.bounds.size.height;
}

-(void)setHeight:(CGFloat)height {
    _height = height;
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

-(CGSize)size {
    return self.frame.size;
}

-(void)setSize:(CGSize)size {
    _size = size;
    CGRect newFrame = CGRectZero;
    newFrame.origin = self.origin;
    newFrame.size = size;
    self.frame = newFrame;
}

-(NSDictionary *)style {
    NSMutableDictionary *localStyle = [NSMutableDictionary dictionaryWithDictionary:
                                       @{
                                       @"adjustsFontSizeToFitWidth":@(self.adjustsFontSizeToFitWidth),
                                       @"baselineAdjustment":@(self.baselineAdjustment),
                                       @"highlighted":@(self.highlighted),
                                       @"lineBreakMode":@(self.lineBreakMode),
                                       @"numberOfLines":@(self.numberOfLines),
                                       @"textAlignment":@(self.textAlignment),
                                       @"textShadowOffset":[NSValue valueWithCGSize:self.textShadowOffset]
                                       }];
    if (self.font != nil) [localStyle setObject:self.font forKey:@"font"];
    if (self.highlightedTextColor != nil) [localStyle setObject:self.highlightedTextColor forKey:@"highlightedTextColor"];
    if (self.textColor != nil) [localStyle setObject:self.textColor forKey:@"textColor"];
    if (self.textShadowColor != nil) [localStyle setObject:self.textShadowColor forKey:@"textShadowColor"];
    
    NSMutableDictionary *localAndSuperStyle = [NSMutableDictionary dictionaryWithDictionary:localStyle];
    localStyle = nil;
    
    [localAndSuperStyle addEntriesFromDictionary:[super style]];
    return (NSDictionary *)localAndSuperStyle;
}

-(void)setStyle:(NSDictionary *)style {
    [super setStyle:style];
    
    NSArray *styleKeys = [style allKeys];
    NSString *key;
    
    //Local Style Values
    key = @"adjustsFontSizeToFitWidth";
    if([styleKeys containsObject:key]) self.adjustsFontSizeToFitWidth = [[style objectForKey:key] boolValue];
    
    key = @"baselineAdjustment";
    if([styleKeys containsObject:key]) self.baselineAdjustment = (C4BaselineAdjustment)[[style objectForKey:key] integerValue];
    
    key = @"font";
    if([styleKeys containsObject:key]) self.font = [style objectForKey:key];
    
    key = @"highlighted";
    if([styleKeys containsObject:key]) self.highlighted = [[style objectForKey:key] boolValue];
    
    key = @"highlightedTextColor";
    if([styleKeys containsObject:key]) self.highlightedTextColor = [style objectForKey:key];
    
    key = @"lineBreakMode";
    if([styleKeys containsObject:key]) self.lineBreakMode = (C4LineBreakMode)[[style objectForKey:key] integerValue];
    
    key = @"numberOfLines";
    if([styleKeys containsObject:key]) self.numberOfLines = [[style objectForKey:key] integerValue];
    
    key = @"textAlignment";
    if([styleKeys containsObject:key]) self.textAlignment = (C4TextAlignment)[[style objectForKey:key] integerValue];
    
    key = @"textColor";
    if([styleKeys containsObject:key]) self.textColor = [style objectForKey:key];

    key = @"textShadowColor";
    if([styleKeys containsObject:key]) self.textShadowColor = [style objectForKey:key];

    key = @"textShadowOffset";
    if([styleKeys containsObject:key]) self.textShadowOffset = [[style objectForKey:key] CGSizeValue];
}

+(C4Label *)defaultStyle {
    return (C4Label *)[C4Label appearance];
}

-(C4Label *)copyWithZone:(NSZone *)zone {
    C4Label *label = [[C4Label allocWithZone:zone] initWithText:self.text font:self.font frame:self.frame];
    label.style = self.style;
    return label;
}
@end
