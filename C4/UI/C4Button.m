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

#import "C4Button.h"

@implementation C4Button

+ (instancetype)buttonWithType:(C4ButtonType)type {
    C4Button *button = [[C4Button alloc] initWithType:type];
    return button;
}

-(id)initWithType:(C4ButtonType)type {
    UIButton *button = [UIButton buttonWithType:(UIButtonType)type];
    self = [super initWithView:button];
    if(self != nil) {
        _UIButton = button;
        _UIButton.layer.masksToBounds = YES;
        [self setupFromDefaults];
        [self setup];
    }
    return self;
}

-(void)setupFromDefaults {
    self.UIButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Medium" size:15.0f];
    
    if(self.buttonType == ROUNDEDRECT) {
        self.frame = CGRectMake(0,0,96,27);
        [self setTitle:@"BUTTON" forState:NORMAL];
        [self setTitleColor:C4GREY forState:NORMAL];
        [self setTitleColor:C4GREY forState:HIGHLIGHTED];
        [self setTitleColor:C4RED forState:DISABLED];
        [self setTitleShadowColor:[UIColor whiteColor] forState:NORMAL];
        self.reversesTitleShadowWhenHighlighted = YES;
        self.UIButton.titleLabel.shadowOffset = CGSizeMake(1,1);
        
        [self setBackgroundImage:[C4Image imageNamed:@"buttonDisabled"] forState:DISABLED];
        [self setBackgroundImage:[C4Image imageNamed:@"buttonHighlighted"] forState:HIGHLIGHTED];
        [self setBackgroundImage:[C4Image imageNamed:@"buttonNormal"] forState:NORMAL];
        [self setBackgroundImage:[C4Image imageNamed:@"buttonSelected"] forState:SELECTED];
    }
    //NOTE: UIButton only recognizes tintColor for its appearance (check UIButton.h)
}

-(void)setFrame:(CGRect)frame {
    CGPoint origin = frame.origin;
    origin.x = floorf(origin.x);
    origin.y = floorf(origin.y) + 0.5f;
    frame.origin = origin;
    [super setFrame:frame];
    self.UIButton.frame = self.bounds;
}

-(void)setCenter:(CGPoint)center {
    center.x = floorf(center.x);
    center.y = floorf(center.y) + 0.5f;
    [super setCenter:center];
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    [super setCornerRadius:cornerRadius];
    [self.UIButton.layer setCornerRadius:cornerRadius];
}

-(C4Font *)font {
    return [C4Font fontWithName:self.UIButton.titleLabel.font.fontName size:self.UIButton.titleLabel.font.pointSize];
}

-(void)setFont:(C4Font *)font {
    self.UIButton.titleLabel.font = font.UIFont;
}

-(NSString *)titleForState:(C4ControlState)state {
    return [self.UIButton titleForState:(UIControlState)state];
}

-(void)setTitle:(NSString *)title forState:(C4ControlState)state {
    [self.UIButton setTitle:title forState:(UIControlState)state];
    [self.UIButton setAttributedTitle:nil forState:(UIControlState)state];
}

-(UIColor *)titleColorForState:(C4ControlState)state {
    return [self.UIButton titleColorForState:(UIControlState)state];
}

-(void)setTitleColor:(UIColor *)color forState:(C4ControlState)state {
    [self.UIButton setTitleColor:color forState:(UIControlState)state];
}

-(UIColor *)titleShadowColorForState:(C4ControlState)state {
    return [self.UIButton titleShadowColorForState:(UIControlState)state];
}

-(void)setTitleShadowColor:(UIColor *)color forState:(C4ControlState)state {
    [self.UIButton setTitleShadowColor:color forState:(UIControlState)state];
}

-(C4Image *)imageForState:(C4ControlState)state {
    return [C4Image imageWithUIImage:[self.UIButton imageForState:(UIControlState)state]];
}

-(void)setImage:(C4Image *)image forState:(C4ControlState)state {
    [self.UIButton setImage:image.UIImage forState:(UIControlState)state];
}

-(C4Image *)backgroundImageForState:(C4ControlState)state {
    return [C4Image imageWithUIImage:[self.UIButton backgroundImageForState:(UIControlState)state]];
}

-(void)setBackgroundImage:(C4Image *)image forState:(C4ControlState)state {
    [self.UIButton setBackgroundImage:image.UIImage forState:(UIControlState)state];
}

-(NSAttributedString *)attributedTitleForState:(C4ControlState)state {
    return [self.UIButton attributedTitleForState:(UIControlState)state];
}

-(void)setAttributedTitle:(NSAttributedString *)title forState:(C4ControlState)state {
    [self.UIButton setAttributedTitle:title forState:(UIControlState)state];
}

-(UIEdgeInsets)contentEdgeInsets {
    return self.UIButton.contentEdgeInsets;
}

-(void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets {
    self.UIButton.contentEdgeInsets = contentEdgeInsets;
}

-(UIEdgeInsets)titleEdgeInsets {
    return self.UIButton.titleEdgeInsets;
}

-(void)setTitleEdgeInsets:(UIEdgeInsets)titleEdgeInsets {
    self.UIButton.titleEdgeInsets = titleEdgeInsets;
}

-(UIEdgeInsets)imageEdgeInsets {
    return self.UIButton.imageEdgeInsets;
}

-(void)setImageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    self.UIButton.imageEdgeInsets = imageEdgeInsets;
}

-(BOOL)reversesTitleShadowWhenHighlighted {
    return self.UIButton.reversesTitleShadowWhenHighlighted;
}

-(void)setReversesTitleShadowWhenHighlighted:(BOOL)reversesTitleShadowWhenHighlighted {
    self.UIButton.reversesTitleShadowWhenHighlighted = reversesTitleShadowWhenHighlighted;
}

-(BOOL)adjustsImageWhenDisabled {
    return self.UIButton.adjustsImageWhenDisabled;
}

-(void)setAdjustsImageWhenDisabled:(BOOL)adjustsImageWhenDisabled {
    self.UIButton.adjustsImageWhenDisabled = adjustsImageWhenDisabled;
}

-(BOOL)adjustsImageWhenHighlighted {
    return self.UIButton.adjustsImageWhenHighlighted;
}

-(void)setAdjustsImageWhenHighlighted:(BOOL)adjustsImageWhenHighlighted {
    self.UIButton.adjustsImageWhenHighlighted = adjustsImageWhenHighlighted;
}

-(BOOL)showsTouchWhenHighlighted {
    return self.UIButton.showsTouchWhenHighlighted;
}

-(void)setShowsTouchWhenHighlighted:(BOOL)showsTouchWhenHighlighted {
    self.UIButton.showsTouchWhenHighlighted = showsTouchWhenHighlighted;
}

-(UIColor *)tintColor {
    return self.UIButton.tintColor;
}

-(void)setTintColor:(UIColor *)tintColor {
    self.UIButton.tintColor = tintColor;
}

-(C4ButtonType)buttonType {
    return (C4ButtonType)self.UIButton.buttonType;
}

-(NSString *)currentTitle {
    return self.UIButton.currentTitle;
}

-(NSAttributedString *)currentAttributedTitle {
    return self.UIButton.currentAttributedTitle;
}

-(UIColor *)currentTitleColor {
    return self.UIButton.currentTitleColor;
}

-(UIColor *)currentTitleShadowColor {
    return self.UIButton.currentTitleShadowColor;
}

-(C4Image *)currentImage {
    return [C4Image imageWithUIImage:self.UIButton.currentImage];
}

-(C4Image *)currentBackgroundImage {
    return [C4Image imageWithUIImage:self.UIButton.currentBackgroundImage];
}

#pragma mark C4UIElement
-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UIButton addTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UIButton removeTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

#pragma mark Tracking
-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self postNotification:@"trackingBegan"];
    [self beginTracking];
    return [self.UIButton beginTrackingWithTouch:touch withEvent:event];
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self postNotification:@"trackingContinued"];
    [self continueTracking];
    return [self.UIButton continueTrackingWithTouch:touch withEvent:event];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self postNotification:@"trackingEnded"];
    [self endTracking];
    return [self.UIButton endTrackingWithTouch:touch withEvent:event];
}

-(void)cancelTrackingWithEvent:(UIEvent *)event {
    [self postNotification:@"trackingCancelled"];
    [self cancelTracking];
    [self.UIButton cancelTrackingWithEvent:event];
}

-(void)beginTracking {
}

-(void)continueTracking {
}

-(void)endTracking {
}

-(void)cancelTracking {
}

#pragma mark Control State

-(UIControlState)state {
    return self.UIButton.state;
}

-(void)setEnabled:(BOOL)enabled {
    self.UIButton.enabled = enabled;
}

-(BOOL)enabled {
    return self.UIButton.enabled;
}

-(void)setHighlighted:(BOOL)highlighted {
    self.UIButton.highlighted = highlighted;
}

-(BOOL)highlighted {
    return self.UIButton.highlighted;
}

-(void)setSelected:(BOOL)selected {
    self.UIButton.selected = selected;
}

-(BOOL)selected {
    return self.UIButton.selected;
}

-(void)setContentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment {
    self.UIButton.contentVerticalAlignment = contentVerticalAlignment;
}

-(void)setContentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment {
    self.UIButton.contentHorizontalAlignment = contentHorizontalAlignment;
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
    if([object isKindOfClass:[UIButton class]]) return [self.UIButton isEqual:object];
    else if([object isKindOfClass:[self class]]) return [self.UIButton isEqual:((C4Button *)object).UIButton];
    return NO;
}

@end
