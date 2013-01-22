//
//  C4Label.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Label.h"

@interface C4Label()
-(void)_setBackgroundFilters:(NSArray *)backgroundFilters;
-(void)_setCompositingFilter:(id)compositingFilter;
-(void)sizeToFit;

#pragma mark C4Label Methods
//-(void)_setBackgroundColor:(UIColor *)backgroundColor;
-(void)_setText:(NSString *)text;
-(void)_setTextShadowColor:(UIColor *)shadowColor;
-(void)_setTextShadowOffset:(NSValue *)shadowOffset;
-(void)_setEnabled:(NSNumber *)enabled;
-(void)_setFont:(C4Font *)font;
-(void)_setTextColor:(UIColor *)textColor;
-(void)_setAdjustsFontSizeToFitWidth:(NSNumber *)adjustsFontSizeToFitWidth;
-(void)_setBaselineAdjustment:(NSNumber *)baselineAdjustment;
-(void)_setTextAlignment:(NSNumber *)textAlignment;
-(void)_setLineBreakMode:(NSNumber *)lineBreakMode;
-(void)_setNumberOfLines:(NSNumber *)numberOfLines;
-(void)_setHighlightedTextColor:(UIColor *)highlightedTextColor;
-(void)_sizeToFit;
@property (readwrite, atomic) BOOL shouldAutoreverse;
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
@synthesize textAlignment = _textAlignment;
@synthesize textColor = _textColor;
@synthesize textShadowColor = _textShadowColor;
@synthesize textShadowOffset = _textShadowOffset;
@synthesize text = _text;
@synthesize label = _label;
@synthesize backingLayer;
@synthesize width = _width, height = _height;
@synthesize animationOptions = _animationOptions;
@synthesize shouldAutoreverse = _shouldAutoreverse;
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
    return [self initWithText:text font:[C4Font systemFontOfSize:12.0f]];
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

-(id)initWithFrame:(CGRect)frame {
    if(CGRectEqualToRect(frame, CGRectZero)) frame = CGRectMake(0, 0, 1, 1);
    self = [super initWithFrame:frame];
    if(self != nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _label.textColor = C4GREY;
        _label.highlightedTextColor = C4RED;
        _label.backgroundColor = [UIColor clearColor];
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
    if(self.animationDelay == 0.0) [self _sizeToFit];
    else [self performSelector:@selector(_sizeToFit) withObject:nil afterDelay:self.animationDelay];
}

-(void)_sizeToFit {
    [self.label sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.label.frame.size.width, self.label.frame.size.height);
}

#pragma mark C4Label Methods
//-(void)setBackgroundColor:(UIColor *)backgroundColor {
//    if(self.animationDelay == 0.0f) _label.backgroundColor = backgroundColor;
//    [self performSelector:@selector(_setBackgroundColor:) withObject:backgroundColor afterDelay:self.animationDelay];
//}
//-(void)_setBackgroundColor:(UIColor *)backgroundColor {
//    _label.backgroundColor = backgroundColor;
//}

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
    self.label.textAlignment = (UITextAlignment)[textAlignment intValue];
}

-(C4TextAlignment)textAlignment {
    return (C4TextAlignment)self.label.textAlignment;
}

-(void)setLineBreakMode:(C4LineBreakMode)lineBreakMode {
    if(self.animationDelay == 0.0f) [self _setLineBreakMode:@(lineBreakMode)];
    else [self performSelector:@selector(_setLineBreakMode:) withObject:@(lineBreakMode) afterDelay:self.animationDelay];
}
-(void)_setLineBreakMode:(NSNumber *)lineBreakMode {
    self.label.lineBreakMode = (UILineBreakMode)[lineBreakMode integerValue];
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


/*
-(void)setWidth:(CGFloat)width {
    _width = width;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height);
}

-(void)setHeight:(CGFloat)height {
    _height = height;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height);
}

-(CGFloat)width {
    return self.frame.size.width;
}

-(CGFloat)height {
    return self.frame.size.height;
}
*/

-(CGFloat)width {
    return self.frame.size.width;
}

-(void)setWidth:(CGFloat)width {
    _width = width;
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

-(CGFloat)height {
    return self.frame.size.height;
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

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    /*
     This method needs to be in all C4Control subclasses, not sure why it doesn't inherit properly
     
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    ((id <C4LayerAnimation>)self.layer).animationOptions = _animationOptions;
    
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    
    _animationOptions = animationOptions | BEGINCURRENT;
}


@end
