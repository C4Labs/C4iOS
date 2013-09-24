//
//  C4ActivityMonitor.h
//  C4iOS
//
//  Created by moi on 13-03-06.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Control.h"

typedef NS_ENUM(NSInteger, C4ActivityIndicatorStyle) {
    WHITELARGE,
    WHITE,
    GRAY,
};

/**This document describes the C4ActivityIndicator class. Use an activity indicator to show that a task is in progress. An activity indicator appears as a “gear” that is either spinning or stopped.
 
 You control when an activity indicator animates by calling the startAnimating and stopAnimating methods. To automatically hide the activity indicator when animation stops, set the hidesWhenStopped property to YES.
 
 Starting in iOS 5.0, you can set the color of the activity indicator by using the color property.
 */

@interface C4ActivityIndicator : C4Control <C4UIElement>
#pragma mark Initializing an Activity Indicator
///@name Initializing an Activity Indicator
/**Creates, initializes and returns an activity-indicator object.
 
 C4ActivityIndicator sizes the returned instance according to the specified style. You can set and retrieve the style of a activity indicator through the activityIndicatorStyle property.

 @param style A constant that specifies the style of the object to be created. The options are: WHITELARGE, WHITE, GRAY.
 
 @return An initialized C4ActivityIndicator object or nil if the object couldn’t be created.
 */
+(C4ActivityIndicator *)indicatorWithStyle:(C4ActivityIndicatorStyle)style;

/**Initializes and returns an activity-indicator object.
 
 C4ActivityIndicator sizes the returned instance according to the specified style. You can set and retrieve the style of a activity indicator through the activityIndicatorStyle property.
 
 @param style A constant that specifies the style of the object to be created. The options are: WHITELARGE, WHITE, GRAY.
 
 @return An initialized C4ActivityIndicator object or nil if the object couldn’t be created.
 */
-(id)initWithActivityIndicatorStyle:(C4ActivityIndicatorStyle)style;

#pragma mark Managing an Activity Indicator
///@name Managing an Activity Indicator
/**Starts the animation of the progress indicator.
 
 When the progress indicator is animated, the gear spins to indicate indeterminate progress. The indicator is animated until stopAnimating is called.
 */
-(void)startAnimating;

/**Stops the animation of the progress indicator.
 
 Call this method to stop the animation of the progress indicator started with a call to startAnimating. When animating is stopped, the indicator is hidden, unless hidesWhenStopped is NO.
 */
-(void)stopAnimating;

/**Returns whether the receiver is animating.
 
 @return YES if the receiver is animating, otherwise NO.
 */
-(BOOL)isAnimating;

/**The embedded UIActivityIndicatorView.
 
 This is the primary subview of C4ActivityIndicator.
 */
@property (readonly, nonatomic, strong) UIActivityIndicatorView *UIActivityIndicatorView;

/**The basic appearance of the activity indicator.
 
 There are 3 basic styles: WHITELARGE, WHITE, GRAY.
 */
@property (readwrite, nonatomic) C4ActivityIndicatorStyle activityIndicatorStyle;

/**A Boolean value that controls whether the receiver is hidden when the animation is stopped.
 
 If the value of this property is YES (the default), the receiver sets its hidden property (UIView) to YES when receiver is not animating. If the hidesWhenStopped property is NO, the receiver is not hidden when animation stops. You stop an animating progress indicator with the stopAnimating method.
 */
@property (readwrite, nonatomic) BOOL hidesWhenStopped;

/**The color of the activity indicator.
 
 If you set a color for an activity indicator, it overrides the color provided by the activityIndicatorViewStyle property.
 */
@property (readwrite, nonatomic, strong) UIColor *color NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

#pragma mark Default Style
///@name Default Style
/**Returns the appearance proxy for the button, cast as a C4ActivityIndicator rather than the standard (id) cast provided by UIAppearance.
 
 You use this method to grab the appearance object that allows you to change the default style for C4ActivityIndicator objects.
 
 @return The appearance proxy for the receiver, cast as a C4ActivityIndicator.
 */
+(C4ActivityIndicator *)defaultStyle;
@end