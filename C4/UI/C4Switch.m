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

#import "C4Switch.h"

@implementation C4Switch

+ (instancetype)switch:(CGRect)frame {
    C4Switch *s = [[C4Switch alloc] initWithFrame:frame];
    return s;
}

+ (instancetype)switch {
    C4Switch *s = [[C4Switch alloc] initWithFrame:CGRectZero];
    return s;
}

-(id)initWithFrame:(CGRect)frame {
    UISwitch* sw = [[UISwitch alloc] init];
    self = [super initWithView:sw];
    if(self != nil) {
        _UISwitch = sw;
        [self setupFromDefaults];
        [self setup];
    }
    return self;
}

-(void)setCenter:(CGPoint)center {
    center.x = floorf(center.x)+0.5f;
    center.y = floorf(center.y)+0.5f;
    [super setCenter:center];
}

-(void)setupFromDefaults {
}

-(UIColor *)onTintColor {
    return _UISwitch.onTintColor;
}

-(void)setOnTintColor:(UIColor *)onTintColor {
    _UISwitch.onTintColor = onTintColor;
}

-(UIColor *)tintColor {
    return _UISwitch.tintColor;
}

-(void)setTintColor:(UIColor *)tintColor {
    _UISwitch.tintColor = tintColor;
}

-(UIColor *)thumbTintColor {
    return _UISwitch.thumbTintColor;
}

-(void)setThumbTintColor:(UIColor *)thumbTintColor {
    _UISwitch.thumbTintColor = thumbTintColor;
}

-(C4Image *)onImage {
    return [C4Image imageWithUIImage:_UISwitch.onImage];
}

-(void)setOnImage:(C4Image *)onImage {
    _UISwitch.onImage = onImage.UIImage;
}

-(C4Image *)offImage {
    return [C4Image imageWithUIImage:_UISwitch.offImage];
}

-(void)setOffImage:(C4Image *)offImage {
    _UISwitch.offImage = offImage.UIImage;
}

-(BOOL)isOn {
    return _UISwitch.isOn;
}

-(void)setOn:(BOOL)on {
    _UISwitch.on = on;
}

-(void)setOn:(BOOL)on animated:(BOOL)animated {
    [_UISwitch setOn:on animated:animated];
}

-(void)setFrame:(CGRect)frame {
    CGPoint origin = frame.origin;
    origin.x = floorf(origin.x);
    origin.y = floorf(origin.y);
    frame.origin = origin;
    [super setFrame:frame];
}

#pragma mark other C4UIElement (target:action)
-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UISwitch addTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UISwitch removeTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
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
    if([object isKindOfClass:[UISwitch class]]) return [self.UISwitch isEqual:object];
    else if([object isKindOfClass:[self class]]) return [self.UISwitch isEqual:((C4Switch *)object).UISwitch];
    return NO;
}

@end
