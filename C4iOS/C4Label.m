//
//  C4Label.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Label.h"

@interface C4Label()

-(void)_setShadowOffset:(NSValue *)shadowOffset;
-(void)_setShadowRadius:(NSNumber *)shadowRadius;
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity;
-(void)_setShadowColor:(UIColor *)shadowColor;
-(void)_setShadowPath:(id)shadowPath;
-(void)_setBackgroundFilters:(NSArray *)backgroundFilters;
-(void)_setCompositingFilter:(id)compositingFilter;

-(void)sizeToFit;

#pragma mark C4Label Methods
-(void)_setBackgroundColor:(UIColor *)backgroundColor;
-(void)_setText:(NSString *)text;
-(void)_setTextShadowColor:(UIColor *)shadowColor;
-(void)_setTextShadowOffset:(NSValue *)shadowOffset;
-(void)_setEnabled:(NSValue *)enabled;
-(void)_setFont:(C4Font *)font;
-(void)_setTextColor:(UIColor *)textColor;
-(void)_setAdjustsFontSizeToFitWidth:(NSValue *)adjustsFontSizeToFitWidth;
-(void)_setBaselineAdjustment:(NSValue *)baselineAdjustment;
-(void)_setTextAlignment:(NSValue *)textAlignment;
-(void)_setLineBreakMode:(NSValue *)lineBreakMode;
-(void)_setMinimumFontSize:(NSValue *)minimumFontSize;
-(void)_setNumberOfLines:(NSValue *)numberOfLines;
-(void)_setHighlightedTextColor:(UIColor *)highlightedTextColor;
-(void)_sizeToFit;
@end

@implementation C4Label
@synthesize animationDuration = _animationDuration;
@synthesize animationDelay = _animationDelay;
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
@synthesize backingLayer;

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
        self.animationDelay = 0.0f;
        self.animationDuration = 0.0f;
        [self setup];
        [self addSubview:_label];
    }
    return self;
}

-(void)sizeToFit {
    if(self.animationDelay == 0) [self _sizeToFit];
    [self performSelector:@selector(_sizeToFit) withObject:nil afterDelay:self.animationDelay];
}

-(void)_sizeToFit {
    [self.label sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.label.frame.size.width, self.label.frame.size.height);
    [self setNeedsDisplay];
}

#pragma mark C4Label Methods
-(void)setBackgroundColor:(UIColor *)backgroundColor {
    if(self.animationDelay == 0) _label.backgroundColor = backgroundColor;
    [self performSelector:@selector(_setBackgroundColor:) withObject:backgroundColor afterDelay:self.animationDelay];
}
-(void)_setBackgroundColor:(UIColor *)backgroundColor {
    _label.backgroundColor = backgroundColor;
}

-(UIColor *)backroundColor {
    return _label.backgroundColor;
}

-(void)setText:(NSString *)text {
    if(self.animationDelay == 0) self.label.text = text;
    else [self performSelector:@selector(_setText:) withObject:text afterDelay:self.animationDelay];
}
-(void)_setText:(NSString *)text {
    self.label.text = text;
}

-(NSString *)text {
    return self.label.text;
}

-(void)setTextShadowColor:(UIColor *)shadowColor {
    if(self.animationDelay == 0) {
        _shadowColor = shadowColor;
        self.label.shadowColor = shadowColor;
    }
    [self performSelector:@selector(_setTextShadowColor:) withObject:shadowColor afterDelay:self.animationDelay];
}
-(void)_setTextShadowColor:(UIColor *)shadowColor {
    _shadowColor = shadowColor;
    self.label.shadowColor = shadowColor;
}

-(void)setTextShadowOffset:(CGSize)shadowOffset {
    if(self.animationDelay == 0.0f) {
        _shadowOffset = shadowOffset;
        self.label.shadowOffset = shadowOffset;
    }
    [self performSelector:@selector(_setTextShadowOffset:) withObject:[NSValue valueWithCGSize:shadowOffset] afterDelay:self.animationDelay];
}
-(void)_setTextShadowOffset:(NSValue *)shadowOffset {
    _shadowOffset = [shadowOffset CGSizeValue];
    self.label.shadowOffset = [shadowOffset CGSizeValue];
}

-(void)touchesBegan {
}

-(void)setEnabled:(BOOL)enabled {
    if(self.animationDelay == 0.0f) {
        [super setEnabled:enabled];//weeeeeeird bug if this isn't included
        self.label.enabled = enabled;
    }
    [self performSelector:@selector(_setEnabled:) withObject:[NSNumber numberWithBool:enabled] afterDelay:self.animationDelay];
}
-(void)_setEnabled:(NSNumber *)enabled {
    [super setEnabled:[enabled boolValue]];//weeeeeeird bug if this isn't included
    self.label.enabled = [enabled boolValue];
}

-(void)setFont:(C4Font *)font {
    if(self.animationDelay == 0) self.label.font = font.UIFont;
    [self performSelector:@selector(_setFont:) withObject:font afterDelay:self.animationDelay];
}
-(void)_setFont:(C4Font *)font {
    self.label.font = font.UIFont;
}

-(void)setTextColor:(UIColor *)textColor {
    if(self.animationDelay == 0.0f) self.label.textColor = textColor;
    [self performSelector:@selector(_setTextColor:) withObject:textColor afterDelay:self.animationDelay];

}
-(void)_setTextColor:(UIColor *)textColor {
    self.label.textColor = textColor;
}

-(UIColor *)textColor {
    return self.label.textColor;
}

-(BOOL)isHighlighted {
    return self.label.isHighlighted;
}

-(void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    if(self.animationDelay == 0.0f) self.label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
    [self performSelector:@selector(_setAdjustsFontSizeToFitWidth:) withObject:[NSNumber numberWithBool:adjustsFontSizeToFitWidth] afterDelay:self.animationDelay];
}
-(void)_setAdjustsFontSizeToFitWidth:(NSNumber *)adjustsFontSizeToFitWidth {
    self.label.adjustsFontSizeToFitWidth = [adjustsFontSizeToFitWidth boolValue];
}

-(BOOL)adjustsFontSizeToFitWidth {
    return self.label.adjustsFontSizeToFitWidth;
}

-(void)setBaselineAdjustment:(C4BaselineAdjustment)baselineAdjustment {
    if(self.animationDelay == 0.0f) self.label.baselineAdjustment = baselineAdjustment;
    [self performSelector:@selector(_setBaselineAdjustment:) withObject:[NSNumber numberWithInt:baselineAdjustment] afterDelay:self.animationDelay];
}
-(void)_setBaselineAdjustment:(NSNumber *)baselineAdjustment {
    self.label.baselineAdjustment = (UIBaselineAdjustment)[baselineAdjustment intValue];
}

-(C4BaselineAdjustment)baselineAdjustment {
    return (C4BaselineAdjustment)self.label.baselineAdjustment;
}

-(void)setTextAlignment:(C4TextAlignment)textAlignment {
    if(self.animationDelay == 0.0f) self.label.textAlignment = textAlignment;
    [self performSelector:@selector(_setTextAlignment:) withObject:[NSNumber numberWithInt:textAlignment] afterDelay:self.animationDelay];
}
-(void)_setTextAlignment:(NSNumber *)textAlignment {
    self.label.textAlignment = (UITextAlignment)[textAlignment intValue];
}

-(C4TextAlignment)textAlignment {
    return (C4TextAlignment)self.label.textAlignment;
}

-(void)setLineBreakMode:(C4LineBreakMode)lineBreakMode {
    [self performSelector:@selector(_setLineBreakMode:) withObject:[NSNumber numberWithInt:lineBreakMode] afterDelay:self.animationDelay];
}
-(void)_setLineBreakMode:(NSNumber *)lineBreakMode {
    if(self.animationDelay == 0.0f) self.label.lineBreakMode = (UILineBreakMode)lineBreakMode;
    self.label.lineBreakMode = (UILineBreakMode)[lineBreakMode intValue];
}

-(C4LineBreakMode)lineBreakMode {
    return (C4LineBreakMode)self.label.lineBreakMode;
}

-(void)setMinimumFontSize:(CGFloat)minimumFontSize {
    if(self.animationDelay == 0.0f) self.label.minimumFontSize = minimumFontSize;
    [self performSelector:@selector(_setMinimum:) withObject:[NSNumber numberWithFloat:minimumFontSize] afterDelay:self.animationDelay];
}
-(void)_setMinimumFontSize:(NSNumber *)minimumFontSize {
    self.label.minimumFontSize = [minimumFontSize floatValue];
}

-(CGFloat)minimumFontSize {
    return self.label.minimumFontSize;
}

-(void)setNumberOfLines:(NSUInteger)numberOfLines {
    if(self.animationDelay == 0.0f) self.label.numberOfLines = numberOfLines;
    [self performSelector:@selector(_setNumberOfItems:) withObject:[NSNumber numberWithInt:numberOfLines] afterDelay:self.animationDelay];
}
-(void)_setNumberOfLines:(NSNumber *)numberOfLines {
    self.label.numberOfLines = [numberOfLines intValue];
}

-(NSUInteger)numberOfLines {
    return self.label.numberOfLines;
}

-(void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    if(self.animationDelay == 0.0f) self.label.highlightedTextColor = highlightedTextColor;
    [self performSelector:@selector(_setHighlightedTextColor:) withObject:highlightedTextColor afterDelay:self.animationDelay];
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
-(void)setAnimationDuration:(CGFloat)animationDuration {
    _animationDuration = animationDuration;
    self.backingLayer.animationDuration = animationDuration;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    [super setAnimationOptions:animationOptions];
    self.backingLayer.animationOptions = animationOptions;
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    [self performSelector:@selector(_setShadowOffset:) withObject:[NSValue valueWithCGSize:shadowOffset] afterDelay:self.animationDelay];
}
-(void)_setShadowOffset:(NSValue *)shadowOffset {
    [self.backingLayer animateShadowOffset:[shadowOffset CGSizeValue]];
}

-(void)setShadowRadius:(CGFloat)shadowRadius {
    [self performSelector:@selector(_setShadowRadius:) withObject:[NSNumber numberWithFloat:shadowRadius] afterDelay:self.animationDelay];
}
-(void)_setShadowRadius:(NSNumber *)shadowRadius {
    [self.backingLayer animateShadowRadius:[shadowRadius floatValue]];
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self performSelector:@selector(_setShadowOpacity:) withObject:[NSNumber numberWithFloat:shadowOpacity] afterDelay:self.animationDelay];
}
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity {
    [self.backingLayer animateShadowOpacity:[shadowOpacity floatValue]];
}

-(void)setShadowColor:(UIColor *)shadowColor {
    [self performSelector:@selector(_setShadowColor:) withObject:shadowColor afterDelay:self.animationDelay];
}
-(void)_setShadowColor:(UIColor *)shadowColor {
    [self.backingLayer animateShadowColor:shadowColor.CGColor];
}

-(void)setShadowPath:(CGPathRef)shadowPath {
    [self performSelector:@selector(_setShadowPath:) withObject:(__bridge id)shadowPath afterDelay:self.animationDelay];
}
-(void)_setShadowPath:(id)shadowPath {
    [self.backingLayer animateShadowPath:(__bridge CGPathRef)shadowPath];
}

-(void)setBackgroundFilters:(NSArray *)backgroundFilters {
    [self performSelector:@selector(_setBackgroundFilters:) withObject:backgroundFilters afterDelay:self.animationDelay];
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

@end
