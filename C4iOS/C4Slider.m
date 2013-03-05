//
//  NewSlider.m
//  C4iOS
//
//  Created by moi on 13-02-27.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Slider.h"

@interface C4Slider ()
@property (readonly, atomic) BOOL usesThumbImage, usesThumbImageDisabled, usesThumbImageHighlighted, usesThumbImageSelected;
@property (readonly, atomic) BOOL usesMaxiumumTrackImage, usesMaxiumumTrackImageDisabled, usesMaxiumumTrackImageHighlighted, usesMaxiumumTrackImageSelected;
@property (readonly, atomic) BOOL usesMiniumumTrackImage, usesMiniumumTrackImageDisabled, usesMiniumumTrackImageHighlighted, usesMiniumumTrackImageSelected;
@property (readonly, atomic) BOOL usesMaximumValueImage, usesMinimumValueImage;
@end

@implementation C4Slider

#pragma mark style methods
-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame defaults:YES];
}

-(id)initWithFrame:(CGRect)frame defaults:(BOOL)useDefaults {
    self = [super initWithFrame:frame];
    if(self != nil) {
        _UISlider = [[UISlider alloc] initWithFrame:self.frame];
        _UISlider.userInteractionEnabled = NO;
        if(useDefaults) [self setupFromDefaults];
        [self addSubview:_UISlider];
        [self setup];
    }
    return self;
}

-(id)initWithUISlider:(UISlider *)slider {
    self = [super initWithFrame:slider.frame];
    if(self != nil) {
        _UISlider = [slider copy];
        _UISlider.userInteractionEnabled = NO;
        [self addSubview:_UISlider];
        [self setup];
    }
    return self;
}

-(void)touchEvent:(id)sender {
    sender = sender;
}

-(void)setupFromDefaults {
    C4Slider *defaultSlider = [C4Slider defaultStyle];

    self.thumbColor = defaultSlider.thumbColor;
    self.minimumTrackColor = defaultSlider.minimumTrackColor;
    self.maximumTrackColor = defaultSlider.maximumTrackColor;
    
    //NOTE: UISlider only recognizes colors for its UIAppearance (check UISlider.h)
}

-(NSDictionary *)style {
    //mutable local styles
    NSMutableDictionary *localStyle = [[NSMutableDictionary alloc] initWithCapacity:0];
    [localStyle addEntriesFromDictionary:@{@"slider":self.UISlider}];
//    [localStyle addEntriesFromDictionary:@{@"maximumTrackImage":[self.UISlider maximumTrackImageForState:UIControlStateNormal]}];
//    [localStyle addEntriesFromDictionary:@{@"maximumTrackImageDisabled":[self.UISlider maximumTrackImageForState:UIControlStateDisabled]}];
//    [localStyle addEntriesFromDictionary:@{@"maximumTrackImageHighlighted":[self.UISlider maximumTrackImageForState:UIControlStateHighlighted]}];
//    [localStyle addEntriesFromDictionary:@{@"maximumTrackImageSelected":[self.UISlider maximumTrackImageForState:UIControlStateSelected]}];
//
//    [localStyle addEntriesFromDictionary:@{@"minimumTrackImage":[self.UISlider minimumTrackImageForState:UIControlStateNormal]}];
//    [localStyle addEntriesFromDictionary:@{@"minimumTrackImageDisabled":[self.UISlider minimumTrackImageForState:UIControlStateDisabled]}];
//    [localStyle addEntriesFromDictionary:@{@"minimumTrackImageHighlighted":[self.UISlider minimumTrackImageForState:UIControlStateHighlighted]}];
//    [localStyle addEntriesFromDictionary:@{@"minimumTrackImageSelected":[self.UISlider minimumTrackImageForState:UIControlStateSelected]}];
//
//    [localStyle addEntriesFromDictionary:@{@"thumbImage":[self.UISlider thumbImageForState:UIControlStateNormal]}];
//    [localStyle addEntriesFromDictionary:@{@"thumbImageDisabled":[self.UISlider thumbImageForState:UIControlStateDisabled]}];
//    [localStyle addEntriesFromDictionary:@{@"thumbImageHighlighted":[self.UISlider thumbImageForState:UIControlStateHighlighted]}];
//    [localStyle addEntriesFromDictionary:@{@"thumbImageSelected":[self.UISlider thumbImageForState:UIControlStateSelected]}];
//    
//    [localStyle addEntriesFromDictionary:@{@"maximumValueImage":[self.UISlider maximumValueImage]}];
//    [localStyle addEntriesFromDictionary:@{@"minimumValueImage":[self.UISlider minimumValueImage]}];
//
//    [localStyle addEntriesFromDictionary:@{@"thumbColor" : self.thumbColor}];
//    [localStyle addEntriesFromDictionary:@{@"maximumTrackColor" : self.maximumTrackColor}];
//    [localStyle addEntriesFromDictionary:@{@"minimumTrackColor" : self.minimumTrackColor}];

    NSDictionary *controlStyle = [super style];
    
    NSMutableDictionary *localAndControlStyle = [NSMutableDictionary dictionaryWithDictionary:localStyle];
    [localAndControlStyle addEntriesFromDictionary:controlStyle];
    
    localStyle = nil;
    controlStyle = nil;
    
    return (NSDictionary *)localAndControlStyle;
}

-(SEL)setterSelectorFromPropertyName:(NSString *)propertyName {
    NSString *firstLetter = [propertyName substringToIndex:1];
    NSRange range = {0,1};
    NSString *capitalizedPropertyName = [propertyName stringByReplacingCharactersInRange:range withString:[firstLetter uppercaseString]];
    NSString *selectorName = [NSString stringWithFormat:@"set%@:",capitalizedPropertyName];
    SEL selector = NSSelectorFromString(selectorName);
    if([self respondsToSelector:selector]) return selector;
    return nil;
}

-(void)clearStyle {
    self.minimumTrackColor = self.minimumTrackColor = self.thumbColor = nil;
    self.maximumTrackImage = self.maximumTrackImageDisabled = self.maximumTrackImageHighlighted = self.maximumTrackImageSelected = nil;
    self.minimumTrackImage = self.minimumTrackImageDisabled = self.minimumTrackImageHighlighted = self.minimumTrackImageSelected = nil;
    self.maximumValueImage = self.minimumValueImage = nil;
    self.thumbImage = self.thumbImageDisabled = self.thumbImageHighlighted = self.thumbImageSelected = nil;
}

-(void)setStyle:(NSDictionary *)newStyle {
    [self clearStyle];
    [super setStyle:newStyle];

    UISlider *s = [newStyle objectForKey:@"slider"];
    [self.UISlider setMaximumTrackImage:[s maximumTrackImageForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [self.UISlider setMaximumTrackImage:[s maximumTrackImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [self.UISlider setMaximumTrackImage:[s maximumTrackImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.UISlider setMaximumTrackImage:[s maximumTrackImageForState:UIControlStateSelected] forState:UIControlStateSelected];

    [self.UISlider setMinimumTrackImage:[s minimumTrackImageForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [self.UISlider setMinimumTrackImage:[s minimumTrackImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [self.UISlider setMinimumTrackImage:[s minimumTrackImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.UISlider setMinimumTrackImage:[s minimumTrackImageForState:UIControlStateSelected] forState:UIControlStateSelected];

    [self.UISlider setThumbImage:[s thumbImageForState:UIControlStateDisabled] forState:UIControlStateDisabled];
    [self.UISlider setThumbImage:[s thumbImageForState:UIControlStateHighlighted] forState:UIControlStateHighlighted];
    [self.UISlider setThumbImage:[s thumbImageForState:UIControlStateNormal] forState:UIControlStateNormal];
    [self.UISlider setThumbImage:[s thumbImageForState:UIControlStateSelected] forState:UIControlStateSelected];

    [self.UISlider setMaximumValueImage:[s maximumValueImage]];
    [self.UISlider setMinimumValueImage:[s minimumValueImage]];
    
    [self.UISlider setThumbTintColor:[s thumbTintColor]];
    [self.UISlider setMaximumTrackTintColor:[s maximumTrackTintColor]];
    [self.UISlider setMinimumTrackTintColor:[s minimumTrackTintColor]];
    s = nil;
}

-(void)setMinimumValueImage:(C4Image *)image {
    image = [self nilForNullObject:image];
    if(image == nil) _usesMinimumValueImage = NO;
    else _usesMinimumValueImage = YES;
    self.UISlider.minimumValueImage = image.UIImage;
}

-(void)setMaximumValueImage:(C4Image *)image {
    image = [self nilForNullObject:image];
    if(image == nil) _usesMaximumValueImage = NO;
    else _usesMaximumValueImage = YES;
    self.UISlider.maximumValueImage = image.UIImage;
}

-(void)setThumbColor:(UIColor *)color {
    _thumbColor = color;
    self.UISlider.thumbTintColor = [self nilForNullObject:color];
}

-(C4Image *)thumbImage {
    if(self.usesThumbImage == NO) return nil;
    UIImage *image = [self.UISlider thumbImageForState:UIControlStateNormal];
    return [C4Image imageWithUIImage:image];
}

-(void)setThumbImage:(C4Image *)image {
    image = [self nilForNullObject:image];
    if(image == nil) _usesThumbImage = NO;
    else _usesThumbImage = YES;
    [self.UISlider setThumbImage:image.UIImage forState:UIControlStateNormal];
}

-(C4Image *)thumbImageHighlighted {
    if(self.usesThumbImageHighlighted == NO) return nil;
    UIImage *image = [self.UISlider thumbImageForState:UIControlStateHighlighted];
    return [C4Image imageWithUIImage:image];
}

-(void)setThumbImageHighlighted:(C4Image *)image {
    image = [self nilForNullObject:image];
    if(image == nil) _usesThumbImageHighlighted = NO;
    else _usesThumbImageHighlighted = YES;
    [self.UISlider setThumbImage:image.UIImage forState:UIControlStateHighlighted];
}

-(C4Image *)thumbImageDisabled {
    if(self.usesThumbImageDisabled == NO) return nil;
    UIImage *image = [self.UISlider thumbImageForState:UIControlStateDisabled];
    return [C4Image imageWithUIImage:image];
}

-(void)setThumbImageDisabled:(C4Image *)image {
    image = [self nilForNullObject:image];
    if(image == nil) _usesThumbImageDisabled = NO;
    else _usesThumbImageDisabled = YES;
    [self.UISlider setThumbImage:image.UIImage forState:UIControlStateDisabled];
}

-(void)setThumbImageSelected:(C4Image *)image {
    image = [self nilForNullObject:image];
    _thumbImageSelected = image;
    [self.UISlider setThumbImage:image.UIImage forState:UIControlStateHighlighted];
}

-(void)setMinimumTrackImage:(C4Image *)image {
    image = [self nilForNullObject:image];
    _minimumTrackImage = image;
    [self.UISlider setMinimumTrackImage:image.UIImage forState:UIControlStateNormal];
}

-(void)setMinimumTrackImageHighlighted:(C4Image *)image {
    image = [self nilForNullObject:image];
    _minimumTrackImageHighlighted = image;
    [self.UISlider setMinimumTrackImage:image.UIImage forState:UIControlStateHighlighted];
}

-(void)setMinimumTrackImageDisabled:(C4Image *)image {
    image = [self nilForNullObject:image];
    _minimumTrackImageDisabled = image;
    [self.UISlider setMinimumTrackImage:image.UIImage forState:UIControlStateDisabled];
}

-(void)setMinimumTrackImageSelected:(C4Image *)image {
    image = [self nilForNullObject:image];
    _minimumTrackImageSelected = image;
    [self.UISlider setMinimumTrackImage:image.UIImage forState:UIControlStateSelected];
}

-(void)setMaximumTrackColor:(UIColor *)color {
    _maximumTrackColor = color;
    self.UISlider.maximumTrackTintColor = [self nilForNullObject:color];
}

-(void)setMinimumTrackColor:(UIColor *)color {
    _minimumTrackColor = color;
    self.UISlider.minimumTrackTintColor = [self nilForNullObject:color];
}

-(void)setMaximumTrackImage:(C4Image *)image {
    image = [self nilForNullObject:image];
    _maximumTrackImage = image;
    [self.UISlider setMaximumTrackImage:image.UIImage forState:UIControlStateNormal];
}

-(void)setMaximumTrackImageHighlighted:(C4Image *)image {
    image = [self nilForNullObject:image];
    _maximumTrackImageHighlighted = image;
    [self.UISlider setMaximumTrackImage:image.UIImage forState:UIControlStateHighlighted];
}

-(void)setMaximumTrackImageDisabled:(C4Image *)image {
    image = [self nilForNullObject:image];
    _maximumTrackImageDisabled = image;
    [self.UISlider setMaximumTrackImage:image.UIImage forState:UIControlStateDisabled];
}

-(void)setMaximumTrackImageSelected:(C4Image *)image {
    image = [self nilForNullObject:image];
    _maximumTrackImageSelected = image;
    [self.UISlider setMaximumTrackImage:image.UIImage forState:UIControlStateSelected];
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

#pragma mark other C4UIElement (target:action)
-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UISlider addTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UISlider removeTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

#pragma mark Tracking

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self postNotification:@"trackingBegan"];
    [self beginTracking];
    return [self.UISlider beginTrackingWithTouch:touch withEvent:event];
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self postNotification:@"trackingContinued"];
    [self continueTracking];
    return [self.UISlider continueTrackingWithTouch:touch withEvent:event];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self postNotification:@"trackingEnded"];
    [self endTracking];
    return [self.UISlider endTrackingWithTouch:touch withEvent:event];
}

-(void)cancelTrackingWithEvent:(UIEvent *)event {
    [self postNotification:@"trackingCancelled"];
    [self cancelTracking];
    [self.UISlider cancelTrackingWithEvent:event];
}

-(void)beginTracking {
}

-(void)continueTracking {
}

-(void)endTracking {
}

-(void)cancelTracking {
}

+(C4Slider *)slider:(CGRect)rect {
    return [[C4Slider alloc] initWithFrame:rect];
}

+(C4Slider *)defaultStyle {
    return (C4Slider *)[C4Slider appearance];
}

-(C4Slider *)copyWithZone:(NSZone *)zone {
    C4Slider *slider = [[C4Slider allocWithZone:zone] initWithFrame:self.frame defaults:NO];
    slider.style = self.style;
    return slider;
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
    self.UISlider.contentVerticalAlignment = contentHorizontalAlignment;
}

@end
