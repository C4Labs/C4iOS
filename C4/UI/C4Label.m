// Copyright © 2012 Travis Kirton
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#import "C4AnimationHelper.h"
#import "C4Label.h"

@interface C4Label()
@property(nonatomic, readonly) NSArray *localStylePropertyNames;
@end

@implementation C4Label

-(id)init {
    return [self initWithFrame:CGRectZero];
}

+ (instancetype)labelWithText:(NSString *)text {
    return [[C4Label alloc] initWithText:text];
}

+ (instancetype)labelWithText:(NSString *)text font:(C4Font *)font {
    return [[C4Label alloc] initWithText:text font:font];
}

+ (instancetype)labelWithText:(NSString *)text font:(C4Font *)font frame:(CGRect)frame {
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

-(id)initWithUILabel:(UILabel *)label {
    self = [super initWithView:label];
    if(self != nil) {
        _label = label;
        [self setup];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame {
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.textColor = self.textColor;
    label.highlightedTextColor = self.highlightedTextColor;
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor clearColor];
    return [self initWithUILabel:label];
}

-(void)dealloc {
    self.text = nil;
    [_label removeFromSuperview];
    _label = nil;
}

-(void)sizeToFit {
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
    self.label.shadowColor = shadowColor;
}

-(void)setTextShadowOffset:(CGSize)shadowOffset {
    self.label.shadowOffset = shadowOffset;
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
    self.label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    super.frame = frame;
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
    [self.animationHelper animateKeyPath:@"backgroundFilters" toValue:backgroundFilters];
}

-(void)setCompositingFilter:(id)compositingFilter {
    [self.animationHelper animateKeyPath:@"compositingFilter" toValue:compositingFilter];
}


#pragma mark C4Layer-backed object methods

-(CGFloat)width {
    return self.bounds.size.width;
}

-(void)setWidth:(CGFloat)width {
    CGRect newFrame = self.frame;
    newFrame.size.width = width;
    self.frame = newFrame;
}

-(CGFloat)height {
    return self.bounds.size.height;
}

-(void)setHeight:(CGFloat)height {
    CGRect newFrame = self.frame;
    newFrame.size.height = height;
    self.frame = newFrame;
}

-(CGSize)size {
    return self.frame.size;
}

-(void)setSize:(CGSize)size {
    CGRect newFrame = CGRectZero;
    newFrame.origin = self.origin;
    newFrame.size = size;
    self.frame = newFrame;
}


#pragma mark Templates

+ (C4Template *)defaultTemplate {
    static C4Template* template;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        template = [C4Template templateFromBaseTemplate:[super defaultTemplate] forClass:self];
    });
    return template;
}

@end
