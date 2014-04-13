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

#import "C4Defines.h"
#import "C4Slider.h"

@implementation C4Slider

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame defaults:YES];
}

-(id)initWithFrame:(CGRect)frame defaults:(BOOL)useDefaults {
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    self = [super initWithView:slider];
    if (self != nil) {
        _UISlider = slider;
        
        if (useDefaults)
            [self setupFromDefaults];
        [self setup];
    }
    return self;
}

-(void)touchEvent:(id)sender {
    sender = sender;
}

-(void)setupFromDefaults {
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    self.UISlider.frame = frame;
}

-(UIColor *)thumbTintColor {
    return self.UISlider.thumbTintColor;
}

-(void)setThumbTintColor:(UIColor *)color {
    self.UISlider.thumbTintColor = nilForNullObject(color);
}

-(UIColor *)maximumTrackTintColor {
    return self.UISlider.maximumTrackTintColor;
}

-(void)setMaximumTrackTintColor:(UIColor *)color {
    self.UISlider.maximumTrackTintColor = nilForNullObject(color);
}

-(UIColor *)minimumTrackTintColor {
    return self.UISlider.minimumTrackTintColor;
}

-(void)setMinimumTrackTintColor:(UIColor *)color {
    self.UISlider.minimumTrackTintColor = nilForNullObject(color);
}

-(C4Image *)maximumValueImage {
    return [C4Image imageWithUIImage:self.UISlider.minimumValueImage];
}

-(C4Image *)minimumValueImage {
    return [C4Image imageWithUIImage:self.UISlider.minimumValueImage];
}

-(BOOL)isContinuous {
    return self.UISlider.continuous;
}

-(void)setContinuous:(BOOL)continuous {
    self.UISlider.continuous = continuous;
}

-(C4Image *)currentThumbImage {
    return [C4Image imageWithUIImage:self.UISlider.currentThumbImage];
}

-(C4Image *)currentMinimumTrackImage {
    return [C4Image imageWithUIImage:self.UISlider.currentMinimumTrackImage];
}

-(C4Image *)currentMaximumTrackImage {
    return [C4Image imageWithUIImage:self.UISlider.currentMaximumTrackImage];
}

#pragma mark Getter Setter methods for various states
-(C4Image *)maximumTrackImageForState:(C4ControlState)state {
    return [C4Image imageWithUIImage:[self.UISlider maximumTrackImageForState:(UIControlState)state]];
}

-(void)setMaximumTrackImage:(C4Image *)image forState:(C4ControlState)state {
    [self.UISlider setMaximumTrackImage:image.UIImage forState:(UIControlState)state];
}

-(C4Image *)minimumTrackImageForState:(C4ControlState)state {
    return [C4Image imageWithUIImage:[self.UISlider minimumTrackImageForState:(UIControlState)state]];
}

-(void)setMinimumTrackImage:(C4Image *)image forState:(C4ControlState)state {
    [self.UISlider setMinimumTrackImage:image.UIImage forState:(UIControlState)state];
}

-(C4Image *)thumbImageForState:(C4ControlState)state {
    return [C4Image imageWithUIImage:[self.UISlider thumbImageForState:(UIControlState)state]];
}

-(void)setThumbImage:(C4Image *)image forState:(C4ControlState)state {
    [self.UISlider setThumbImage:image.UIImage forState:(UIControlState)state];
}

#pragma mark C4UIElement (target:action)
-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UISlider addTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UISlider removeTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

#pragma mark Tracking

//-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    [self postNotification:@"trackingBegan"];
//    [self beginTracking];
//    return [self.UISlider beginTrackingWithTouch:touch withEvent:event];
//}
//
//-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    [self postNotification:@"trackingContinued"];
//    [self continueTracking];
//    return [self.UISlider continueTrackingWithTouch:touch withEvent:event];
//}
//
//-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
//    [self postNotification:@"trackingEnded"];
//    [self endTracking];
//    return [self.UISlider endTrackingWithTouch:touch withEvent:event];
//}
//
//-(void)cancelTrackingWithEvent:(UIEvent *)event {
//    [self postNotification:@"trackingCancelled"];
//    [self cancelTracking];
//    [self.UISlider cancelTrackingWithEvent:event];
//}
//
//-(void)beginTracking {
//}
//
//-(void)continueTracking {
//}
//
//-(void)endTracking {
//}
//
//-(void)cancelTracking {
//}

+ (instancetype)slider:(CGRect)rect {
    return [[C4Slider alloc] initWithFrame:rect];
}

#pragma mark Slider
-(CGFloat)value {
    return self.UISlider.value;
}

-(void)setValue:(CGFloat)value {
    [self setValue:value animated:NO];
}

-(void)setValue:(CGFloat)value animated:(BOOL)animated {
    [self.UISlider setValue:value animated:animated];
}

-(CGFloat)maximumValue {
    return self.UISlider.maximumValue;
}

-(void)setMaximumValue:(CGFloat)maximumValue {
    self.UISlider.maximumValue = maximumValue;
}

-(CGFloat)minimumValue {
    return self.UISlider.minimumValue;
}

-(void)setMinimumValue:(CGFloat)minimumValue {
    self.UISlider.minimumValue = minimumValue;
}

#pragma mark ControlState

-(UIControlState)state {
    return self.UISlider.state;
}

-(void)setEnabled:(BOOL)enabled {
    self.UISlider.enabled = enabled;
}

-(BOOL)enabled {
    return self.UISlider.enabled;
}

-(void)setHighlighted:(BOOL)highlighted {
    self.UISlider.highlighted = highlighted;
}

-(BOOL)highlighted {
    return self.UISlider.highlighted;
}

-(void)setSelected:(BOOL)selected {
    self.UISlider.selected = selected;
}

-(BOOL)selected {
    return self.UISlider.selected;
}

-(void)setContentVerticalAlignment:(UIControlContentVerticalAlignment)contentVerticalAlignment {
    self.UISlider.contentVerticalAlignment = contentVerticalAlignment;
}

-(void)setContentHorizontalAlignment:(UIControlContentHorizontalAlignment)contentHorizontalAlignment {
    self.UISlider.contentHorizontalAlignment = contentHorizontalAlignment;
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
    if([object isKindOfClass:[UISlider class]]) return [self.UISlider isEqual:object];
    else if([object isKindOfClass:[self class]]) return [self.UISlider isEqual:((C4Slider *)object).UISlider];
    return NO;
}

@end
