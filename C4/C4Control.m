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

#import "C4AnimationHelper.h"
#import "C4Control.h"

@interface C4Control()
@property(nonatomic, strong) UIView* view;

@property(nonatomic) BOOL shouldAutoreverse;
@property(nonatomic, strong) NSString *longPressMethodName;
@property(nonatomic, strong) NSMutableDictionary *gestureDictionary;
@property(nonatomic) CGPoint firstPositionForMove;

@property(nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property(nonatomic, copy) C4TapGestureBlock tapBlock;

@property(nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic, copy) C4PanGestureBlock panBlock;

@property(nonatomic, strong) UIPinchGestureRecognizer *pinchGestureRecognizer;
@property(nonatomic, copy) C4PinchGestureBlock pinchBlock;

@property(nonatomic, strong) UIRotationGestureRecognizer *rotationGestureRecognizer;
@property(nonatomic, copy) C4RotationGestureBlock rotationBlock;

@property(nonatomic, strong) UILongPressGestureRecognizer *longPressGestureRecognizer;
@property(nonatomic, copy) C4LongPressGestureBlock longPressStartBlock;
@property(nonatomic, copy) C4LongPressGestureBlock longPressEndBlock;

@property(nonatomic, strong) UISwipeGestureRecognizer *swipeRightGestureRecognizer;
@property(nonatomic, copy) C4SwipeGestureBlock swipeRightBlock;

@property(nonatomic, strong) UISwipeGestureRecognizer *swipeLeftGestureRecognizer;
@property(nonatomic, copy) C4SwipeGestureBlock swipeLeftBlock;

@property(nonatomic, strong) UISwipeGestureRecognizer *swipeUpGestureRecognizer;
@property(nonatomic, copy) C4SwipeGestureBlock swipeUpBlock;

@property(nonatomic, strong) UISwipeGestureRecognizer *swipeDownGestureRecognizer;
@property(nonatomic, copy) C4SwipeGestureBlock swipeDownBlock;

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
    
    _animationHelper = [[C4AnimationHelper alloc] initWithLayer:self.view.layer];
    
    C4Template* template = (C4Template*)[[self class] defaultTemplate];
    [template applyToTarget:self];
    
    return self;
}

- (void)dealloc {
    [[NSRunLoop mainRunLoop] cancelPerformSelectorsWithTarget:self];
    
    for (UIGestureRecognizer *g in [self.gestureDictionary allValues]) {
        [g removeTarget:self action:nil];
        [self.view removeGestureRecognizer:g];
    }
}


#pragma mark UIView animatable properties

- (CGRect)frame {
    return self.view.frame;
}

- (void)setFrame:(CGRect)frame {
    if (self.animationDuration == 0.0f) {
        self.view.frame = frame;
        return;
    }
    
    CGRect oldFrame = self.view.frame;
    void (^animationBlock)() = ^() { self.view.frame = frame; };
    void (^reverseBlock)() = ^() { self.view.frame = oldFrame; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (void)setBounds:(CGRect)bounds {
    if (self.animationDuration == 0.0f) {
        self.view.bounds = bounds;
        return;
    }
    
    CGRect oldBounds = self.view.bounds;
    void (^animationBlock)() = ^() { self.view.bounds = bounds; };
    void (^reverseBlock)() = ^() { self.view.bounds = oldBounds; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

-(CGRect)bounds {
    return self.view.bounds;
}

- (CGPoint)center {
    return self.view.center;
}

- (void)setCenter:(CGPoint)center {
    if (self.animationDuration == 0.0f) {
        self.view.center = center;
        return;
    }
    
    CGPoint oldCenter = CGPointMake(self.view.center.x, self.view.center.y);
    void (^animationBlock)() = ^() { self.view.center = center; };
    void (^reverseBlock)() = ^() { self.view.center = oldCenter; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (CGPoint)origin {
    return self.view.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGPoint difference = origin;
    difference.x += self.view.frame.size.width/2.0f;
    difference.y += self.view.frame.size.height/2.0f;
    self.center = difference;
}

- (CGAffineTransform)transform {
    return self.view.transform;
}

- (void)setTransform:(CGAffineTransform)transform {
    if (self.animationDuration == 0.0f) {
        self.view.transform = transform;
        return;
    }
    
    CGAffineTransform oldTransform = self.view.transform;
    void (^animationBlock)() = ^() { self.view.transform = transform; };
    void (^reverseBlock)() = ^() { self.view.transform = oldTransform; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (UIColor*)backgroundColor {
    return self.view.backgroundColor;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    if (self.animationDuration == 0.0f) {
        self.view.backgroundColor = backgroundColor;
        return;
    }
    
    UIColor *oldBackgroundColor = self.view.backgroundColor;
    void (^animationBlock)() = ^() { self.view.backgroundColor = backgroundColor; };
    void (^reverseBlock)() = ^() { self.view.backgroundColor = oldBackgroundColor; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (CGFloat)alpha {
    return self.view.alpha;
}

- (void)setAlpha:(CGFloat)alpha {
    if (self.animationDuration == 0.0f) {
        self.view.alpha = alpha;
        return;
    }
    
    CGFloat oldAlpha = self.view.alpha;
    void (^animationBlock)() = ^() { self.view.alpha = alpha; };
    void (^reverseBlock)() = ^() { self.view.alpha = oldAlpha; };
    [self animateWithBlock:animationBlock reverseBlock:reverseBlock];
}

- (BOOL)isHidden {
    return self.view.isHidden;
}

- (void)setHidden:(BOOL)hidden {
    self.view.hidden = hidden;
}


#pragma mark Position, Rotation, Transform

- (CGFloat)width {
    return self.view.bounds.size.width;
}

- (CGFloat)height {
    return self.view.bounds.size.height;
}

- (CGSize)size {
    return self.view.bounds.size;
}

- (CGFloat)zPosition {
    return self.view.layer.zPosition;
}

- (void)setZPosition:(CGFloat)zPosition {
    [self.animationHelper animateKeyPath:@"zPosition" toValue:@(zPosition)];
}

- (CGFloat)rotation {
    return [[self.view.layer valueForKeyPath:@"transform.rotation.z"] floatValue];
}

- (void)setRotation:(CGFloat)rotation {
    [self.animationHelper animateKeyPath:@"transform.rotation.z" toValue:@(rotation)];
}

- (CGFloat)rotationX {
    return [[self.view.layer valueForKeyPath:@"transform.rotation.x"] floatValue];
}

- (void)setRotationX:(CGFloat)rotation {
    [self.animationHelper animateKeyPath:@"transform.rotation.x" toValue:@(rotation)];
}

- (CGFloat)rotationY {
    return [[self.view.layer valueForKeyPath:@"transform.rotation.y"] floatValue];
}

- (void)setRotationY:(CGFloat)rotation {
    [self.animationHelper animateKeyPath:@"transform.rotation.y" toValue:@(rotation)];
}

- (CATransform3D)layerTransform {
    return self.view.layer.sublayerTransform;
}

- (void)setLayerTransform:(CATransform3D)transform {
    [self.animationHelper animateKeyPath:@"transform" toValue:[NSValue valueWithCATransform3D:transform]];
}

- (CGPoint)anchorPoint {
    return self.view.layer.anchorPoint;
}

- (void)setAnchorPoint:(CGPoint)anchorPoint {
    CGRect oldFrame = self.view.frame;
    self.view.layer.anchorPoint = anchorPoint;
    self.view.frame = oldFrame;
}

- (CGFloat)perspectiveDistance {
    return 1. / self.view.layer.transform.m34;
}

- (void)setPerspectiveDistance:(CGFloat)distance {
    CATransform3D t = self.view.layer.transform;
    if (distance != 0.0f)
        t.m34 = 1. / distance;
    else
        t.m34 = 0.;
    [self setLayerTransform:t];
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

- (CGFloat)animationDuration {
    return self.animationHelper.animationDuration;
}

- (void)setAnimationDuration:(CGFloat)duration {
    self.animationHelper.animationDuration = duration;
}

- (CGFloat)animationDelay {
    return self.animationHelper.animationDelay;
}

- (void)setAnimationDelay:(CGFloat)animationDelay {
    self.animationHelper.animationDelay = animationDelay;
}

- (void)setAnimationOptions:(NSUInteger)animationOptions {
    self.animationHelper.animationOptions = animationOptions;
    
    /*
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    
    _animationOptions = animationOptions | BEGINCURRENT;
}

#pragma mark C4AddSubview

-(void)addSubview:(UIView *)subview {
    C4Assert(![[subview class] isKindOfClass:[C4Control class]], @"You just tried to add a C4Control using the addSubview: method, please use addControl:");
    [self.view addSubview:subview];
}

-(void)addControl:(C4Control *)control {
    [self.view addSubview:control.view];
}

-(void)addObjects:(NSArray *)array {
    for(id obj in array) {
        if([obj isKindOfClass:[C4Control class]]) {
            [self addControl:obj];
        }
        else if([obj isKindOfClass:[UIView class]]) {
            [self addSubview:obj];
        }
        else {
            C4Log(@"unable to determine type of class");
        }
    }
}

-(void)removeObject:(id)visualObject {
    C4Assert(self != visualObject, @"You tried to remove %@ from itself, don't be silly", visualObject);
    if ([visualObject isKindOfClass:[UIView class]])
        [visualObject removeFromSuperview];
    else if ([visualObject isKindOfClass:[C4Control class]])
        [((C4Control*)visualObject).view removeFromSuperview];
    else
        C4Log(@"object (%@) you wish to remove is not a visual object", visualObject);
}

-(void)removeObjects:(NSArray *)array {
    for(id obj in array) {
        [self removeObject:obj];
    }
}

#pragma mark Masking
-(void)setMask:(C4Control *)maskObject {
    self.view.layer.mask = maskObject.view.layer;
}

-(void)setMasksToBounds:(BOOL)masksToBounds {
    self.view.layer.masksToBounds = masksToBounds;
}

-(BOOL)masksToBounds {
    return self.view.layer.masksToBounds;
}


#pragma mark Shadow

- (UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.view.layer.shadowColor];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    [self.animationHelper animateKeyPath:@"shadowColor" toValue:(__bridge id)shadowColor.CGColor];
}

- (CGSize)shadowOffset {
    return self.view.layer.shadowOffset;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    [self.animationHelper animateKeyPath:@"shadowOffset" toValue:[NSValue valueWithCGSize:shadowOffset]];
}

- (CGFloat)shadowOpacity {
    return self.view.layer.shadowOpacity;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self.animationHelper animateKeyPath:@"shadowOpacity" toValue:@(shadowOpacity)];
}

- (CGPathRef)shadowPath {
    return self.view.layer.shadowPath;
}

- (void)setShadowPath:(CGPathRef)shadowPath {
    [self.animationHelper animateKeyPath:@"shadowPath" toValue:(__bridge id)shadowPath];
}

- (CGFloat)shadowRadius {
    return self.view.layer.shadowRadius;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    [self.animationHelper animateKeyPath:@"shadowRadius" toValue:@(shadowRadius)];
}


#pragma mark Border

- (UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.view.layer.borderColor];
}

- (void)setBorderColor:(UIColor *)borderColor {
    [self.animationHelper animateKeyPath:@"borderColor" toValue:(__bridge id)borderColor.CGColor];
}

- (CGFloat)borderWidth {
    return self.view.layer.borderWidth;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self.animationHelper animateKeyPath:@"borderWidth" toValue:@(borderWidth)];
}

- (CGFloat)cornerRadius {
    return self.view.layer.cornerRadius;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self.animationHelper animateKeyPath:@"cornerRadius" toValue:@(cornerRadius)];
}


#pragma mark Gestures

- (void)onTap:(C4TapGestureBlock)block {
    self.tapBlock = block;
    
    if (self.tapBlock && !_tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        [self.view addGestureRecognizer:_tapGestureRecognizer];
    }
}

- (void)tapGesture:(UITapGestureRecognizer *)gr {
    if (self.tapBlock && gr.state == UIGestureRecognizerStateRecognized)
        self.tapBlock([gr locationInView:self.view]);
}

- (void)onPan:(C4PanGestureBlock)block {
    self.panBlock = block;
    
    if (self.panBlock && !_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
        [self.view addGestureRecognizer:_panGestureRecognizer];
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)gr {
    if (self.panBlock && gr.state == UIGestureRecognizerStateChanged)
        self.panBlock([gr locationInView:self.view], [gr translationInView:self.view], [gr velocityInView:self.view]);
}

- (void)onPinch:(C4PinchGestureBlock)block {
    self.pinchBlock = block;
    
    if (self.pinchBlock && !_pinchGestureRecognizer) {
        _pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesture:)];
        [self.view addGestureRecognizer:_pinchGestureRecognizer];
    }
}

- (void)pinchGesture:(UIPinchGestureRecognizer*)gr {
    if (self.pinchBlock && gr.state == UIGestureRecognizerStateChanged)
        self.pinchBlock([gr locationInView:self.view], gr.scale, gr.velocity);
}

- (void)onRotation:(C4RotationGestureBlock)block {
    self.rotationBlock = block;
    
    if (self.rotationBlock && !_rotationGestureRecognizer) {
        _rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationGesture:)];
        [self.view addGestureRecognizer:_rotationGestureRecognizer];
    }
}

- (void)rotationGesture:(UIRotationGestureRecognizer*)gr {
    if (self.rotationBlock && gr.state == UIGestureRecognizerStateChanged)
        self.rotationBlock([gr locationInView:self.view], gr.rotation, gr.velocity);
}

- (void)onLongPressStart:(C4LongPressGestureBlock)block {
    self.longPressStartBlock = block;
    
    if (self.longPressStartBlock && !_longPressGestureRecognizer) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        _longPressGestureRecognizer.minimumPressDuration = 0.25;
        [self.view addGestureRecognizer:_longPressGestureRecognizer];
    }
}

- (void)onLongPressEnd:(C4LongPressGestureBlock)block {
    self.longPressEndBlock = block;
    
    if (self.longPressEndBlock && !_longPressGestureRecognizer) {
        _longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
        [self.view addGestureRecognizer:_longPressGestureRecognizer];
    }
}

- (void)longPressGesture:(UILongPressGestureRecognizer *)gr {
    if (self.longPressStartBlock && gr.state == UIGestureRecognizerStateBegan)
        self.longPressStartBlock([gr locationInView:self.view]);
    else if (self.longPressEndBlock && gr.state == UIGestureRecognizerStateEnded)
        self.longPressEndBlock([gr locationInView:self.view]);
}

- (void)onSwipeRight:(C4SwipeGestureBlock)block {
    self.swipeRightBlock = block;
    
    if (self.swipeRightBlock && !_swipeRightGestureRecognizer) {
        _swipeRightGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        _swipeRightGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:_swipeRightGestureRecognizer];
    }
}

- (void)onSwipeLeft:(C4SwipeGestureBlock)block {
    self.swipeLeftBlock = block;
    
    if (self.swipeLeftBlock && !_swipeLeftGestureRecognizer) {
        _swipeLeftGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        _swipeLeftGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:_swipeLeftGestureRecognizer];
    }
}

- (void)onSwipeUp:(C4SwipeGestureBlock)block {
    self.swipeUpBlock = block;
    
    if (self.swipeUpBlock && !_swipeUpGestureRecognizer) {
        _swipeUpGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        _swipeUpGestureRecognizer.direction = UISwipeGestureRecognizerDirectionUp;
        [self.view addGestureRecognizer:_swipeUpGestureRecognizer];
    }
}

- (void)onSwipeDown:(C4SwipeGestureBlock)block {
    self.swipeDownBlock = block;
    
    if (self.swipeDownBlock && !_swipeDownGestureRecognizer) {
        _swipeDownGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeGesture:)];
        _swipeDownGestureRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [self.view addGestureRecognizer:_swipeDownGestureRecognizer];
    }
}

- (void)swipeGesture:(UISwipeGestureRecognizer *)gr {
    if (self.swipeRightBlock && gr == _swipeRightGestureRecognizer && gr.state == UIGestureRecognizerStateRecognized)
        self.swipeRightBlock([gr locationInView:self.view]);
    else if (self.swipeLeftBlock && gr == _swipeLeftGestureRecognizer && gr.state == UIGestureRecognizerStateRecognized)
        self.swipeLeftBlock([gr locationInView:self.view]);
    else if (self.swipeUpBlock && gr == _swipeUpGestureRecognizer && gr.state == UIGestureRecognizerStateRecognized)
        self.swipeUpBlock([gr locationInView:self.view]);
    else if (self.swipeDownBlock && gr == _swipeDownGestureRecognizer && gr.state == UIGestureRecognizerStateRecognized)
        self.swipeDownBlock([gr locationInView:self.view]);
}

#pragma mark Gesture Additions
- (void)tapped {
    
}

- (void)tapped:(CGPoint)location {
    [self postNotification:@"tapped"];
    [self tapped];
}

- (void)pinched {
    
}

- (void)pinched:(CGPoint)location scale:(CGFloat)scale velocity:(CGFloat)velocity {
    [self postNotification:@"pinched"];
    [self pinched];
}

- (void)panned {
    
}

- (void)panned:(CGPoint)location translation:(CGPoint)translation velocity:(CGPoint)velocity {
    [self panned];
}

- (void)rotated {
    
}

-(void)rotated:(CGPoint)location rotation:(CGFloat)rotation velocity:(CGFloat)velocity {
    [self postNotification:@"rotated"];
    [self rotated];
}

- (void)swipedLeft {
    
}

- (void)swipedLeft:(CGPoint)location {
    [self postNotification:@"swipedLeft"];
    [self swipedLeft];
}

- (void)swipedRight {
    
}

- (void)swipedRight:(CGPoint)location {
    [self postNotification:@"swipedRight"];
    [self swipedRight];
}

- (void)swipedUp {
    
}

- (void)swipedUp:(CGPoint)location {
    [self postNotification:@"swipedUp"];
    [self swipedUp];
}

- (void)swipedDown {
    
}

- (void)swipedDown:(CGPoint)location {
    [self postNotification:@"swipedDown"];
    [self swipedDown];
}

- (void)longPressEnded {
    
}

-(void)longPressEnded:(CGPoint)location {
    [self postNotification:@"longPressEnded"];
    [self longPressEnded];
}

- (void)longPressStarted {
    
}

-(void)longPressStarted:(CGPoint)location {
    [self postNotification:@"longPressStarted"];
    [self longPressStarted];
}

-(void)move:(CGPoint)location {
    NSUInteger _ani = self.animationOptions;
    CGFloat _dur = self.animationDuration;
    CGFloat _del = self.animationDelay;
    self.animationDuration = 0;
    self.animationDelay = 0;
    self.animationOptions = DEFAULT;
    
    CGPoint displacementFromCenter = CGPointMake(location.x - self.width/2 , location.y - self.height / 2);
    self.center = CGPointMake(self.center.x + displacementFromCenter.x, self.center.y + displacementFromCenter.y);

    [self postNotification:@"moved"];
    
    self.animationDelay = _del;
    self.animationDuration = _dur;
    self.animationOptions = _ani;
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

+ (instancetype)defaultTemplateProxy {
    return [[self defaultTemplate] proxy];
}

+ (C4Template *)template {
    return [C4Template templateForClass:self];
}

- (void)applyTemplate:(C4Template*)template {
    [template applyToTarget:self];
}

#pragma mark - Rendering

- (void)renderInContext:(CGContextRef)context {
    [self.view.layer renderInContext:context];
}

#pragma mark - Notifications
- (void)listenFor:(NSString *)notification andRun:(NotificationBlock)block {
    [self listenFor:notification fromObject:nil andRun:block];
}

- (void)listenFor:(NSString *)notification fromObject:(id)object andRun:(NotificationBlock)block {
    [[NSNotificationCenter defaultCenter] addObserverForName:notification object:self queue:nil usingBlock:block];
}

- (void)listenFor:(NSString *)notification fromObjects:(NSArray *)objectArray andRun:(NotificationBlock)block {
    for (id object in objectArray) {
        [[NSNotificationCenter defaultCenter] addObserverForName:notification object:object queue:nil usingBlock:block];
    }
}

- (void)stopListeningFor:(NSString *)methodName {
    [self stopListeningFor:methodName object:nil];
}

- (void)stopListeningFor:(NSString *)methodName object:(id)object {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
}

- (void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {
    for(id object in objectArray) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
    }
}

- (void)postNotification:(NSString *)notification {
    [[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

#pragma mark - MethodDelay

-(void)run:(void (^)())block afterDelay:(CGFloat)seconds {
    NSDictionary *d = @{@"block": block};
    [self performSelector:@selector(executeBlockUsingDictionary:) withObject:d afterDelay:seconds];
}

-(void)executeBlockUsingDictionary:(NSDictionary *)d {
    void (^block)(void) = d[@"block"];
    block();
    d = nil;
}

#pragma mark Other Additions
#pragma mark - Remove from superview

-(void)removeFromSuperview {
    [self.view removeFromSuperview];
}

#pragma mark - new
-(BOOL)userInteractionEnabled {
    return self.view.userInteractionEnabled;
}

-(void)setUserInteractionEnabled:(BOOL)userInteractionEnabled {
    self.view.userInteractionEnabled = userInteractionEnabled;
}
    
@end