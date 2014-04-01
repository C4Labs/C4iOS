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

#import "C4Control.h"
/**The C4ScrollView class provides support for displaying content that is larger than the size of the application’s window. It enables users to scroll within that content by making swiping gestures, and to zoom in and back from portions of the content by making pinching gestures.
 
 C4ScrollView is a subclass of C4Control whose primary subview is a UIScrollView object.
 
 The central notion of a C4ScrollView object (or, simply, a scroll view) is that it is a view whose origin is adjustable over the content view. It clips the content to its frame, which generally (but not necessarily) coincides with that of the application’s main window. A scroll view tracks the movements of fingers and adjusts the origin accordingly. The view that is showing its content “through” the scroll view draws that portion of itself based on the new origin, which is pinned to an offset in the content view. The scroll view itself does no drawing except for displaying vertical and horizontal scroll indicators.
 
 The scroll view must know the size of the content view so it knows when to stop scrolling; by default, it “bounces” back when scrolling exceeds the bounds of the content.
 
 Because a scroll view has no scroll bars, it must know whether a touch signals an intent to scroll versus an intent to track a subview in the content. To make this determination, it temporarily intercepts a touch-down event by starting a timer and, before the timer fires, seeing if the touching finger makes any movement. If the timer fires without a significant change in position, the scroll view sends tracking events to the touched subview of the content view. If the user then drags their finger far enough before the timer elapses, the scroll view cancels any tracking in the subview and performs the scrolling itself. Subclasses can override the touchesShouldBegin:withEvent:inContentView:, pagingEnabled, and touchesShouldCancelInContentView: methods (which are called by the scroll view) to affect how the scroll view handles scrolling gestures.
 
 A scroll view also handles zooming and panning of content. As the user makes a pinch-in or pinch-out gesture, the scroll view adjusts the offset and the scale of the content. When the gesture ends, the object managing the content view should should update subviews of the content as necessary. (Note that the gesture can end and a finger could still be down.) While the gesture is in progress, the scroll view does not send any tracking calls to the subview.
 
 The C4ScrollView class can have a delegate that must adopt the *UIScrollViewDelegate* protocol. For zooming and panning to work, the delegate must implement both viewForZoomingInScrollView: and scrollViewDidEndZooming:withView:atScale:; in addition, the maximum (maximumZoomScale) and minimum ( minimumZoomScale) zoom scale must be different.
 */
@interface C4ScrollView : C4Control <UIScrollViewDelegate>

#pragma mark - Creating Scrollviews
///@name Creating ScrollViews
/**Creates and returns a new scrollview sized to the specified frame.
 
 @param rect the frame used to create the size and position of the scrollview.
 @return a new C4ScrollView object.
 */
+ (instancetype)scrollView:(CGRect)rect;

#pragma mark - ScrollView & Delegate
///@name ScrollView & Delegate
/**The UIScrollview object that is the primary subview of the receiver.
 */
@property(nonatomic, readonly) UIScrollView *UIScrollview;

/**The delegate object for the receiver.
 
 This object is passed directly to the receiver's UIScrollView which allows it to act like a normal scrollview delegate.
 */
@property(nonatomic, weak) id<UIScrollViewDelegate> delegate;

#pragma mark - Managing the Display of Content
///@name Managing the Display of Content

/**Sets the offset from the content view’s origin that corresponds to the receiver’s origin.
 
 @param contentOffset A point (expressed in points) that is offset from the content view’s origin.
 @param animated YES to animate the transition at a constant velocity to the new offset, NO to make the transition immediate.
 */
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;

/**The point at which the origin of the content view is offset from the origin of the scroll view.
 
 The default value is CGPointZero.
 */
@property(nonatomic) CGPoint contentOffset;

/**The size of the content view.
 
 The unit of size is points. The default size is CGSizeZero.
 */
@property(nonatomic) CGSize contentSize;

/**The distance that the content view is inset from the enclosing scroll view.
 
 Use this property to add to the scrolling area around the content. The unit of size is points. The default value is UIEdgeInsetsZero.
 */
@property(nonatomic) UIEdgeInsets contentInset;

#pragma mark - Managing Scrolling
///@name Managing Scrolling
/**A Boolean value that determines whether scrolling is enabled.
 
 If the value of this property is YES , scrolling is enabled, and if it is NO , scrolling is disabled. The default is YES.
 
 When scrolling is disabled, the scroll view does not accept touch events; it forwards them up the responder chain.
 */
@property(nonatomic,getter=isScrollEnabled) BOOL scrollEnabled;

/**A Boolean value that determines whether scrolling is disabled in a particular direction
 
 If this property is NO, scrolling is permitted in both horizontal and vertical directions. If this property is YES and the user begins dragging in one general direction (horizontally or vertically), the scroll view disables scrolling in the other direction. If the drag direction is diagonal, then scrolling will not be locked and the user can drag in any direction until the drag completes. The default value is NO
 */
@property(nonatomic,getter=isDirectionalLockEnabled) BOOL directionalLockEnabled;

/**A Boolean value that controls whether the scroll-to-top gesture is effective
 
 The scroll-to-top gesture is a tap on the status bar; when this property is YES, the scroll view jumps to the top of the content when this gesture occurs. The default value of this property is YES.
 
 This gesture works on a single visible scroll view; if there are multiple scroll views (for example, a date picker) with this property set, or if the delegate returns NO in scrollViewShouldScrollToTop:, UIScrollView ignores the request. After the scroll view scrolls to the top of the content view, it sends the delegate a scrollViewDidScrollToTop: message.
 */
@property(nonatomic) BOOL scrollsToTop;

/**Scrolls a specific area of the content so that it is visible in the receiver.
 
 This method scrolls the content view so that the area defined by rect is just visible inside the scroll view. If the area is already visible, the method does nothing.
 
 @param rect A rectangle defining an area of the content view.
 @param animated YES if the scrolling should be animated, NO if it should be immediate.
 */
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;

/**A Boolean value that determines whether paging is enabled for the scroll view.
 
 If the value of this property is YES, the scroll view stops on multiples of the scroll view’s bounds when the user scrolls. The default value is NO.
 */
@property(nonatomic,getter=isPagingEnabled) BOOL pagingEnabled;

/**A Boolean value that controls whether the scroll view bounces past the edge of content and back again.
 
 If the value of this property is YES, the scroll view bounces when it encounters a boundary of the content. Bouncing visually indicates that scrolling has reached an edge of the content. If the value is NO, scrolling stops immediately at the content boundary without bouncing. The default value is YES.
 */
@property(nonatomic) BOOL bounces;

/**A Boolean value that determines whether bouncing always occurs when vertical scrolling reaches the end of the content.
 
 If this property is set to YES and bounces is YES, vertical dragging is allowed even if the content is smaller than the bounds of the scroll view. The default value is NO.
 */
@property(nonatomic) BOOL alwaysBounceVertical;

/**A Boolean value that determines whether bouncing always occurs when horizontal scrolling reaches the end of the content view.
 
 If this property is set to YES and bounces is YES, horizontal dragging is allowed even if the content is smaller than the bounds of the scroll view. The default value is NO.
 */
@property(nonatomic) BOOL alwaysBounceHorizontal;

/**A Boolean value that controls whether touches in the content view always lead to tracking.
 
 If the value of this property is YES and a view in the content has begun tracking a finger touching it, and if the user drags the finger enough to initiate a scroll, the view receives a touchesCancelled:withEvent: message and the scroll view handles the touch as a scroll. If the value of this property is NO, the scroll view does not scroll regardless of finger movement once the content view starts tracking.
 */
@property(nonatomic) BOOL canCancelContentTouches;

/**A Boolean value that determines whether the scroll view delays the handling of touch-down gestures.
 
 If the value of this property is YES, the scroll view delays handling the touch-down gesture until it can determine if scrolling is the intent. If the value is NO , the scroll view immediately calls touchesShouldBegin:withEvent:inContentView:. The default value is YES.
 */
@property(nonatomic) BOOL delaysContentTouches;

/**A floating-point value that determines the rate of deceleration after the user lifts their finger.
 
 Your application can use the DECELERATENORMAL and DECELERATEMEDIUM and DECELERATEFAST constants as reference points for reasonable deceleration rates.
 */
@property(nonatomic) CGFloat decelerationRate;

/**A Boolean value that indicates whether the user has begun scrolling the content. (read-only)
 
 The value held by this property might require some time or distance of scrolling before it is set to YES.
 */
@property(nonatomic, readonly, getter=isDragging) BOOL dragging;

/**Returns whether the user has touched the content to initiate scrolling. (read-only)
 
 The value of this property is YES if the user has touched the content view but might not have yet have started dragging it.
 */
@property(nonatomic, readonly, getter=isTracking) BOOL tracking;

/**Returns whether the content is moving in the scroll view after the user lifted their finger. (read-only)
 
 The returned value is YES if user isn't dragging the content but scrolling is still occurring.
 */
@property(nonatomic, readonly, getter=isDecelerating) BOOL decelerating;

#pragma mark - Managing the Scroll Indicator
///@name Managing the Scroll Indicator
/**The style of the scroll indicators.
 
 Possible values for this are WHITELARGE, WHITE and GRAY.
 */
@property(nonatomic) C4ScrollViewIndicatorStyle indicatorStyle;

/**The distance the scroll indicators are inset from the edge of the scroll view.
 
 The default value is UIEdgeInsetsZero.
 */
@property(nonatomic) UIEdgeInsets scrollIndicatorInsets;

/**A Boolean value that controls whether the horizontal scroll indicator is visible.
 
 The default value is YES. The indicator is visible while tracking is underway and fades out after tracking.
 */
@property(nonatomic) BOOL showsHorizontalScrollIndicator;

/**A Boolean value that controls whether the vertical scroll indicator is visible.
 
 The default value is YES. The indicator is visible while tracking is underway and fades out after tracking.
 */
@property(nonatomic) BOOL showsVerticalScrollIndicator;
/**Displays the scroll indicators momentarily.
 
 You should call this method whenever you bring the scroll view to front.
 */
- (void)flashScrollIndicators;

#pragma mark - Zooming and Panning
///@name Zooming & Panning

/**The underlying gesture recognizer for pan gestures. (read-only)
 
 Your application accesses this property when it wants to more precisely control which pan gestures are recognized by the scroll view.
 */
@property(nonatomic, readonly, strong) UIPanGestureRecognizer *panGestureRecognizer;

/**The underlying gesture recognizer for pinch gestures. (read-only)
 
 Your application accesses this property when it wants to more precisely control which pinch gestures are recognized by the scroll view.
 */
@property(nonatomic, readonly, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;

/**
 Zooms to a specific area of the content so that it is visible in the receiver.
 
 This method zooms so that the content view becomes the area defined by rect, adjusting the zoomScale as necessary.
 
 @param rect A rectangle defining an area of the content view.
 @param animated YES if the scrolling should be animated, NO if it should be immediate.
 */
-(void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

/**A floating-point value that specifies the current scale factor applied to the scroll view's content.
 
 This value determines how much the content is currently scaled. The default value is 1.0.
 */
@property(nonatomic) CGFloat zoomScale;

/**A floating-point value that specifies the current zoom scale.
 
 The new scale value should be between the minimumZoomScale and the maximumZoomScale.
 
 @param scale The new value to scale the content to.
 @param animated YES to animate the transition to the new scale, NO to make the transition immediate.
 */
-(void)setZoomScale:(CGFloat)scale animated:(BOOL)animated;

/**A floating-point value that specifies the maximum scale factor that can be applied to the scroll view's content.
 
 This value determines how large the content can be scaled. It must be greater than the minimum zoom scale for zooming to be enabled. The default value is 1.0.
 */
@property(nonatomic) CGFloat maximumZoomScale;

/**A floating-point value that specifies the minimum scale factor that can be applied to the scroll view's content.
 
 This value determines how small the content can be scaled. The default value is 1.0
 */
@property(nonatomic) CGFloat minimumZoomScale;

/**A Boolean value that indicates that zooming has exceeded the scaling limits specified for the receiver. (read-only)
 
 The value of this property is YES if the scroll view is zooming back to a minimum or maximum zoom scaling value; otherwise the value is NO .
 */
@property(nonatomic, readonly, getter=isZoomBouncing) BOOL zoomBouncing;

/**A Boolean value that indicates whether the content view is currently zooming in or out. (read-only)
 
 The value of this property is YES if user is making a zoom gesture, otherwise it is NO.
 */
@property(nonatomic, readonly, getter=isZooming) BOOL zooming;

/**A Boolean value that determines whether the scroll view animates the content scaling when the scaling exceeds the maximum or minimum limits.
 
 If the value of this property is YES and zooming exceeds either the maximum or minimum limits for scaling, the scroll view temporarily animates the content scaling just past these limits before returning to them. If this property is NO, zooming stops immediately at one a scaling limits. The default is YES.
 */
@property(nonatomic) BOOL bouncesZoom;

#pragma mark - Other Methods
///@name Other Methods
/**Returns whether to cancel touches related to the content subview and start dragging.
 
 The scroll view calls this method just after it starts sending tracking messages to the content view. If it receives NO from this method, it stops dragging and forwards the touch events to the content subview. The scroll view does not call this method if the value of the canCancelContentTouches property is NO.
 
 @param view The view object in the content that is being touched.
 @return value YES to cancel further touch messages to view, NO to have view continue to receive those messages. The default returned value is YES if view is not a UIControl object; otherwise, it returns NO.
 */
- (BOOL)touchesShouldCancelInContentView:(UIView *)view;

@end
