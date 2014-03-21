// Copyright © 2012 Travis Kirton
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

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

/* 'camera quality' values */
NSString *const C4CameraQualityPhoto = @"AVCaptureSessionPresetPhoto";
NSString *const C4CameraQualityHigh = @"AVCaptureSessionPresetHigh";
NSString *const C4CameraQualityMedium = @"AVCaptureSessionPresetMedium";
NSString *const C4CameraQualityLow = @"AVCaptureSessionPresetLow";
NSString *const C4CameraQuality352x288 = @"AVCaptureSessionPreset352x288";
NSString *const C4CameraQuality640x480 = @"AVCaptureSessionPreset640x480";
NSString *const C4CameraQuality1280x720 = @"AVCaptureSessionPreset1280x720";
NSString *const C4CameraQuality1920x1080 = @"AVCaptureSessionPreset1920x1080";
NSString *const C4CameraQualityiFrame960x540 = @"AVCaptureSessionPresetiFrame960x540";
NSString *const C4CameraQualityiFrame1280x720 = @"AVCaptureSessionPresetiFrame1280x720";