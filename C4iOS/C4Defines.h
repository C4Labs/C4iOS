//
//  C4Defines.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-12.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#ifndef C4iOSDevelopment_C4Defines_h
#define C4iOSDevelopment_C4Defines_h

#ifndef C4RED
#define C4RED [UIColor colorWithRed:1.0f green:0.196 blue:0.196 alpha:1.0f];
#endif

#ifndef C4BLUE
#define C4BLUE [UIColor colorWithRed:0.196 green:0.392 blue:1.0f alpha:1.0f];
#endif

#ifndef C4GREY
#define C4GREY [UIColor colorWithRed:0.125 green:0.125 blue:0.125 alpha:1.0f];
#endif

//UIKIT_EXTERN NSString *const EASEIN, *const EASEINOUT, *const EASEOUT, *const LINEAR, *const DEFAULT;

UIKIT_EXTERN const CGFloat FOREVER;

UIKIT_EXTERN BOOL VERBOSELOAD;

/* more lexical names for common mathematic variables, e.g. QUARTER_PI instead of M_PI_4 */
UIKIT_EXTERN const CGFloat QUARTER_PI, HALF_PI, PI, TWO_PI, ONE_OVER_PI, TWO_OVER_PI, TWO_OVER_ROOT_PI, E, LOG2E, LOG10E, LN2, LN10, SQRT_TWO, SQRT_ONE_OVER_TWO;

enum {
    ALLOWSINTERACTION = UIViewAnimationOptionAllowUserInteraction,
//    UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2,
        REPEAT = UIViewAnimationOptionRepeat,
        AUTOREVERSE = UIViewAnimationOptionAutoreverse,
//    UIViewAnimationOptionOverrideInheritedDuration = 1 <<  5,
//    UIViewAnimationOptionOverrideInheritedCurve    = 1 <<  6,
//    UIViewAnimationOptionAllowAnimatedContent      = 1 <<  7,
//    UIViewAnimationOptionShowHideTransitionViews   = 1 <<  8,
//    
//    UIViewAnimationOptionCurveEaseInOut            = 0 << 16,
//    UIViewAnimationOptionCurveEaseIn               = 1 << 16,
//    UIViewAnimationOptionCurveEaseOut              = 2 << 16,
//    UIViewAnimationOptionCurveLinear               = 3 << 16,
    EASEINOUT            = UIViewAnimationOptionCurveEaseInOut,
    EASEIN               = UIViewAnimationOptionCurveEaseIn,
    EASEOUT              = UIViewAnimationOptionCurveEaseOut,
    LINEAR               = UIViewAnimationOptionCurveLinear,
//    
//    UIViewAnimationOptionTransitionNone            = 0 << 20,
//    UIViewAnimationOptionTransitionFlipFromLeft    = 1 << 20,
//    UIViewAnimationOptionTransitionFlipFromRight   = 2 << 20,
//    UIViewAnimationOptionTransitionCurlUp          = 3 << 20,
//    UIViewAnimationOptionTransitionCurlDown        = 4 << 20,
//    UIViewAnimationOptionTransitionCrossDissolve   = 5 << 20,
//    UIViewAnimationOptionTransitionFlipFromTop     = 6 << 20,
//    UIViewAnimationOptionTransitionFlipFromBottom  = 7 << 20,
};
typedef NSUInteger C4AnimationOptions;

enum {
    PATH = 0,
    FILLCOLOR,
    LINEDASHPHASE,
    LINEWIDTH,
    MITRELIMIT,
    STROKECOLOR,
    STROKEEND,
    STROKESTART
};
typedef NSUInteger C4ShapeLayerAnimationType;
#endif
