//
//  C4View.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C4View : UIView {
//    C4ViewAnimationDuration animationDuration;
}
@property (readwrite) CGFloat animationDuration;
@property (readwrite, nonatomic) C4ViewAnimationTiming animationTiming;
@end
