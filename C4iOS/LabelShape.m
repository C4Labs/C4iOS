//
//  LabelShape.m
//  C4iOS
//
//  Created by Travis Kirton on 12-06-20.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "LabelShape.h"


@implementation LabelShape {
    BOOL labelIsVisible, labelIsSet;
}

@synthesize label = _label;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.fillColor = [UIColor colorWithRed:0.33
                                         green:0.33
                                          blue:([C4Math randomInt:66]+33)/100.0f
                                         alpha:1.0f];
        self.lineWidth = 0.0f;
        [self ellipse:self.frame];
        labelIsSet = NO;
        labelIsVisible = NO;
        NSString *labelText = [NSString stringWithFormat:@"shape %d",self.tag];
        _label = [C4Shape shapeFromString:labelText withFont:[C4Font systemFontOfSize:12]];
        _label.fillColor = C4GREY;
        _label.lineWidth = 0.0f;
        _label.origin = self.center;
    }
    return self;
}

-(void)touchesBegan {
    if (labelIsSet == NO) {
        NSString *labelText = [NSString stringWithFormat:@"shape %d",self.tag];
        [_label shapeFromString:labelText withFont:[C4Font systemFontOfSize:12]];
        CGPoint p = self.origin;
        p.x += 10;
        _label.origin = p;
        labelIsSet = YES;
    }
    if (labelIsVisible == NO) {
        [self addSubview:self.label];
        labelIsVisible = YES;
    } else {
        [self removeObject:self.label];
        labelIsVisible = NO;
    }
}

@end


