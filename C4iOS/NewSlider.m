//
//  NewSlider.m
//  C4iOS
//
//  Created by moi on 13-02-27.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "NewSlider.h"

@interface NewSlider ()
@property (readonly, atomic) BOOL usesThumbImage, usesThumbImageDisabled, usesThumbImageHighlighted, usesThumbImageSelected;
@property (readonly, atomic) BOOL usesMaxiumumTrackImage, usesMaxiumumTrackImageDisabled, usesMaxiumumTrackImageHighlighted, usesMaxiumumTrackImageSelected;
@property (readonly, atomic) BOOL usesMiniumumTrackImage, usesMiniumumTrackImageDisabled, usesMiniumumTrackImageHighlighted, usesMiniumumTrackImageSelected;
@property (readonly, atomic) BOOL usesMaximumValueImage, usesMinimumValueImage;
@end

@implementation NewSlider
@synthesize thumbColor = _thumbColor, minimumTrackColor = _minimumTrackColor, maximumTrackColor = _maximumTrackColor;
@synthesize thumbImage = _thumbImage, thumbImageDisabled = _thumbImageDisabled, thumbImageSelected = _thumbImageSelected;
@synthesize maximumTrackImage = _maximumTrackImage, maximumTrackImageDisabled = _maximumTrackImageDisabled, maximumTrackImageHighlighted = _maximumTrackImageHighlighted, maximumTrackImageSelected = _maximumTrackImageSelected;
@synthesize minimumTrackImage = _minimumTrackImage, minimumTrackImageDisabled = _minimumTrackImageDisabled, minimumTrackImageHighlighted = _minimumTrackImageHighlighted, minimumTrackImageSelected = _minimumTrackImageSelected;
@synthesize minimumValueImage = _minimumValueImage, maximumValueImage = _maximumValueImage;

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
        [self setupActions];
    }
    return self;
}

-(void)setupActions {
    [self.UISlider addTarget:self action:@selector(touchEvent:) forControlEvents:UIControlEventAllTouchEvents];
}

-(void)touchEvent:(id)sender {
    sender = sender;
}

-(void)setupFromDefaults {
    NewSlider *defaultSlider = [NewSlider defaultStyle];

    self.thumbColor = defaultSlider.thumbColor;
    self.minimumTrackColor = defaultSlider.minimumTrackColor;
    self.maximumTrackColor = defaultSlider.maximumTrackColor;
    
    //NOTE: UISlider only recognizes colors for its UIAppearance (check UISlider.h)
}

-(NSDictionary *)style {
    //mutable local styles
    NSMutableDictionary *localStyle = [[NSMutableDictionary alloc] initWithCapacity:0];
    if(self.usesMaxiumumTrackImage) [localStyle addEntriesFromDictionary:@{@"maximumTrackImage":self.maximumTrackImage}];
    if(self.usesMaxiumumTrackImageDisabled) [localStyle addEntriesFromDictionary:@{@"maximumTrackImageDisabled":self.maximumTrackImageDisabled}];
    if(self.usesMaxiumumTrackImageHighlighted) [localStyle addEntriesFromDictionary:@{@"maximumTrackImageHighlighted":self.maximumTrackImageHighlighted}];
    if(self.usesMaxiumumTrackImageSelected) [localStyle addEntriesFromDictionary:@{@"maximumTrackImageSelected":self.maximumTrackImageSelected}];

    if(self.usesMiniumumTrackImage) [localStyle addEntriesFromDictionary:@{@"minimumTrackImage":self.minimumTrackImage}];
    if(self.usesMiniumumTrackImageDisabled) [localStyle addEntriesFromDictionary:@{@"minimumTrackImageDisabled":self.minimumTrackImageDisabled}];
    if(self.usesMiniumumTrackImageHighlighted) [localStyle addEntriesFromDictionary:@{@"minimumTrackImageHighlighted":self.minimumTrackImageHighlighted}];
    if(self.usesMiniumumTrackImageSelected) [localStyle addEntriesFromDictionary:@{@"minimumTrackImageSelected":self.minimumTrackImageSelected}];

    if(self.usesThumbImage) [localStyle addEntriesFromDictionary:@{@"thumbImage":self.thumbImage}];
    if(self.usesThumbImageDisabled) [localStyle addEntriesFromDictionary:@{@"thumbImageDisabled":self.thumbImageDisabled}];
    if(self.usesThumbImageHighlighted) [localStyle addEntriesFromDictionary:@{@"thumbImageHighlighted":self.thumbImageHighlighted}];
    if(self.usesThumbImageSelected) [localStyle addEntriesFromDictionary:@{@"thumbImageSelected":self.thumbImageSelected}];

    [localStyle addEntriesFromDictionary:@{@"thumbColor" : self.thumbColor}];
    [localStyle addEntriesFromDictionary:@{@"maximumTrackColor" : self.maximumTrackColor}];
    [localStyle addEntriesFromDictionary:@{@"minimumTrackColor" : self.minimumTrackColor}];

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
    // FIXME: These two loops work, but don't differentiate between "types" of objects
    // ... they will NOT, for instance, pull a value out of an NSNumber
    //    for(NSString *propertyName in self.localStylePropertyNames) {
    //        if([styleKeys containsObject:propertyName]) {
    //            SEL selector = [self setterSelectorFromPropertyName:propertyName];
    //            if(selector != nil && [styleKeys containsObject:propertyName]){
    //                objc_msgSend(self,selector,[style objectForKey:propertyName]);
    //            }
    //        }
    //    }
    //
    //    for(NSString *propertyName in self.controlStylePropertyNames) {
    //        if([styleKeys containsObject:propertyName]) {
    //            SEL selector = [self setterSelectorFromPropertyName:propertyName];
    //            if(selector != nil && [styleKeys containsObject:propertyName]){
    //                objc_msgSend(self,selector,[style objectForKey:propertyName]);
    //            }
    //        }
    //    }
    
    NSString *key;

    key = @"thumbColor";
    if([newStyle objectForKey:key] != nil) self.thumbColor = [newStyle objectForKey:key];

    key = @"minimumTrackColor";
    if([newStyle objectForKey:key] != nil)self.minimumTrackColor = [newStyle objectForKey:key];
    
    key = @"maximumTrackColor";
    if([newStyle objectForKey:key] != nil)self.maximumTrackColor = [newStyle objectForKey:key];

    // Local Style Values
    key = @"minimumValueImage";
    if([newStyle objectForKey:key] != nil)self.minimumValueImage = [newStyle objectForKey:key];
    
    key = @"maximumValueImage";
    if([newStyle objectForKey:key] != nil)self.maximumValueImage = [newStyle objectForKey:key];
    
    key = @"thumbImage";
    if([newStyle objectForKey:key] != nil)self.thumbImage = [newStyle objectForKey:key];
    
    key = @"thumbImageDisabled";
    if([newStyle objectForKey:key] != nil)self.thumbImageDisabled = [newStyle objectForKey:key];

    key = @"thumbImageSelected";
    if([newStyle objectForKey:key] != nil)self.thumbImageSelected = [newStyle objectForKey:key];
    
    key = @"thumbImageHighlighted";
    if([newStyle objectForKey:key] != nil)self.thumbImageHighlighted = [newStyle objectForKey:key];

    key = @"minimumTrackImage";
    if([newStyle objectForKey:key] != nil)self.minimumTrackImage = [newStyle objectForKey:key];
    
    key = @"minimumTrackImageHighlighted";
    if([newStyle objectForKey:key] != nil)self.minimumTrackImageHighlighted = [newStyle objectForKey:key];
        
    key = @"minimumTrackImageDisabled";
    if([newStyle objectForKey:key] != nil)self.minimumTrackImageDisabled = [newStyle objectForKey:key];
    
    key = @"minimumTrackImageSelected";
    if([newStyle objectForKey:key] != nil)self.minimumTrackImageSelected = [newStyle objectForKey:key];
    
    key = @"maximumTrackImage";
    if([newStyle objectForKey:key] != nil)self.minimumTrackImage = [newStyle objectForKey:key];
    
    key = @"maximumTrackImageHighlighted";
    self.maximumTrackImageHighlighted = [newStyle objectForKey:key];
    
    key = @"maximumTrackImageDisabled";
    if([newStyle objectForKey:key] != nil)self.maximumTrackImageDisabled = [newStyle objectForKey:key];
    
    key = @"maximumTrackImageSelected";
    if([newStyle objectForKey:key] != nil)self.maximumTrackImageSelected = [newStyle objectForKey:key];
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

#pragma mark other Control Methods (target:action)
-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UISlider addTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [self.UISlider removeTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

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

+(NewSlider *)slider:(CGRect)rect {
    return [[NewSlider alloc] initWithFrame:rect];
}

+(NewSlider *)defaultStyle {
    return (NewSlider *)[NewSlider appearance];
}

-(NewSlider *)copyWithZone:(NSZone *)zone {
    NewSlider *slider = [[NewSlider allocWithZone:zone] initWithFrame:self.frame defaults:NO];
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

@end
