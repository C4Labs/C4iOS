//
//  C4VideoPlayerView.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-11-19.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "C4PlayerLayer.h"

@class C4PlayerLayer;

@interface C4Movie : C4Control {
    NSURL *movieURL;
    void *rateContext, *currentItemContext, *playerItemStatusContext;
}
+(C4Movie *)movieNamed:(NSString *)movieName;
+(C4Movie *)movieNamed:(NSString *)movieName inFrame:(CGRect)movieFrame;

-(id)initWithMovieName:(NSString *)movieName;
-(id)initWithMovieName:(NSString *)movieName andFrame:(CGRect)movieFrame;
-(void)play;
-(CGFloat)duration;
-(CGFloat)currentTime;
-(void)seekToTime:(CGFloat)time;
-(void)seekByAddingTime:(CGFloat)time;
-(void)reachedEnd;
-(void)currentTimeChanged;

@property (readonly, nonatomic) CGSize originalMovieSize;
@property (readonly, nonatomic) CGFloat originalMovieRatio;
@property (nonatomic, strong, readonly) C4PlayerLayer *playerLayer;
@property (nonatomic) CGFloat rate;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (readonly) BOOL isPlaying;
@property BOOL loops;
@property BOOL shouldAutoplay;


/**Specifies the blur radius used to render the receiver’s shadow. 
 
 This applies to the shadow of the contents of the layer, and not specifically the text.
 */
@property (readwrite, nonatomic) CGFloat shadowRadius;

/**Specifies the opacity of the receiver’s shadow. Animatable.
 
 This applies to the shadow of the contents of the layer, and not specifically the text.
 */
@property (readwrite, nonatomic) CGFloat shadowOpacity;
/**The shadow color of the text.
 
 The default value for this property is nil, which indicates that no shadow is drawn. In addition to this property, you may also want to change the default shadow offset by modifying the shadowOffset property. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property (readwrite, strong, nonatomic) UIColor *shadowColor;

/**The shadow offset (measured in points) for the text.
 
 The shadow color must be non-nil for this property to have any effect. The default offset size is (0, -1), which indicates a shadow one point above the text. Text shadows are drawn with the specified offset and color and no blurring.
 */
@property (readwrite, nonatomic) CGSize shadowOffset;

/**Defines the shape of the shadow. Animatable.
 
 Unlike most animatable properties, shadowPath does not support implicit animation. 
 
 If the value in this property is non-nil, the shadow is created using the specified path instead of the layer’s composited alpha channel. The path defines the outline of the shadow. It is filled using the non-zero winding rule and the current shadow color, opacity, and blur radius.
 
 Specifying an explicit path usually improves rendering performance.
 
 The default value of this property is NULL.
 */
@property (readwrite, nonatomic) CGPathRef shadowPath;
@end
