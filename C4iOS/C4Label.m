//
//  C4Label.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Label.h"

@interface C4Label()
@end

@implementation C4Label
@synthesize adjustsFontSizeToFitWidth = _adjustsFontSizeToFitWidth, baselineAdjustment = _baselineAdjustment, enabled = _enabled, font = _font, highlighted = _highlighted, highlightedTextColor = _highlightedTextColor, lineBreakMode = _lineBreakMode, minimumFontSize = _minimumFontSize, numberOfLines = _numberOfLines, shadowColor = _shadowColor, shadowOffset = _shadowOffset, text = _text, textAlignment = _textAlignment, textColor = _textColor, userInteractionEnabled = _userInteractionEnabled;
@synthesize label = _label;

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    if(CGRectEqualToRect(frame, CGRectZero)) frame = CGRectMake(0, 0, 1, 1);
    self = [super initWithFrame:frame];
    if(self != nil) {
    }
    return self;
}

-(void)sizeToFit {
    [self.label sizeToFit];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.label.frame.size.width, self.label.frame.size.height);
    C4Log(@"label:%4.2f,%4.2f",self.label.frame.size.height,self.label.frame.size.width);
}

-(void)setText:(NSString *)text {
    if(_label == nil) {
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _label.enabled = YES;
        _label.textColor = [UIColor blackColor];
        _label.backgroundColor = [UIColor lightGrayColor];
        [_label setText:[NSString stringWithString:@"Hello World"]];
        [self addSubview:_label];
    }
}

-(void)addSubview:(UIView *)view {
    [super addSubview:view];
    C4Log(@"label addSubview, %d %@",[self.subviews count], view == nil ? @"viewIsNil" : @"viewIsNotNil");
}

-(NSString *)text {
    return self.label.text;
}

@end
