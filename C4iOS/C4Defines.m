//
//  C4Defines.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-18.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Defines.h"

BOOL VERBOSELOAD = NO;

const CGFloat FOREVER = HUGE_VALF;

const CGFloat QUARTER_PI =          (CGFloat)M_PI_4;
const CGFloat HALF_PI =             (CGFloat)M_PI_2;
const CGFloat PI =                  (CGFloat)M_PI;
const CGFloat TWO_PI =              (CGFloat)(2 * M_PI);
const CGFloat ONE_OVER_PI =         (CGFloat)M_1_PI;
const CGFloat TWO_OVER_PI =         (CGFloat)M_2_PI;
const CGFloat TWO_OVER_ROOT_PI =    (CGFloat)M_2_SQRTPI;
const CGFloat E =                   (CGFloat)M_E;
const CGFloat LOG2E =               (CGFloat)M_LOG2E;
const CGFloat LOG10E =              (CGFloat)M_LOG10E;
const CGFloat LN2 =                 (CGFloat)M_LN2;
const CGFloat SQRT_TWO =            (CGFloat)M_SQRT2;
const CGFloat SQRT_ONE_OVER_TWO =   (CGFloat)M_SQRT1_2;

NSString * const TRUNCATENONE = @"none";
NSString * const TRUNCATESTART = @"start";
NSString * const TRUNCATEEND = @"end";
NSString * const TRUNCATEMIDDLE = @"middle";

/* Alignment modes. */

NSString * const ALIGNNATURAL = @"natural";
NSString * const ALIGNLEFT = @"left";
NSString * const ALIGNRIGHT = @"right";
NSString * const ALIGNCENTER = @"center";
NSString * const ALIGNJUSTIFIED = @"justified";

/* `fillRule` values.*/

NSString *const FILLNORMAL = @"non-zero";
NSString *const FILLEVENODD = @"even-odd";

/* `lineJoin' values. */

NSString *const JOINMITER = @"miter";
NSString *const JOINROUND = @"round";
NSString *const JOINBEVEL = @"bevel";

/* `lineCap' values. */

NSString *const CAPBUTT = @"butt";
NSString *const CAPROUND = @"round";
NSString *const CAPSQUARE = @"square";

NSString *const RESIZEASPECT = @"AVLayerVideoGravityResizeAspect";
NSString *const RESIZEFILL = @"AVLayerVideoGravityResizeAspectFill";
NSString *const RESIZEFRAME = @"AVLayerVideoGravityResize";

/* scrollview */
const CGFloat DECELERATENORMAL = 0.99800002574920654296875000000000000000000000000000;
const CGFloat DECELERATEMEDIUM = 0.99400001764297485351562500000000000000000000000000;
const CGFloat DECELERATEFAST = 0.99000000953674316406250000000000000000000000000000;