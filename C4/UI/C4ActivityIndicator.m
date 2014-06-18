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

#import "C4ActivityIndicator.h"

@implementation C4ActivityIndicator

+ (instancetype)indicatorWithStyle:(C4ActivityIndicatorStyle)style {
    C4ActivityIndicator *indicator = [[C4ActivityIndicator alloc] initWithActivityIndicatorStyle:style];
    return indicator;
}

-(id)initWithActivityIndicatorStyle:(C4ActivityIndicatorStyle)style {
    UIActivityIndicatorView* aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyle)style];
    self = [super initWithView:aiv];
    if (self != nil) {
        _UIActivityIndicatorView = aiv;
        [self setupFromDefaults];
    }
    return self;
}

-(void)setupFromDefaults {
    _UIActivityIndicatorView.hidesWhenStopped = YES;
}

-(void)startAnimating {
    [self.UIActivityIndicatorView startAnimating];
}

-(void)stopAnimating {
    [self.UIActivityIndicatorView stopAnimating];
}

-(BOOL)isAnimating {
    return self.UIActivityIndicatorView.isAnimating;
}

-(void)setActivityIndicatorStyle:(C4ActivityIndicatorStyle)style {
    self.activityIndicatorStyle = style;
}

-(C4ActivityIndicatorStyle)activityIndicatorStyle {
    return (C4ActivityIndicatorStyle)_UIActivityIndicatorView.activityIndicatorViewStyle;
}

-(void)setHidesWhenStopped:(BOOL)hidesWhenStopped {
    _UIActivityIndicatorView.hidesWhenStopped = hidesWhenStopped;
}

-(BOOL)hidesWhenStopped {
    return _UIActivityIndicatorView.hidesWhenStopped;
}

-(UIColor *)color {
    return _UIActivityIndicatorView.color;
}

-(void)setColor:(UIColor *)color {
    self.UIActivityIndicatorView.color = color;
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


#pragma mark isEqual

-(BOOL)isEqual:(id)object {
    if([object isKindOfClass:[UIActivityIndicatorView class]]) return [self.UIActivityIndicatorView isEqual:object];
    else if([object isKindOfClass:[self class]]) return [self.UIActivityIndicatorView isEqual:((C4ActivityIndicator *)object).UIActivityIndicatorView];
    return NO;
}

@end
