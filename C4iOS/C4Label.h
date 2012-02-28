//
//  C4Label.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-27.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {		
    WORDWRAP = UILineBreakModeWordWrap,
    CHARWRAP = UILineBreakModeCharacterWrap,
    CLIP = UILineBreakModeClip,
    TRUNCATEHEAD = UILineBreakModeHeadTruncation,
    TRUNCATETAIL = UILineBreakModeTailTruncation,
    TRUNCATEMIDDLE = UILineBreakModeMiddleTruncation,
};
typedef NSUInteger C4LineBreakMode;

enum {
    ALIGNLEFT = UITextAlignmentLeft,
    ALIGNCENTER = UITextAlignmentCenter,
    ALIGNRIGHT = UITextAlignmentRight
};
typedef NSUInteger C4TextAlignment;

enum { 
    ADJUSTBASELINES = UIBaselineAdjustmentAlignBaselines, 
    ALIGNCENTERS = UIBaselineAdjustmentAlignCenters, 
    ALIGNNONE = UIBaselineAdjustmentNone
};
typedef NSUInteger C4BaselineAdjustment;

@interface C4Label : UILabel <C4CommonMethods>
@property(readwrite, strong, nonatomic) C4Font *C4Font;
@property(readwrite, weak, nonatomic) UIFont *UIFont;
@property(nonatomic)        C4TextAlignment textAlignment;
@property(nonatomic)        C4LineBreakMode lineBreakMode;
@property(nonatomic)        C4BaselineAdjustment baselineAdjustment; // default is UIBaselineAdjustmentAlignBaselines

@end