//
//  C4Control.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Slider.h"

@interface C4Slider()
@property (readwrite, atomic) BOOL shouldAutoreverse;
@property (readwrite, atomic, strong) NSString *longPressMethodName;
@property (readwrite, atomic, strong) NSMutableDictionary *gestureDictionary;
@property (readonly, atomic) NSArray *stylePropertyNames, *controlStylePropertyNames;
@end

@implementation C4Slider

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        _stylePropertyNames = @[
        @"minimumTrackTintColor",
        @"maximumTrackTintColor",
        @"minValueImage",
        @"maxValueImage",
        @"thumbImage",
        @"thumbImageHighlighted",
        @"thumbImageDisabled",
        @"thumbImageSelected",
        @"minTrackImage",
        @"minTrackImageHighlighted",
        @"minTrackImageDisabled",
        @"minTrackImageSelected",
        @"maxTrackImage",
        @"maxTrackImageHighlighted",
        @"maxTrackImageDisabled",
        @"maxTrackImageSelected"
        @"thumbTintColor",
        ];
        

        _controlStylePropertyNames = @[
        @"alpha",
        @"backgroundColor",
        @"borderColor",
        @"borderWidth",
        @"cornerRadius",
        @"masksToBounds",
        @"shadowColor",
        @"shadowOpacity",
        @"shadowOffset",
        @"shadowPath",
        @"shadowRadius"
        ];

        self.style = [C4Control defaultStyle].style;
        NSDictionary *defaultStyle = [C4Slider defaultStyle].style;
        self.style = [C4Slider defaultStyle].style;
        C4Log(@"?%@", self.thumbImage == nil ? @"YES" : @"NO");

    }
    return self;
}

/* don't add this ever...
 creates a:
 CoreAnimation: failed to allocate 3145760 bytes
 wait_fences: failed to receive reply: 10004003
 
 -(void)drawRect:(CGRect)rect {
 [self.layer display];
 }
 */

-(void)dealloc {
    [[NSRunLoop mainRunLoop] cancelPerformSelectorsWithTarget:self];
    self.backgroundColor = nil;
    self.longPressMethodName = nil;
    NSEnumerator *enumerator = [self.gestureDictionary keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        UIGestureRecognizer *g = (self.gestureDictionary)[key];
        [g removeTarget:self action:nil];
        [self removeGestureRecognizer:g];
    }
    [self.gestureDictionary removeAllObjects];
    self.gestureDictionary = nil;
}

-(void)setup {}

-(void)test {}

#pragma mark UIView animatable property overrides

//-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    event = event;
//    C4Log(@"%@ %@ %@", NSStringFromSelector(_cmd),self, CGRectContainsPoint(self.layer.frame, point) == YES ? @"YES" : @"NO");
//    return CGRectContainsPoint(self.layer.frame, point);
//}

-(void)setCenter:(CGPoint)center {
    if(self.animationDuration == 0.0f) super.center = center;
    else {
        CGPoint oldCenter = CGPointMake(self.center.x, self.center.y);
        
        void (^animationBlock) (void) = ^ { super.center = center; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.center = oldCenter;}];
            };
        }
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

-(CGPoint)center {
    CGPoint currentCenter = super.center;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if(orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        currentCenter.x = super.center.y;
        currentCenter.y = super.center.x;
    }
    return currentCenter;
}

-(void)setOrigin:(CGPoint)origin {
    _origin = origin;
    CGPoint difference = self.origin;
    difference.x += self.frame.size.width/2.0f;
    difference.y += self.frame.size.height/2.0f;
    self.center = difference;
}

-(void)setFrame:(CGRect)frame {
    if(self.animationDuration == 0.0f) super.frame = frame;
    else {
        CGRect oldFrame = self.frame;
        
        void (^animationBlock) (void) = ^ { super.frame = frame; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.frame = oldFrame;}];
            };
        }
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

-(void)setBounds:(CGRect)bounds {
    if(self.animationDuration == 0.0f) super.bounds = bounds;
    else {
        CGRect oldBounds = self.bounds;
        
        void (^animationBlock) (void) = ^ { super.bounds = bounds; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.bounds = oldBounds;}];
            };
        }
        
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

-(void)setTransform:(CGAffineTransform)transform {
    if(self.animationDuration == 0.0f) super.transform = transform;
    else {
        CGAffineTransform oldTransform = self.transform;
        
        void (^animationBlock) (void) = ^ { super.transform = transform; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.transform = oldTransform;}];
            };
        }
        
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

-(void)setAlpha:(CGFloat)alpha {
    if(self.animationDuration == 0.0f) super.alpha = alpha;
    else {
        CGFloat oldAlpha = self.alpha;
        
        void (^animationBlock) (void) = ^ { super.alpha = alpha; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.alpha = oldAlpha;}];
            };
        }
        
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    if(self.animationDuration == 0.0f) super.backgroundColor = backgroundColor;
    else {
        UIColor *oldBackgroundColor = self.backgroundColor;
        
        void (^animationBlock) (void) = ^ { super.backgroundColor = backgroundColor; };
        void (^completionBlock) (BOOL) = nil;
        
        BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
        if(self.shouldAutoreverse && animationShouldNotRepeat) {
            completionBlock = ^ (BOOL animationIsComplete) {
                if(animationIsComplete){}
                [self autoreverseAnimation:^ { super.backgroundColor = oldBackgroundColor;}];
            };
        }
        
        [self animateWithBlock:animationBlock completion:completionBlock];
    }
}

#pragma mark Position, Rotation, Transform
-(CGFloat)width {
    return self.frame.size.width;
}

-(CGFloat)height {
    return self.bounds.size.height;
}

-(CGFloat)zPosition {
    return self.layer.zPosition;
}

-(void)setZPosition:(CGFloat)zPosition {
    if(self.animationDuration == 0.0f) self.layer.zPosition = zPosition;
    else [(id <C4LayerAnimation>)self.layer animateZPosition:zPosition];
}

-(void)setRotation:(CGFloat)rotation {
    if(self.animationDelay == 0.0f) [self _setRotation:@(rotation)];
    else [self performSelector:@selector(_setRotation:) withObject:@(rotation) afterDelay:self.animationDelay];
}

-(void)_setRotation:(NSNumber *)rotation {
    _rotation = [rotation floatValue];
    if(self.animationDuration == 0.0f) ((C4Layer *)self.layer).rotationAngle = _rotation;
    else [(id <C4LayerAnimation>)self.layer animateRotation:_rotation];
}

-(void)setRotationX:(CGFloat)rotation {
    if(self.animationDelay == 0.0f) [self _setRotationX:@(rotation)];
    else [self performSelector:@selector(_setRotationX:) withObject:@(rotation) afterDelay:self.animationDelay];
}

-(void)_setRotationX:(NSNumber *)rotation {
    _rotationX = [rotation floatValue];
    if(self.animationDuration == 0.0f) ((C4Layer *)self.layer).rotationAngleX = _rotationX;
    else [(id <C4LayerAnimation>)self.layer animateRotationX:_rotationX];
}

-(void)setRotationY:(CGFloat)rotation {
    if(self.animationDelay == 0.0f) [self _setRotationY:@(rotation)];
    else [self performSelector:@selector(_setRotationY:) withObject:@(rotation) afterDelay:self.animationDelay];
}

-(void)_setRotationY:(NSNumber *)rotation {
    _rotationY = [rotation floatValue];
    if(self.animationDuration == 0.0f) ((C4Layer *)self.layer).rotationAngleY = _rotationY;
    else [(id <C4LayerAnimation>)self.layer animateRotationY:_rotationY];
}

-(void)rotationDidFinish:(CGFloat)rotation {
    [super setTransform:CGAffineTransformMakeRotation(rotation)];
}

-(void)setLayerTransform:(CATransform3D)transform {
    _layerTransform = transform;
    if(self.animationDuration == 0.0f) self.layer.transform = _layerTransform;
    else [(id <C4LayerAnimation>)self.layer animateLayerTransform:transform];
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
    _anchorPoint = anchorPoint;
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = anchorPoint;
    super.frame = oldFrame;
}

-(void)setPerspectiveDistance:(CGFloat)distance {
    _perspectiveDistance = distance;
    [(id <C4LayerAnimation>)self.layer setPerspectiveDistance:distance];
}

#pragma mark Animation methods
-(void)animateWithBlock:(void (^)(void))animationBlock {
    [self animateWithBlock:animationBlock completion:nil];
}

-(void)animateWithBlock:(void (^)(void))animationBlock completion:(void (^)(BOOL))completionBlock {
    C4AnimationOptions autoReverseOptions = self.animationOptions;
    //we insert the autoreverse options here, only if it should repeat and autoreverse
    if(self.shouldAutoreverse && (self.animationOptions & REPEAT) == REPEAT) autoReverseOptions |= AUTOREVERSE;
    
    [UIView animateWithDuration:self.animationDuration
                          delay:(NSTimeInterval)self.animationDelay
                        options:(UIViewAnimationOptions)autoReverseOptions
                     animations:animationBlock
                     completion:completionBlock];
}

-(void)autoreverseAnimation:(void (^)(void))animationBlock {
    C4AnimationOptions autoreverseOptions = BEGINCURRENT;
    if((self.animationOptions & LINEAR) == LINEAR) autoreverseOptions |= LINEAR;
    else if((self.animationOptions & EASEIN) == EASEIN) autoreverseOptions |= EASEOUT;
    else if((self.animationOptions & EASEOUT) == EASEOUT) autoreverseOptions |= EASEIN;
    
    [UIView animateWithDuration:self.animationDuration
                          delay:0
                        options:(UIViewAnimationOptions)autoreverseOptions
                     animations:animationBlock
                     completion:nil];
}

-(void)setAnimationDuration:(CGFloat)duration {
    //    if (duration <= 0.0f) duration = 0.0001f;
    _animationDuration = duration;
    ((id <C4LayerAnimation>)self.layer).animationDuration = duration;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    /*
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    ((id <C4LayerAnimation>)self.layer).animationOptions = animationOptions;
    
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    
    _animationOptions = animationOptions | BEGINCURRENT;
}

#pragma mark Move
-(void)move:(id)sender {
    [self postNotification:@"moved"];
    NSUInteger _ani = self.animationOptions;
    CGFloat _dur = self.animationDuration;
    CGFloat _del = self.animationDelay;
    self.animationDuration = 0;
    self.animationDelay = 0;
    self.animationOptions = DEFAULT;
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer *)sender translationInView:self];
    translatedPoint.x += self.center.x;
    translatedPoint.y += self.center.y;
    self.center = translatedPoint;
    [(UIPanGestureRecognizer *)sender setTranslation:CGPointZero inView:self];
    
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
            default:
                C4Assert(NO,@"The gesture you tried to use is not one of: TAP, PINCH, SWIPERIGHT, SWIPELEFT, SWIPEUP, SWIPEDOWN, ROTATION, PAN, or LONGPRESS");
                break;
        }
        [self addGestureRecognizer:recognizer];
        (self.gestureDictionary)[gestureName] = recognizer;
    }
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
    
    C4Assert([recognizer isKindOfClass:[UITapGestureRecognizer class]],
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
    
    ((UISwipeGestureRecognizer *) recognizer).direction = direction;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self postNotification:@"touchesBegan"];
    [self touchesBegan];
    }

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self postNotification:@"touchesMoved"];
    [self touchesMoved];
    }

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self postNotification:@"touchesEnded"];
    [self touchesEnded];
    }

-(void)touchesBegan {
}

-(void)touchesEnded {
}

-(void)touchesMoved {
}

-(void)swipedRight {
}

-(void)swipedLeft {
}

-(void)swipedUp {
}

-(void)swipedDown {
}

-(void)pressedLong {
}

-(void)pressedLong:(id)sender {
    if(((UIGestureRecognizer *)sender).state == UIGestureRecognizerStateBegan
       && [((UIGestureRecognizer *)sender) isKindOfClass:[UILongPressGestureRecognizer class]])
        [self runMethod:self.longPressMethodName withObject:sender afterDelay:0.0f];
}

#pragma mark Notification Methods
-(void)listenFor:(NSString *)notification andRunMethod:(NSString *)methodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:nil];
}

-(void)listenFor:(NSString *)notification fromObject:(id)object andRunMethod:(NSString *)methodName {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
}

-(void)listenFor:(NSString *)notification fromObjects:(NSArray *)objectArray andRunMethod:(NSString *)methodName {
    for (id object in objectArray) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:NSSelectorFromString(methodName) name:notification object:object];
    }
}

-(void)stopListeningFor:(NSString *)methodName {
    [self stopListeningFor:methodName object:nil];
}

-(void)stopListeningFor:(NSString *)methodName object:(id)object {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
}

-(void)stopListeningFor:(NSString *)methodName objects:(NSArray *)objectArray {
    for(id object in objectArray) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:methodName object:object];
    }
}

-(void)postNotification:(NSString *)notification {
	[[NSNotificationCenter defaultCenter] postNotificationName:notification object:self];
}

#pragma mark C4AddSubview
-(void)addCamera:(C4Camera *)camera {
    C4Assert([camera isKindOfClass:[C4Camera class]],
             @"You tried to add a %@ using [canvas addShape:]", [camera class]);
    [super addSubview:camera];
}

-(void)addShape:(C4Shape *)shape {
    C4Assert([shape isKindOfClass:[C4Shape class]],
             @"You tried to add a %@ using [canvas addShape:]", [shape class]);
    [super addSubview:shape];
}

-(void)addSubview:(UIView *)subview {
    C4Assert(![[subview class] isKindOfClass:[C4Camera class]], @"You just tried to add a C4Camera using the addSubview: method, please use addCamera:");
    C4Assert(![[subview class] isKindOfClass:[C4Shape class]], @"You just tried to add a C4Shape using the addSubview: method, please use addShape:");
    C4Assert(![[subview class] isKindOfClass:[C4Movie class]], @"You just tried to add a C4Movie using the addSubview: method, please use addMovie:");
    C4Assert(![[subview class] isKindOfClass:[C4Image class]], @"You just tried to add a C4Image using the addSubview: method, please use addImage:");
    C4Assert(![[subview class] isKindOfClass:[C4GL class]], @"You just tried to add a C4GL using the addSubview: method, please use addGL:");
    C4Assert(![[subview class] isKindOfClass:[C4Label class]], @"You just tried to add a C4Label using the addSubview: method, please use addLabel:");
    [super addSubview:subview];
}

-(void)addLabel:(C4Label *)label {
    C4Assert([label isKindOfClass:[C4Label class]],
             @"You tried to add a %@ using [canvas addLabel:]", [label class]);
    [super addSubview:label];
}

-(void)addGL:(C4GL *)gl {
    C4Assert([gl isKindOfClass:[C4GL class]],
             @"You tried to add a %@ using [canvas addGL:]", [gl class]);
    [super addSubview:gl];
}

-(void)addImage:(C4Image *)image {
    C4Assert([image isKindOfClass:[C4Image class]],
             @"You tried to add a %@ using [canvas addImage:]", [image class]);
    [super addSubview:image];
}

-(void)addMovie:(C4Movie *)movie {
    C4Assert([movie isKindOfClass:[C4Movie class]],
             @"You tried to add a %@ using [canvas addMovie:]", [movie class]);
    [super addSubview:movie];
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
    self.layer.mask = maskObject.layer;
}

-(void)setMasksToBounds:(BOOL)masksToBounds {
    self.layer.masksToBounds = masksToBounds;
}

-(BOOL)masksToBounds {
    return self.layer.masksToBounds;
}

#pragma mark Shadow
-(void)setShadowColor:(UIColor *)shadowColor {
    if(self.animationDelay == 0) [self _setShadowColor:shadowColor];
    else [self performSelector:@selector(_setShadowColor:) withObject:shadowColor afterDelay:self.animationDelay];
}

-(void)_setShadowColor:(UIColor *)shadowColor {
    if(self.animationDuration == 0.0f) self.layer.shadowColor = shadowColor.CGColor;
    else [(id <C4LayerAnimation>)self.layer animateShadowColor:shadowColor.CGColor];
}

-(UIColor *)shadowColor {
    return [UIColor colorWithCGColor:self.layer.shadowColor];
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    if(self.animationDelay == 0) [self _setShadowOffSet:[NSValue valueWithCGSize:shadowOffset]];
    else [self performSelector:@selector(_setShadowOffSet:) withObject:[NSValue valueWithCGSize:shadowOffset] afterDelay:self.animationDelay];
}

-(void)_setShadowOffSet:(NSValue *)shadowOffset {
    if(self.animationDuration == 0.0f) self.layer.shadowOffset = [shadowOffset CGSizeValue];
    else [(id <C4LayerAnimation>)self.layer animateShadowOffset:[shadowOffset CGSizeValue]];
}

-(CGSize)shadowOffset {
    return self.layer.shadowOffset;
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    if(self.animationDelay == 0) [self _setShadowOpacity:@(shadowOpacity)];
    else [self performSelector:@selector(_setShadowOpacity:) withObject:@(shadowOpacity) afterDelay:self.animationDelay];
}

-(void)_setShadowOpacity:(NSNumber *)shadowOpacity {
    if(self.animationDuration == 0.0f) self.layer.shadowOpacity = [shadowOpacity floatValue];
    else [(id <C4LayerAnimation>)self.layer animateShadowOpacity:[shadowOpacity floatValue]];
}

-(CGFloat)shadowOpacity {
    return self.layer.shadowOpacity;
}

-(void)setShadowPath:(CGPathRef)shadowPath {
    if(self.animationDelay == 0) [self _setShadowPath:(__bridge id)shadowPath];
    else [self performSelector:@selector(_setShadowPath:) withObject:(__bridge id)shadowPath afterDelay:self.animationDelay];
}

-(void)_setShadowPath:(id)shadowPath {
    if(self.animationDuration == 0.0f) self.layer.shadowPath = (__bridge CGPathRef)shadowPath;
    else [(id <C4LayerAnimation>)self.layer animateShadowPath:(__bridge CGPathRef)shadowPath];
}

-(CGPathRef)shadowPath {
    return self.layer.shadowPath;
}

-(void)setShadowRadius:(CGFloat)shadowRadius {
    if(self.animationDelay == 0) [self _setShadowRadius:@(shadowRadius)];
    [self performSelector:@selector(_setShadowRadius:) withObject:@(shadowRadius) afterDelay:self.animationDelay];
}

-(void)_setShadowRadius:(NSNumber *)shadowRadius {
    if(self.animationDuration == 0.0f) self.layer.shadowRadius = [shadowRadius floatValue];
    else [(id <C4LayerAnimation>)self.layer animateShadowRadius:[shadowRadius floatValue]];
}

-(CGFloat)shadowRadius {
    return self.layer.shadowRadius;
}

#pragma mark Border
-(void)setBorderColor:(UIColor *)borderColor {
    if(self.animationDuration == 0.0f) self.layer.borderColor = borderColor.CGColor;
    else [(id <C4LayerAnimation>)self.layer animateBorderColor:borderColor.CGColor];
}

-(UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderWidth:(CGFloat)borderWidth {
    if(self.animationDuration == 0.0f) self.layer.borderWidth = borderWidth;
    else [(id <C4LayerAnimation>)self.layer animateBorderWidth:borderWidth];
}

-(CGFloat)borderWidth {
    return self.layer.borderWidth;
}

-(void)setCornerRadius:(CGFloat)cornerRadius {
    if(self.animationDuration == 0.0f) self.layer.cornerRadius = cornerRadius;
    else [(id <C4LayerAnimation>)self.layer animateCornerRadius:cornerRadius];
}

-(CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

#pragma mark Basic Methods
+(Class)layerClass {
    return [C4Layer class];
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

-(NSDictionary *)style {
    NSDictionary *localStyle = @{
    @"minimumTrackTintColor": self.minimumTrackTintColor == nil ? [NSNull null] : self.minimumTrackTintColor,
    @"maximumTrackTintColor": self.maximumTrackTintColor == nil ? [NSNull null] : self.maximumTrackTintColor,
    @"minValueImage": self.minValueImage == nil ? [NSNull null] : self.minValueImage,
    @"maxValueImage": self.maxValueImage == nil ? [NSNull null] : self.maxValueImage,
    @"thumbImage": self.thumbImage == nil ? [NSNull null] : self.thumbImage,
    @"thumbImageHighlighted": self.thumbImageHighlighted == nil ? [NSNull null] : self.thumbImageHighlighted,
    @"thumbImageDisabled": self.thumbImageDisabled == nil ? [NSNull null] : self.thumbImageDisabled,
    @"thumbImageSelected": self.thumbImageSelected == nil ? [NSNull null] : self.thumbImageSelected,
    @"minTrackImage": self.minTrackImage == nil ? [NSNull null] : self.minTrackImage,
    @"minTrackImageHighlighted": self.minTrackImageHighlighted == nil ? [NSNull null] : self.minTrackImageHighlighted,
    @"minTrackImageDisabled": self.minTrackImageDisabled == nil ? [NSNull null] : self.minTrackImageDisabled,
    @"minTrackImageSelected": self.minTrackImageSelected == nil ? [NSNull null] : self.minTrackImageSelected,
    @"maxTrackImage": self.maxTrackImage == nil ? [NSNull null] : self.maxTrackImage,
    @"maxTrackImageHighlighted": self.maxTrackImageHighlighted == nil ? [NSNull null] : self.maxTrackImageHighlighted,
    @"maxTrackImageDisabled": self.maxTrackImageDisabled == nil ? [NSNull null] : self.maxTrackImageDisabled,
    @"maxTrackImageSelected": self.maxTrackImageSelected == nil ? [NSNull null] : self.maxTrackImageSelected,
    @"thumbTintColor": self.thumbTintColor == nil ? [NSNull null] : self.thumbTintColor
    };
    
    NSDictionary *localControlStyle = @{
    @"alpha":@(self.alpha),
    @"backgroundColor":self.backgroundColor == nil ? [NSNull null] : self.backgroundColor,
    @"borderColor":self.borderColor == nil ? [NSNull null] : self.borderColor,
    @"borderWidth":@(self.borderWidth),
    @"cornerRadius":@(self.cornerRadius),
    @"masksToBounds":@(self.masksToBounds),
    @"shadowColor":self.shadowColor == nil ? [NSNull null] : self.shadowColor,
    @"shadowOpacity":@(self.shadowOpacity),
    @"shadowOffset":[NSValue valueWithCGSize:self.shadowOffset],
    @"shadowPath": self.shadowPath == nil ? [NSNull null] : (__bridge UIBezierPath *)self.shadowPath,
    @"shadowRadius":@(self.shadowRadius)
    };
    
    NSMutableDictionary *localAndControlStyle = [NSMutableDictionary dictionaryWithDictionary:localStyle];
    [localAndControlStyle addEntriesFromDictionary:localControlStyle];
    
    localStyle = nil;
    localControlStyle = nil;
    C4Log(@"%@", self.thumbImage == nil ? @"YES" : @"NO");

    return (NSDictionary *)localAndControlStyle;
}

-(void)setStyle:(NSDictionary *)style {
    for(NSString *key in [style allKeys]) {
        if([_stylePropertyNames containsObject:key]) {
            NSObject *object = [style objectForKey:key];
            if(key == @"minimumTrackTintColor") {
                self.minimumTrackTintColor = object == [NSNull null] ? nil : (UIColor *)object;
            } else if (key == @"maximumTrackTintColor") {
                self.maximumTrackTintColor = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"minValueImage") {
                self.minValueImage = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"maxValueImage") {
                self.maxValueImage = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"thumbImage") {
                self.thumbImage = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"thumbImageDisabled") {
                self.thumbImageDisabled = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"thumbImageHighlighted") {
                self.thumbImageHighlighted = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"thumbImageSelected") {
                self.thumbImageSelected = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"minTrackImage") {
                self.minTrackImage = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"minTrackImageHighlighted") {
                self.minTrackImageHighlighted = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"minTrackImageDisabled") {
                self.minTrackImageDisabled = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"minTrackImageSelected") {
                self.minTrackImageSelected = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"maxTrackImage") {
                self.maxTrackImage = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"maxTrackImageHighlighted") {
                self.maxTrackImageHighlighted = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"maxTrackImageDisabled") {
                self.maxTrackImageDisabled = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if (key == @"maxTrackImageSelected") {
                self.maxTrackImageSelected = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if ([key isEqualToString:@"thumbTintColor"]) {
                self.thumbTintColor = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            }
        }
    }
    
    for(NSString *key in [style allKeys]) {
        if([_controlStylePropertyNames containsObject:key]) {
            if([key isEqualToString:@"alpha"]) {
                self.alpha = [[style valueForKey:key] floatValue];
            } else if ([key isEqualToString:@"backgroundColor"]) {
                self.backgroundColor = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if ([key isEqualToString:@"borderColor"]) {
                self.borderColor = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if ([key isEqualToString:@"borderWidth"]) {
                self.borderWidth = [[style valueForKey:key] floatValue];
            } else if([key isEqualToString:@"cornerRadius"]) {
                self.cornerRadius = [[style valueForKey:key] floatValue];
            } else if([key isEqualToString:@"masksToBounds"]) {
                self.masksToBounds = [[style valueForKey:key] boolValue];
            } else if([key isEqualToString:@"shadowColor"]) {
                self.shadowColor = [style objectForKey:key] == [NSNull null] ? nil : [style objectForKey:key];
            } else if([key isEqualToString:@"shadowOpacity"]) {
                self.shadowOpacity = [[style valueForKey:key] floatValue];
            } else if([key isEqualToString:@"shadowOffset"]) {
                self.shadowOffset = [[style valueForKey:key] CGSizeValue];
            } else if([key isEqualToString:@"shadowPath"]) {
                self.shadowPath = [style objectForKey:key] == [NSNull null] ? nil : (__bridge CGPathRef)[style objectForKey:key];
            } else if([key isEqualToString:@"shadowRadius"]) {
                self.shadowRadius = [[style valueForKey:key] floatValue];
            }
        }
    }
}

+(C4Slider *)defaultStyle {
    return (C4Slider *)[C4Slider appearance];
}

-(C4Slider *)copyWithZone:(NSZone *)zone {
    C4Slider *slider = [[C4Slider allocWithZone:zone] initWithFrame:self.frame];
    slider.style = self.style;
    return slider;
}

/* 
 NOTE: THERE SHOULD BE A [C4Image imageWithUIImage:(UIImage *)image];
 */
-(C4Image *)minValueImage {
    return self.minimumValueImage == nil ? nil : [[C4Image alloc] initWithUIImage:self.minimumValueImage];
}
-(void)setMinValueImage:(C4Image *)minValueImage {
    self.minimumValueImage = minValueImage.UIImage;
}

-(C4Image *)maxValueImage {
    return self.maximumValueImage == nil ? nil : [[C4Image alloc] initWithUIImage:self.maximumValueImage];
}

-(void)setMaxValueImage:(C4Image *)maxValueImage {
    self.maximumValueImage = maxValueImage.UIImage;
}

-(C4Image *)thumbImage {
    return [self thumbImageForState:UIControlStateNormal] == nil ? nil : [[C4Image alloc] initWithUIImage:[self thumbImageForState:UIControlStateNormal]];
}

-(void)setThumbImage:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) {
        if(self.thumbTintColor != nil) self.thumbTintColor = [C4Slider defaultStyle].thumbTintColor;
        [super setThumbImage:nil forState:UIControlStateNormal];
    } else {
        self.thumbTintColor = nil;
        [super setThumbImage:image.UIImage forState:UIControlStateNormal];
    }
}

-(C4Image *)thumbImageHighlighted {
    return [self thumbImageForState:UIControlStateHighlighted] == nil ? nil : [[C4Image alloc] initWithUIImage:[self thumbImageForState:UIControlStateHighlighted]];
}

-(void)setThumbImageHighlighted:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) return;
    self.thumbTintColor = nil;
    [super setThumbImage:image.UIImage forState:UIControlStateHighlighted];
}

-(C4Image *)thumbImageDisabled {
    return [self thumbImageForState:UIControlStateDisabled] == nil ? nil : [[C4Image alloc] initWithUIImage:[self thumbImageForState:UIControlStateDisabled]];
}

-(void)setThumbImageDisabled:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) return;
    self.thumbTintColor = nil;
    [super setThumbImage:image.UIImage forState:UIControlStateDisabled];
}

-(C4Image *)thumbImageSelected {
    return [self thumbImageForState:UIControlStateSelected] == nil ? nil : [[C4Image alloc] initWithUIImage:[self thumbImageForState:UIControlStateSelected]];
}
-(void)setThumbImageSelected:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) return;
    self.thumbTintColor = nil;
    [super setThumbImage:image.UIImage forState:UIControlStateHighlighted];
}

-(C4Image *)minTrackImage {
    return [self minimumTrackImageForState:UIControlStateNormal] == nil ? nil : [[C4Image alloc] initWithUIImage:[self minimumTrackImageForState:UIControlStateNormal]];
}
-(void)setMinTrackImage:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) {
        if(self.minimumTrackTintColor != nil) self.minimumTrackTintColor = [C4Slider defaultStyle].minimumTrackTintColor;
        [super setMinimumTrackImage:nil forState:UIControlStateNormal];
    } else {
        self.minimumTrackTintColor = nil;
        [super setMinimumTrackImage:image.UIImage forState:UIControlStateNormal];
    }
}

-(C4Image *)minTrackImageHighlighted {
    return [self minimumTrackImageForState:UIControlStateHighlighted] == nil ? nil : [[C4Image alloc] initWithUIImage:[self minimumTrackImageForState:UIControlStateHighlighted]];
}
-(void)setMinTrackImageHighlighted:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) {
        if(self.minimumTrackTintColor != nil) self.minimumTrackTintColor = [C4Slider defaultStyle].minimumTrackTintColor;
        [super setMinimumTrackImage:nil forState:UIControlStateHighlighted];
    } else {
        self.minimumTrackTintColor = nil;
        [super setMinimumTrackImage:image.UIImage forState:UIControlStateHighlighted];
    }
}

-(C4Image *)minTrackImageDisabled {
    return [self minimumTrackImageForState:UIControlStateDisabled] == nil ? nil : [[C4Image alloc] initWithUIImage:[self minimumTrackImageForState:UIControlStateDisabled]];
}
-(void)setMinTrackImageDisabled:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) {
        if(self.minimumTrackTintColor != nil) self.minimumTrackTintColor = [C4Slider defaultStyle].minimumTrackTintColor;
        [super setMinimumTrackImage:nil forState:UIControlStateDisabled];
    } else {
        self.minimumTrackTintColor = nil;
        [super setMinimumTrackImage:image.UIImage forState:UIControlStateDisabled];
    }
}

-(C4Image *)minTrackImageSelected {
    return [self minimumTrackImageForState:UIControlStateSelected] == nil ? nil : [[C4Image alloc] initWithUIImage:[self minimumTrackImageForState:UIControlStateSelected]];
}

-(void)setMinTrackImageSelected:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) {
        if(self.minimumTrackTintColor != nil) self.minimumTrackTintColor = [C4Slider defaultStyle].minimumTrackTintColor;
        [super setMinimumTrackImage:nil forState:UIControlStateSelected];
    } else {
        self.minimumTrackTintColor = nil;
        [super setMinimumTrackImage:image.UIImage forState:UIControlStateSelected];
    }
}

-(C4Image *)maxTrackImage {
    return [self maximumTrackImageForState:UIControlStateNormal] == nil ? nil : [[C4Image alloc] initWithUIImage:[self minimumTrackImageForState:UIControlStateNormal]];
}
-(void)setMaxTrackImage:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) return;
    self.maximumTrackTintColor = nil;
    [super setMinimumTrackImage:image.UIImage forState:UIControlStateNormal];
}

-(C4Image *)maxTrackImageHighlighted {
    return [self maximumTrackImageForState:UIControlStateHighlighted] == nil ? nil : [[C4Image alloc] initWithUIImage:[self minimumTrackImageForState:UIControlStateHighlighted]];
}
-(void)setMaxTrackImageHighlighted:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) return;
    self.maximumTrackTintColor = nil;
    [super setMinimumTrackImage:image.UIImage forState:UIControlStateHighlighted];
}

-(C4Image *)maxTrackImageDisabled {
    return [self maximumTrackImageForState:UIControlStateDisabled] == nil ? nil : [[C4Image alloc] initWithUIImage:[self minimumTrackImageForState:UIControlStateDisabled]];
}
-(void)setMaxTrackImageDisabled:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) return;
    self.maximumTrackTintColor = nil;
    [super setMinimumTrackImage:image.UIImage forState:UIControlStateDisabled];
}

-(C4Image *)maxTrackImageSelected {
    return [self maximumTrackImageForState:UIControlStateSelected] == nil ? nil : [[C4Image alloc] initWithUIImage:[self minimumTrackImageForState:UIControlStateSelected]];
}
-(void)setMaxTrackImageSelected:(C4Image *)image {
    if(image == (id)[NSNull null] || image == nil) return;
    self.maximumTrackTintColor = nil;
    [super setMinimumTrackImage:image.UIImage forState:UIControlStateSelected];
}

-(void)runMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [super addTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

-(void)stopRunningMethod:(NSString *)methodName target:(id)object forEvent:(C4ControlEvents)event {
    [super removeTarget:object action:NSSelectorFromString(methodName) forControlEvents:(UIControlEvents)event];
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self postNotification:@"trackingBegan"];
    [self beginTracking];
    return [super beginTrackingWithTouch:touch withEvent:event];
}

-(BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self postNotification:@"trackingContinued"];
    [self continueTracking];
    return [super continueTrackingWithTouch:touch withEvent:event];
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    [self postNotification:@"trackingEnded"];
    [self endTracking];
    return [super endTrackingWithTouch:touch withEvent:event];
}

-(void)cancelTrackingWithEvent:(UIEvent *)event {
    [self postNotification:@"trackingCancelled"];
    [self cancelTracking];
    [super cancelTrackingWithEvent:event];
}

-(void)beginTracking {
}

-(void)continueTracking {
}

-(void)endTracking {
}

-(void)cancelTracking {
}

@end
