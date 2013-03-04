//
//  C4Button.m
//  C4iOS
//
//  Created by moi on 13-02-28.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Button.h"

@implementation C4Button

+(C4Button *)buttonWithType:(C4ButtonType)type {
    C4Button *button = [[C4Button alloc] initWithType:type];
    return button;
}

-(id)initWithType:(C4ButtonType)type {
    UIButton *newButton = [UIButton buttonWithType:(UIButtonType)type];
    self = [super initWithFrame:newButton.frame];
    if(self != nil) {
        _UIButton = newButton;
        _UIButton.frame = CGRectMake(0,0,44,44);
        [self addSubview:_UIButton];
        [self setup];
    }
    newButton = nil;
    return self;
}

#pragma mark Style 
+(C4Button *)defaultStyle {
    return (C4Button *)[C4Button appearance];
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
    self.UIButton.contentVerticalAlignment = contentHorizontalAlignment;
}

@end
