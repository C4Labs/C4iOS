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

@interface C4Control()
@property(nonatomic, strong) UIView* view;

@property (nonatomic) BOOL shouldAutoreverse;
@property (nonatomic, strong) NSString *longPressMethodName;
@property (nonatomic, strong) NSMutableDictionary *gestureDictionary;
@property (nonatomic) CGPoint firstPositionForMove;
@end

@implementation C4Control

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    return [self initWithView:[[UIView alloc] initWithFrame:frame]];
}

- (id)initWithView:(UIView*)view {
    self = [super init];
    if (!self)
        return nil;
    
    self.view = view;
    self.longPressMethodName = @"pressedLong";
    self.shouldAutoreverse = NO;
    
    C4Template* template = (C4Template*)[[self class] defaultTemplate];
    [template applyToTarget:self];
    
    return self;
}

- (void)dealloc {
    [[NSRunLoop mainRunLoop] cancelPerformSelectorsWithTarget:self];
    
    for (UIGestureRecognizer *g in [self.gestureDictionary allValues]) {
        [g removeTarget:self action:nil];
        [_view removeGestureRecognizer:g];
    }
}

- (C4Layer *)layer {
    return (C4Layer *)_view.layer;
}


#pragma mark UIView animatable properties

- (CGPoint)center {
    return _view.center;
}

- (void)setCenter:(CGPoint)center {
    if (_animationDuration == 0.0f) {
        _view.center = center;
        return;
    }
    
    CGPoint oldCenter = CGPointMake(_view.center.x, _view.center.y);
    void (^animationBlock)() = ^() { _view.center = center; };
    void (^reverseBlock)() = ^() { _view.center = oldCenter; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (CGPoint)origin {
    return _view.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGPoint difference = origin;
    difference.x += _view.frame.size.width/2.0f;
    difference.y += _view.frame.size.height/2.0f;
    self.center = difference;
}

- (CGRect)frame {
    return _view.frame;
}

- (void)setFrame:(CGRect)frame {
    if (_animationDuration == 0.0f) {
        _view.frame = frame;
        return;
    }
    
    CGRect oldFrame = _view.frame;
    void (^animationBlock)() = ^() { _view.frame = frame; };
    void (^reverseBlock)() = ^() { _view.frame = oldFrame; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (void)setBounds:(CGRect)bounds {
    if (_animationDuration == 0.0f) {
        _view.bounds = bounds;
        return;
    }
    
    CGRect oldBounds = _view.bounds;
    void (^animationBlock)() = ^() { _view.bounds = bounds; };
    void (^reverseBlock)() = ^() { _view.bounds = oldBounds; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (CGAffineTransform)transform {
    return _view.transform;
}

- (void)setTransform:(CGAffineTransform)transform {
    if (_animationDuration == 0.0f) {
        _view.transform = transform;
        return;
    }
    
    CGAffineTransform oldTransform = _view.transform;
    void (^animationBlock)() = ^() { _view.transform = transform; };
    void (^reverseBlock)() = ^() { _view.transform = oldTransform; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (UIColor*)backgroundColor {
    return _view.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (_animationDuration == 0.0f) {
        _view.backgroundColor = backgroundColor;
        return;
    }
    
    UIColor *oldBackgroundColor = _view.backgroundColor;
    void (^animationBlock)() = ^() { _view.backgroundColor = backgroundColor; };
    void (^reverseBlock)() = ^() { _view.backgroundColor = oldBackgroundColor; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (CGFloat)alpha {
    return _view.alpha;
}

- (void)setAlpha:(CGFloat)alpha {
    if (_animationDuration == 0.0f) {
        _view.alpha = alpha;
        return;
    }
    
    CGFloat oldAlpha = _view.alpha;
    void (^animationBlock)() = ^() { _view.alpha = alpha; };
    void (^reverseBlock)() = ^() { _view.alpha = oldAlpha; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (BOOL)isHidden {
    return _view.isHidden;
}

- (void)setHidden:(BOOL)hidden {
    _view.hidden = hidden;
}


#pragma mark Position, Rotation, Transform

- (CGFloat)width {
    return _view.bounds.size.width;
}

- (CGFloat)height {
    return _view.bounds.size.height;
}

- (CGSize)size {
    return _view.bounds.size;
}

- (CGFloat)zPosition {
    return _view.layer.zPosition;
}

- (void)setZPosition:(CGFloat)zPosition {
    if (self.animationDuration == 0.0f)
        _view.layer.zPosition = zPosition;
    else
        [(id <C4LayerAnimation>)_view.layer animateZPosition:zPosition];
}

- (void)setRotation:(CGFloat)rotation {
    if (self.animationDuration == 0.0f)
        [self _setRotation:@(rotation)];
    else
        [self performSelector:@selector(_setRotation:) withObject:@(rotation) afterDelay:self.animationDelay];
}

- (void)_setRotation:(NSNumber *)rotation {
    _rotation = [rotation floatValue];
    [(id <C4LayerAnimation>)_view.layer animateRotation:_rotation];
}

- (CGFloat)rotationX {
    return [[_view.layer valueForKeyPath:@"transform.rotation.x"] floatValue];
}

- (void)setRotationX:(CGFloat)rotation {
    if(self.animationDelay == 0.0f) [self _setRotationX:@(rotation)];
    else [self performSelector:@selector(_setRotationX:) withObject:@(rotation) afterDelay:self.animationDelay];
}

- (void)_setRotationX:(NSNumber *)rotation {
    [(id <C4LayerAnimation>)_view.layer animateRotationX:[rotation floatValue]];
}

- (CGFloat)rotationY {
    return [[_view.layer valueForKeyPath:@"transform.rotation.y"] floatValue];
}

- (void)setRotationY:(CGFloat)rotation {
    if(self.animationDelay == 0.0f) [self _setRotationY:@(rotation)];
    else [self performSelector:@selector(_setRotationY:) withObject:@(rotation) afterDelay:self.animationDelay];
}

- (void)_setRotationY:(NSNumber *)rotation {
    [(id <C4LayerAnimation>)_view.layer animateRotationY:[rotation floatValue]];
}

- (void)rotationDidFinish:(CGFloat)rotation {
    [_view setTransform:CGAffineTransformMakeRotation(rotation)];
}

- (void)setLayerTransform:(CATransform3D)transform {
    _layerTransform = transform;
    [(id <C4LayerAnimation>)_view.layer animateLayerTransform:transform];
}

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    _anchorPoint = anchorPoint;
    CGRect oldFrame = _view.frame;
    _view.layer.anchorPoint = anchorPoint;
    _view.frame = oldFrame;
}

- (void)setPerspectiveDistance:(CGFloat)distance {
    _perspectiveDistance = distance;
    [(id <C4LayerAnimation>)_view.layer setPerspectiveDistance:distance];
}

#pragma mark Animation methods

- (void)animateWithBlock:(void (^)())animationBlock {
    [self animateWithBlock:animationBlock reverseBlock:nil];
}

- (void)animateWithBlock:(void (^)())animationBlock reverseBlock:(void (^)())reverseBlock {
    void (^completionBlock)(BOOL) = NULL;
    
    //we insert the autoreverse options here, only if it should repeat and autoreverse
    C4AnimationOptions autoReverseOptions = self.animationOptions;
    BOOL shouldRepeat = (self.animationOptions & REPEAT) == REPEAT;
    if (self.shouldAutoreverse && shouldRepeat)
        autoReverseOptions |= AUTOREVERSE;
    
    
    if (self.shouldAutoreverse && !shouldRepeat && reverseBlock) {
        completionBlock = ^(BOOL animationIsComplete) {
            [self autoreverseAnimation:^() {
                reverseBlock();
            }];
        };
    }
    
    [UIView animateWithDuration:self.animationDuration
                          delay:(NSTimeInterval)self.animationDelay
                        options:(UIViewAnimationOptions)autoReverseOptions
                     animations:animationBlock
                     completion:completionBlock];
}

- (void)autoreverseAnimation:(void (^)(void))animationBlock {
    C4AnimationOptions autoreverseOptions = BEGINCURRENT;
    if ((self.animationOptions & LINEAR) == LINEAR) autoreverseOptions |= LINEAR;
    else if ((self.animationOptions & EASEIN) == EASEIN) autoreverseOptions |= EASEOUT;
    else if ((self.animationOptions & EASEOUT) == EASEOUT) autoreverseOptions |= EASEIN;
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0
                        options:(UIViewAnimationOptions)autoreverseOptions
                     animations:animationBlock
                     completion:nil];
}

- (void)setAnimationDuration:(CGFloat)duration {
    _animationDuration = duration;
    ((id <C4LayerAnimation>)_view.layer).animationDuration = duration;
}

- (void)setAnimationOptions:(NSUInteger)animationOptions {
    /*
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    ((id <C4LayerAnimation>)_view.layer).animationOptions = animationOptions;
    
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    
    _animationOptions = animationOptions | BEGINCURRENT;
}

#pragma mark Move
-(void)move:(id)sender {
    UIPanGestureRecognizer *p = (UIPanGestureRecognizer *)sender;
    
    NSUInteger _ani = self.animationOptions;
    CGFloat _dur = self.animationDuration;
    CGFloat _del = self.animationDelay;
    self.animationDuration = 0;
    self.animationDelay = 0;
    self.animationOptions = DEFAULT;
    
    CGPoint translatedPoint = [p translationInView:_view];
    
    translatedPoint.x += self.center.x;
    translatedPoint.y += self.center.y;
    
    self.center = translatedPoint;
    [p setTranslation:CGPointZero inView:_view];
    [self postNotification:@"moved"];
    
    self.animationDelay = _del;
    self.animationDuration = _dur;
    self.animationOptions = _ani;
}

#pragma mark Gesture Methods

-(void)addGesture:(C4GestureType)type name:(NSString *)gestureName action:(NSString *)methodName {
    if(self.gestureDictionary == nil) self.gestureDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    BOOL containsGesture = ((self.gestureDictionary)[gestureName] != nil);
    if(containsGesture == NO) {
        UIGestureRecognizer *recognizer;
        switch (type) {
            case TAP:
                recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                break;
            case PAN:
                recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                break;
            case SWIPERIGHT:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRRIGHT;
                break;
            case SWIPELEFT:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRLEFT;
                break;
            case SWIPEUP:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRUP;
                break;
            case SWIPEDOWN:
                recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:NSSelectorFromString(methodName)];
                ((UISwipeGestureRecognizer *)recognizer).direction = SWIPEDIRDOWN;
                break;
            case LONGPRESS:
                self.longPressMethodName = methodName;
                recognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressedLong:)];
                break;
            default:
                C4Assert(NO,@"The gesture you tried to use is not one of: TAP, PINCH, SWIPERIGHT, SWIPELEFT, SWIPEUP, SWIPEDOWN, ROTATION, PAN, or LONGPRESS");
                break;
        }
        recognizer.delaysTouchesBegan = YES;
        recognizer.delaysTouchesEnded = YES;
        [_view addGestureRecognizer:recognizer];
        (self.gestureDictionary)[gestureName] = recognizer;
    }
}

-(UIGestureRecognizer *)gestureForName:(NSString *)gestureName {
    return (self.gestureDictionary)[gestureName];
}

-(NSDictionary *)allGestures {
    return self.gestureDictionary;
}

-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UITapGestureRecognizer class]] ||
             [recognizer isKindOfClass:[UILongPressGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",[recognizer class],NSStringFromSelector(_cmd));
    
    ((UILongPressGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
}

-(void)numberOfTouchesRequired:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UITapGestureRecognizer class]] ||
             [recognizer isKindOfClass:[UISwipeGestureRecognizer class]] ||
             [recognizer isKindOfClass:[UILongPressGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",[recognizer class],NSStringFromSelector(_cmd));
    
    ((UITapGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
}

-(void)minimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UILongPressGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method %@",[recognizer class],NSStringFromSelector(_cmd));
    
    ((UILongPressGestureRecognizer *) recognizer).minimumPressDuration = duration;
}

-(void)minimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UIPanGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",[recognizer class],NSStringFromSelector(_cmd));
    
    ((UIPanGestureRecognizer *) recognizer).minimumNumberOfTouches = touchCount;
}

-(void)maximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UIPanGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",[recognizer class],NSStringFromSelector(_cmd));
    
    ((UIPanGestureRecognizer *) recognizer).maximumNumberOfTouches = touchCount;
}

-(void)swipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = _gestureDictionary[gestureName];
    
    C4Assert([recognizer isKindOfClass:[UISwipeGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %@",[recognizer class],NSStringFromSelector(_cmd));
    
    ((UISwipeGestureRecognizer *) recognizer).direction = (UISwipeGestureRecognizerDirection)direction;
}

-(void)swipedRight:(id)sender {
    sender = sender;
    [self postNotification:@"swipedRight"];
    [self swipedRight];
}

-(void)swipedLeft:(id)sender {
    sender = sender;
    [self postNotification:@"swipedLeft"];
    [self swipedLeft];
}

-(void)swipedUp:(id)sender {
    sender = sender;
    [self postNotification:@"swipedUp"];
    [self swipedUp];
}

-(void)swipedDown:(id)sender {
    sender = sender;
    [self postNotification:@"swipedDown"];
    [self swipedDown];
}

-(void)tapped:(id)sender {
    sender = sender;
    [self postNotification:NSStringFromSelector(_cmd)];
    [self tapped];
}

-(void)tapped {
}


-(void)swipedUp {
}

-(void)swipedDown {
}

-(void)swipedLeft {
}

-(void)swipedRight {
}

-(void)pressedLong {
}

-(void)pressedLong:(id)sender {
    if(((UIGestureRecognizer *)sender).state == UIGestureRecognizerStateBegan
       && [((UIGestureRecognizer *)sender) isKindOfClass:[UILongPressGestureRecognizer class]]) {
        [self runMethod:self.longPressMethodName withObject:sender afterDelay:0.0f];
        [self postNotification:@"pressedLong"];
    }
}

#pragma mark C4AddSubview

-(void)addCamera:(C4Camera *)camera {
    C4Assert([camera isKindOfClass:[C4Camera class]],
             @"You tried to add a %@ using [canvas addShape:]", [camera class]);
    [_view addSubview:camera.view];
}

-(void)addShape:(C4Shape *)shape {
    C4Assert([shape isKindOfClass:[C4Shape class]],
             @"You tried to add a %@ using [canvas addShape:]", [shape class]);
    [_view addSubview:shape.view];
}

-(void)addSubview:(UIView *)subview {
    C4Assert(![[subview class] isKindOfClass:[C4Camera class]], @"You just tried to add a C4Camera using the addSubview: method, please use addCamera:");
    C4Assert(![[subview class] isKindOfClass:[C4Shape class]], @"You just tried to add a C4Shape using the addSubview: method, please use addShape:");
    C4Assert(![[subview class] isKindOfClass:[C4Movie class]], @"You just tried to add a C4Movie using the addSubview: method, please use addMovie:");
    C4Assert(![[subview class] isKindOfClass:[C4Image class]], @"You just tried to add a C4Image using the addSubview: method, please use addImage:");
    C4Assert(![[subview class] isKindOfClass:[C4GL class]], @"You just tried to add a C4GL using the addSubview: method, please use addGL:");
//    C4Assert(![subview conformsToProtocol:NSProtocolFromString(@"C4UIElement")], @"You just tried to add a C4UIElement using the addSubview: method, please use addUIElement:");
    [_view addSubview:subview];
}

-(void)addUIElement:(id<C4UIElement>)object {
    [_view addSubview:((C4Control *)object).view];
}

-(void)addGL:(C4GL *)gl {
    C4Assert([gl isKindOfClass:[C4GL class]],
             @"You tried to add a %@ using [canvas addGL:]", [gl class]);
    [_view addSubview:gl.view];
}

-(void)addImage:(C4Image *)image {
    C4Assert([image isKindOfClass:[C4Image class]],
             @"You tried to add a %@ using [canvas addImage:]", [image class]);
    [_view addSubview:image.view];
}

-(void)addLabel:(C4Label *)label {
    C4Assert([label isKindOfClass:[C4Label class]],
             @"You tried to add a %@ using [canvas addLabel:]", [label class]);
    [_view addSubview:label.view];
}

-(void)addMovie:(C4Movie *)movie {
    C4Assert([movie isKindOfClass:[C4Movie class]],
             @"You tried to add a %@ using [canvas addMovie:]", [movie class]);
    [_view addSubview:movie.view];
}

-(void)addObjects:(NSArray *)array {
    for(id obj in array) {
        if([obj isKindOfClass:[C4Shape class]]) {
            [self addShape:obj];
        }
        else if([obj isKindOfClass:[C4GL class]]) {
            [self addGL:obj];
        }
        else if([obj isKindOfClass:[C4Image class]]) {
            [self addImage:obj];
        }
        else if([obj isKindOfClass:[C4Movie class]]) {
            [self addMovie:obj];
        }
        else if([obj isKindOfClass:[C4Camera class]]) {
            [self addCamera:obj];
        }
        else if([obj isKindOfClass:[UIView class]]) {
            [self addSubview:obj];
        }
        else if([obj conformsToProtocol:NSProtocolFromString(@"C4UIElement")]) {
            [self addSubview:obj];
        }
        else {
            C4Log(@"unable to determine type of class");
        }
    }
}

-(void)removeObject:(id)visualObject {
    C4Assert(self != visualObject, @"You tried to remove %@ from itself, don't be silly", visualObject);
    if([visualObject isKindOfClass:[UIView class]] ||
       [visualObject isKindOfClass:[C4Control class]])
        [visualObject removeFromSuperview];
    else C4Log(@"object (%@) you wish to remove is not a visual object", visualObject);
}

-(void)removeObjects:(NSArray *)array {
    for(id obj in array) {
        [self removeObject:obj];
    }
}

#pragma mark Masking
-(void)setMask:(C4Control *)maskObject {
    _view.layer.mask = maskObject.view.layer;
}

-(void)setMasksToBounds:(BOOL)masksToBounds {
    _view.layer.masksToBounds = masksToBounds;
}

-(BOOL)masksToBounds {
    return _view.layer.masksToBounds;
}

#pragma mark Shadow
-(void)setShadowColor:(UIColor *)shadowColor {
    if(self.animationDelay == 0) [self _setShadowColor:shadowColor];
    else [self performSelector:@selector(_setShadowColor:) withObject:shadowColor afterDelay:self.animationDelay];
}

-(void)_setShadowColor:(UIColor *)shadowColor {
    if(self.animationDuration == 0.0f) _view.layer.shadowColor = shadowColor.CGColor;
    else [(id <C4LayerAnimation>)_view.layer animateShadowColor:shadowColor.CGColor];
}

-(UIColor *)shadowColor {
    return [UIColor colorWithCGColor:_view.layer.shadowColor];
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    if(self.animationDelay == 0) [self _setShadowOffSet:[NSValue valueWithCGSize:shadowOffset]];
    else [self performSelector:@selector(_setShadowOffSet:) withObject:[NSValue valueWithCGSize:shadowOffset] afterDelay:self.animationDelay];
}

-(void)_setShadowOffSet:(NSValue *)shadowOffset {
    if(self.animationDuration == 0.0f) _view.layer.shadowOffset = [shadowOffset CGSizeValue];
    else [(id <C4LayerAnimation>)_view.layer animateShadowOffset:[shadowOffset CGSizeValue]];
}

-(CGSize)shadowOffset {
    return _view.layer.shadowOffset;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    if(self.animationDelay == 0) [self _setShadowOpacity:@(shadowOpacity)];
    else [self performSelector:@selector(_setShadowOpacity:) withObject:@(shadowOpacity) afterDelay:self.animationDelay];
}

-(void)_setShadowOpacity:(NSNumber *)shadowOpacity {
    if(self.animationDuration == 0.0f) _view.layer.shadowOpacity = [shadowOpacity floatValue];
    else [(id <C4LayerAnimation>)_view.layer animateShadowOpacity:[shadowOpacity floatValue]];
}

-(CGFloat)shadowOpacity {
    return _view.layer.shadowOpacity;
}

-(void)setShadowPath:(CGPathRef)shadowPath {
    if(self.animationDelay == 0) [self _setShadowPath:(__bridge id)shadowPath];
    else [self performSelector:@selector(_setShadowPath:) withObject:(__bridge id)shadowPath afterDelay:self.animationDelay];
}

-(void)_setShadowPath:(id)shadowPath {
    if(self.animationDuration == 0.0f) _view.layer.shadowPath = (__bridge CGPathRef)shadowPath;
    else [(id <C4LayerAnimation>)_view.layer animateShadowPath:(__bridge CGPathRef)shadowPath];
}

-(CGPathRef)shadowPath {
    return _view.layer.shadowPath;
}

-(void)setShadowRadius:(CGFloat)shadowRadius {
    if(self.animationDelay == 0) [self _setShadowRadius:@(shadowRadius)];
    [self performSelector:@selector(_setShadowRadius:) withObject:@(shadowRadius) afterDelay:self.animationDelay];
}

-(void)_setShadowRadius:(NSNumber *)shadowRadius {
    if(self.animationDuration == 0.0f) _view.layer.shadowRadius = [shadowRadius floatValue];
    else [(id <C4LayerAnimation>)_view.layer animateShadowRadius:[shadowRadius floatValue]];
}

-(CGFloat)shadowRadius {
    return _view.layer.shadowRadius;
}

#pragma mark Border
-(void)setBorderColor:(UIColor *)borderColor {
    if(self.animationDuration == 0.0f) _view.layer.borderColor = borderColor.CGColor;
    else [(id <C4LayerAnimation>)_view.layer animateBorderColor:borderColor.CGColor];
}

-(UIColor *)borderColor {
    return [UIColor colorWithCGColor:_view.layer.borderColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    if(self.animationDuration == 0.0f) _view.layer.borderWidth = borderWidth;
    else [(id <C4LayerAnimation>)_view.layer animateBorderWidth:borderWidth];
}

-(CGFloat)borderWidth {
    return _view.layer.borderWidth;
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    if(self.animationDuration == 0.0f) _view.layer.cornerRadius = cornerRadius;
    else [(id <C4LayerAnimation>)_view.layer animateCornerRadius:cornerRadius];
}

-(CGFloat)cornerRadius {
    return _view.layer.cornerRadius;
}


#pragma mark Templates

+ (C4Template *)defaultTemplate {
    static C4Template* template;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        template = [C4Template templateForClass:self];
    });
    return template;
}

+ (C4Control *)defaultTemplateProxy {
    return [[self defaultTemplate] proxy];
}

+ (C4Template *)template {
    return [C4Template templateForClass:self];
}

- (void)applyTemplate:(C4Template*)template {
    [template applyToTarget:self];
}


#pragma mark -

- (void)renderInContext:(CGContextRef)context {
    [_view.layer renderInContext:context];
}

@end