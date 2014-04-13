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

#import "C4Stepper.h"

@implementation C4Stepper

+ (instancetype)stepper {
    C4Stepper *stepper = [[C4Stepper alloc] initWithFrame:CGRectZero];
    return stepper;
}

-(id)initWithFrame:(CGRect)frame {
    UIStepper* stepper = [[UIStepper alloc] initWithFrame:frame];
    stepper.maximumValue = 5;
    self = [super initWithView:stepper];
    if(self != nil) {
        _UIStepper = stepper;
        self.maximumValue = 5;
    }
    return self;
}

-(void)setCenter:(CGPoint)center {
    center.x = floorf(center.x);
    center.y = floorf(center.y)+0.5f;
    [super setCenter:center];
}

-(BOOL)isContinuous {
    return self.UIStepper.isContinuous;
}

-(void)setContinuous:(BOOL)continuous {
    self.UIStepper.continuous = continuous;
}

-(BOOL)autorepeat {
    return self.UIStepper.autorepeat;
}

-(void)setAutorepeat:(BOOL)autorepeat {
    self.UIStepper.autorepeat = autorepeat;
}

-(BOOL)wraps {
    return self.UIStepper.wraps;
}

-(void)setWraps:(BOOL)wraps {
    self.UIStepper.wraps = wraps;
}

-(CGFloat)value {
    return (CGFloat)self.UIStepper.value;
}

-(void)setValue:(CGFloat)value {
    self.UIStepper.value = (double)value;
}

-(CGFloat)maximumValue {
    return (CGFloat)self.UIStepper.maximumValue;
}

-(void)setMaximumValue:(CGFloat)maximumValue {
    self.UIStepper.maximumValue = (double)maximumValue;
}

-(CGFloat)minimumValue {
    return (CGFloat)self.UIStepper.minimumValue;
}

-(void)setMinimumValue:(CGFloat)minimumValue {
    self.UIStepper.minimumValue = (double)minimumValue;
}

-(CGFloat)stepValue {
    return (CGFloat)self.UIStepper.stepValue;
}

-(void)setStepValue:(CGFloat)stepValue {
    self.UIStepper.stepValue = (double)stepValue;
}

-(UIColor *)tintColor {
    return self.UIStepper.tintColor;
}

-(void)setTintColor:(UIColor *)tintColor {
    [self.UIStepper setTintColor:tintColor];
}

-(void)setBackgroundImage:(C4Image*)image forState:(C4ControlState)state {
    [self.UIStepper setBackgroundImage:image.UIImage forState:(UIControlState)state];
}

-(C4Image*)backgroundImageForState:(C4ControlState)state {
    return [C4Image imageWithUIImage:[self.UIStepper backgroundImageForState:(UIControlState)state]];
}

-(void)setDividerImage:(C4Image*)image forLeftSegmentState:(C4ControlState)leftState rightSegmentState:(C4ControlState)rightState {
    [self.UIStepper setDividerImage:image.UIImage forLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState];
}

-(C4Image*)dividerImageForLeftSegmentState:(C4ControlState)leftState rightSegmentState:(C4ControlState)rightState {
    return [C4Image imageWithUIImage:[self.UIStepper dividerImageForLeftSegmentState:(UIControlState)leftState rightSegmentState:(UIControlState)rightState]];
}

-(void)setIncrementImage:(C4Image *)image forState:(C4ControlState)state {
    [self.UIStepper setIncrementImage:image.UIImage forState:(UIControlState)state];
}
-(C4Image *)incrementImageForState:(C4ControlState)state {
    return [C4Image imageWithUIImage:[self.UIStepper incrementImageForState:(UIControlState)state]];
}

-(void)setDecrementImage:(C4Image *)image forState:(C4ControlState)state {
    [self.UIStepper setDecrementImage:image.UIImage forState:(UIControlState)state];
}
-(C4Image *)decrementImageForState:(C4ControlState)state {
    return [C4Image imageWithUIImage:[self.UIStepper decrementImageForState:(UIControlState)state]];
}

#pragma mark C4UIElement (target:action)
-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UIStepper addTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UIStepper removeTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

#pragma mark isEqual

-(BOOL)isEqual:(id)object {
    if([object isKindOfClass:[UIStepper class]]) return [self.UIStepper isEqual:object];
    else if([object isKindOfClass:[self class]]) return [self.UIStepper isEqual:((C4Stepper *)object).UIStepper];
    return NO;
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
