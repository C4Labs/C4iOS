//
// C4ScrollView.h
// C4iOS
//
// Created by moi on 13-03-07.
// Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4Control.h"

@interface C4ScrollView : C4Control <UIScrollViewDelegate>

+(C4ScrollView *)scrollView:(CGRect)rect;

@property (readonly, nonatomic) UIScrollView *UIScrollview;
@property (assign, nonatomic) id<UIScrollViewDelegate> delegate;
@property (readwrite, nonatomic,getter=isDirectionalLockEnabled) BOOL directionalLockEnabled;
@property (readwrite, nonatomic,getter=isPagingEnabled) BOOL pagingEnabled;
@property (readwrite, nonatomic,getter=isScrollEnabled) BOOL scrollEnabled;
@property (readwrite, nonatomic) BOOL alwaysBounceHorizontal, alwaysBounceVertical, bounces;

@property (readwrite, nonatomic) CGPoint contentOffset;
@property (readwrite, nonatomic) CGSize contentSize;
@property (readwrite, nonatomic) UIEdgeInsets contentInset;
- (void)setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;
- (void)scrollRectToVisible:(CGRect)rect animated:(BOOL)animated;
- (void)flashScrollIndicators;

@property (readwrite, nonatomic) BOOL showsHorizontalScrollIndicator, showsVerticalScrollIndicator;
@property (readwrite, nonatomic) UIEdgeInsets scrollIndicatorInsets;
@property (readwrite, nonatomic) C4ScrollViewIndicatorStyle indicatorStyle;
@property (readwrite, nonatomic) CGFloat decelerationRate;

@property (readonly, nonatomic, getter=isTracking) BOOL tracking;
@property (readonly, nonatomic, getter=isDragging) BOOL dragging;
@property (readonly, nonatomic, getter=isDecelerating) BOOL decelerating;

@property (readwrite, nonatomic) BOOL delaysContentTouches, canCancelContentTouches;

@property (readwrite, nonatomic) CGFloat minimumZoomScale, maximumZoomScale,zoomScale;
-(void)setZoomScale:(CGFloat)scale animated:(BOOL)animated;
-(void)zoomToRect:(CGRect)rect animated:(BOOL)animated;

@property (readwrite, nonatomic) BOOL bouncesZoom;
@property (readonly, nonatomic, getter=isZooming) BOOL zooming;
@property (readonly, nonatomic, getter=isZoomBouncing) BOOL zoomBouncing;

@property (readwrite, nonatomic) BOOL scrollsToTop;

@property (readonly, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (readonly, nonatomic) UIPinchGestureRecognizer *pinchGestureRecognizer;

- (BOOL)touchesShouldCancelInContentView:(UIView *)view;

//FIXME: the following is troublesome... looking ahead, i guess if anyone wants to use this method they'll be sufficiently able to code it with a regular UIScrollview

// override points for subclasses to control delivery of touch events to subviews of the scroll view
// called before touches are delivered to a subview of the scroll view. if it returns NO the touches will not be delivered to the subview
// default returns YES
- (BOOL)touchesShouldBegin:(NSSet *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view;

@end
