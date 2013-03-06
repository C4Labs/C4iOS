//
//  C4Stepper.m
//  C4iOS
//
//  Created by moi on 13-03-05.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Stepper.h"

@implementation C4Stepper
@synthesize tintColor = _tintColor;

+(C4Stepper *)stepper {
    C4Stepper *stepper = [[C4Stepper alloc] initWithFrame:CGRectZero];
    return stepper;
}

-(id)initWithFrame:(CGRect)frame {
    CGPoint origin = frame.origin;
    origin.x = floorf(origin.x);
    origin.y = floorf(origin.y);
    frame.origin = origin;
    self = [super initWithFrame:frame];
    if(self != nil) {
        _UIStepper.layer.masksToBounds = YES;
        _UIStepper = [[UIStepper alloc] init];
        self.frame = (CGRect){self.origin,_UIStepper.frame.size};
        [self addSubview:_UIStepper];
    }
    return self;
}

-(void)setCenter:(CGPoint)center {
    center.x = floorf(center.x);
    center.y = floorf(center.y)+0.5f;
    [super setCenter:center];
}

-(BOOL)continuous {
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
    _tintColor = tintColor;
    self.UIStepper.tintColor = tintColor;
}

//FIXME: these UI_APPEARANCE_SELECTORS might be confusing because they refer to an object, but I don't want to have objects for all of them...
-(void)setBackgroundImage:(C4Image*)image forState:(C4ControlState)state {
    UIImage *resizableImage = [image.UIImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.UIStepper setBackgroundImage:resizableImage forState:(UIControlState)state];
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

#pragma mark Style
+(C4Stepper *)defaultStyle {
    return (C4Stepper *)[C4Stepper appearance];
}

-(C4Stepper *)copyWithZone:(NSZone *)zone {
    C4Stepper *s = [[C4Stepper allocWithZone:zone] initWithFrame:self.frame];
    s.style = self.style;
    return s;
}

-(NSDictionary *)style {
    //mutable local styles
    NSMutableDictionary *localStyle = [[NSMutableDictionary alloc] initWithCapacity:0];
    [localStyle addEntriesFromDictionary:@{@"stepper":self.UIStepper}];
    
    NSDictionary *controlStyle = [super style];
    
    NSMutableDictionary *localAndControlStyle = [NSMutableDictionary dictionaryWithDictionary:localStyle];
    [localAndControlStyle addEntriesFromDictionary:controlStyle];
    
    localStyle = nil;
    controlStyle = nil;
    
    return (NSDictionary *)localAndControlStyle;
}

-(void)setStyle:(NSDictionary *)newStyle {
    self.tintColor = nil;
    
    [super setStyle:newStyle];
    
    UIStepper *s = [newStyle objectForKey:@"stepper"];
    if(s != nil) {
        _UIStepper.tintColor = s.tintColor;
        UIControlState state[4] = {UIControlStateDisabled, UIControlStateHighlighted, UIControlStateNormal, UIControlStateSelected};
        for(int i = 0; i < 4; i++) {
            [_UIStepper setBackgroundImage:[s backgroundImageForState:state[i]] forState:state[i]];
            [_UIStepper setDecrementImage:[s decrementImageForState:state[i]] forState:state[i]];
            [_UIStepper setIncrementImage:[s incrementImageForState:state[i]] forState:state[i]];
            for(int j = 0; j < 4; j++) [_UIStepper setDividerImage:[s dividerImageForLeftSegmentState:state[i]
                                                                                    rightSegmentState:state[j]]
                                               forLeftSegmentState:state[i]
                                                 rightSegmentState:state[j]];
        }
        s = nil;
    }
}

@end
