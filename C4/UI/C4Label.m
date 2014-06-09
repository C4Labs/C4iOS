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

+ (instancetype)labelWithText:(NSString *)text {
    return [[C4Label alloc] initWithText:text];
}

+ (instancetype)labelWithText:(NSString *)text font:(C4Font *)font {
    return [[C4Label alloc] initWithText:text font:font];
}

+ (instancetype)labelWithText:(NSString *)text font:(C4Font *)font frame:(CGRect)frame {
    return [[C4Label alloc] initWithText:text font:font frame:frame];
}

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    UILabel* label = [[UILabel alloc] initWithFrame:frame];
    label.backgroundColor = [UIColor clearColor];
    label.shadowColor = [UIColor clearColor];
    return [self initWithUILabel:label];
}

- (id)initWithText:(NSString *)text {
    return [self initWithText:text font:[C4Font systemFontOfSize:24.0f]];
}

- (id)initWithText:(NSString *)text font:(C4Font *)font {
    return [self initWithText:text font:font frame:CGRectZero];
}

- (id)initWithText:(NSString *)text font:(C4Font *)font frame:(CGRect)frame {
    self = [self initWithFrame:frame];
    if (self != nil) {
        self.text = text;
        self.font = font;
    }
    return self;
}

- (id)initWithUILabel:(UILabel *)label {
    return [super initWithView:label];
}


#pragma mark C4Label Methods

- (NSString *)text {
    return self.label.text;
}

- (void)setText:(NSString *)text {
    if (self.animationDuration == 0.0f) {
        self.label.text = text;
        return;
    }

    NSString *oldText = self.label.text;
    void (^animationBlock)() = ^() { self.label.text = text; };
    void (^reverseBlock)() = ^() { self.label.text = oldText; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (UIColor*)textColor {
    return self.label.textColor;
}

- (void)setTextColor:(UIColor *)textColor {
    if (self.animationDuration == 0.0f) {
        self.label.textColor = textColor;
        return;
    }

    UIColor *oldTextColor = self.label.textColor;
    void (^animationBlock)() = ^() { self.label.textColor = textColor; };
    void (^reverseBlock)() = ^() { self.label.textColor = oldTextColor; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (UIColor *)textShadowColor {
    return self.label.shadowColor;
}

- (void)setTextShadowColor:(UIColor *)shadowColor {
    if (self.animationDuration == 0.0f) {
        self.label.shadowColor = shadowColor;
        return;
    }

    UIColor *oldShadowColor = self.label.shadowColor;
    void (^animationBlock)() = ^() { self.label.shadowColor = shadowColor; };
    void (^reverseBlock)() = ^() { self.label.shadowColor = oldShadowColor; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (CGSize)textShadowOffset {
    return self.label.shadowOffset;
}

- (void)setTextShadowOffset:(CGSize)shadowOffset {
    if (self.animationDuration == 0.0f) {
        self.label.shadowOffset = shadowOffset;
        return;
    }

    CGSize oldShadowOffset = self.label.shadowOffset;
    void (^animationBlock)() = ^() { self.label.shadowOffset = shadowOffset; };
    void (^reverseBlock)() = ^() { self.label.shadowOffset = oldShadowOffset; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (C4Font *)font {
    UIFont *ui = self.label.font;
    C4Font *newFont = [C4Font fontWithName:ui.fontName size:ui.pointSize];
    return newFont;
}

- (void)setFont:(C4Font *)font {
    self.label.font = font.UIFont;
}

- (BOOL)isHighlighted {
    return self.label.isHighlighted;
}

- (void)setHighlighted:(BOOL)highlighted {
    self.label.highlighted = highlighted;
}

- (BOOL)adjustsFontSizeToFitWidth {
    return self.label.adjustsFontSizeToFitWidth;
}

- (void)setAdjustsFontSizeToFitWidth:(BOOL)adjustsFontSizeToFitWidth {
    self.label.adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth;
}

- (C4BaselineAdjustment)baselineAdjustment {
    return (C4BaselineAdjustment)self.label.baselineAdjustment;
}

- (void)setBaselineAdjustment:(C4BaselineAdjustment)baselineAdjustment {
    self.label.baselineAdjustment = (UIBaselineAdjustment)baselineAdjustment;
}

- (C4TextAlignment)textAlignment {
    return (C4TextAlignment)self.label.textAlignment;
}

- (void)setTextAlignment:(C4TextAlignment)textAlignment {
    self.label.textAlignment = (NSTextAlignment)textAlignment;
}

- (C4LineBreakMode)lineBreakMode {
    return (C4LineBreakMode)self.label.lineBreakMode;
}

- (void)setLineBreakMode:(C4LineBreakMode)lineBreakMode {
    self.label.lineBreakMode = (NSLineBreakMode)lineBreakMode;
}

- (NSUInteger)numberOfLines {
    return self.label.numberOfLines;
}

- (void)setNumberOfLines:(NSUInteger)numberOfLines {
    self.label.numberOfLines = numberOfLines;
}

- (UIColor *)highlightedTextColor {
    return self.label.highlightedTextColor;
}

- (void)setHighlightedTextColor:(UIColor *)highlightedTextColor {
    self.label.highlightedTextColor = highlightedTextColor;
}

- (UILabel*)label {
    return (UILabel*)self.view;
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
