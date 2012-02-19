//
//  C4Defines.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-12.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#ifndef C4iOSDevelopment_C4Defines_h
#define C4iOSDevelopment_C4Defines_h

//UIKIT_EXTERN NSString *const EASEIN, *const EASEINOUT, *const EASEOUT, *const LINEAR, *const DEFAULT;

enum {
//    UIViewAnimationOptionAllowUserInteraction      = 1 <<  1,
//    UIViewAnimationOptionBeginFromCurrentState     = 1 <<  2,
//    UIViewAnimationOptionRepeat                    = 1 <<  3,
//    UIViewAnimationOptionAutoreverse               = 1 <<  4,
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
#endif
