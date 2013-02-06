//
//  C4Control.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Slider.h"
#import <objc/message.h>

@interface C4Slider()
@property (readwrite, atomic) BOOL shouldAutoreverse;
@property (readwrite, atomic, strong) NSString *longPressMethodName;
@property (readwrite, atomic, strong) NSMutableDictionary *gestureDictionary;
@property (readonly, atomic) NSArray *localStylePropertyNames, *controlStylePropertyNames;
@end

@implementation C4Slider

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        _usesMaxTrackImage = NO;
        _usesMinTrackImage = NO;
        _usesThumbImage = NO;
        
        // FIXME: do we need these lists of names? the setStyle method should be complete enough without it.
        _localStylePropertyNames = @[
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

        [self setupFromDefaults];
    }
    return self;
}

-(void)setupFromDefaults {
    C4Slider *defaultSlider = [C4Slider defaultStyle];
    if (defaultSlider.usesMaxTrackImage) {
        self.maxTrackImage = defaultSlider.maxTrackImage;
        self.maxTrackImageDisabled = defaultSlider.maxTrackImageDisabled;
        self.maxTrackImageHighlighted = defaultSlider.maxTrackImageHighlighted;
        self.maxTrackImageSelected = defaultSlider.maxTrackImageSelected;
    } else {
        self.maximumTrackTintColor = defaultSlider.maximumTrackTintColor;
    }
    if (defaultSlider.usesMinTrackImage) {
        self.minTrackImage = defaultSlider.minTrackImage;
        self.minTrackImageDisabled = defaultSlider.minTrackImageDisabled;
        self.minTrackImageHighlighted = defaultSlider.minTrackImageHighlighted;
        self.minTrackImageSelected = defaultSlider.minTrackImageSelected;
    } else {
        self.minimumTrackTintColor = defaultSlider.minimumTrackTintColor;
    }
    
    if(defaultSlider.usesThumbImage) {
        self.thumbImage = defaultSlider.thumbImage;
        self.thumbImageDisabled = defaultSlider.thumbImageDisabled;
        self.thumbImageHighlighted = defaultSlider.thumbImageHighlighted;
        self.thumbImageSelected = defaultSlider.thumbImageSelected;
    } else {
        self.minimumTrackTintColor = defaultSlider.minimumTrackTintColor;
    }
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

#pragma mark style methods

-(void)setMinimumTrackTintColor:(UIColor *)minimumTrackTintColor {
    _usesMinTrackImage = NO;
    [super setMinimumTrackTintColor:minimumTrackTintColor];
}

-(UIColor *)minimumTrackTintColor {
    return [super minimumTrackTintColor];
}

-(void)setMaximumTrackTintColor:(UIColor *)maximumTrackTintColor {
    _usesMaxTrackImage = NO;
    [super setMaximumTrackTintColor:maximumTrackTintColor];
}

-(UIColor *)maximumTrackTintColor {
    return [super maximumTrackTintColor];
}

-(NSDictionary *)style {
    //mutable local styles
    NSMutableDictionary *localStyle = [[NSMutableDictionary alloc] initWithCapacity:0];
    if(_usesMaxTrackImage) {
        if(self.maxTrackImage != nil) [localStyle setObject:self.maxTrackImage forKey:@"maxTrackImage"];
        if(self.maxTrackImageDisabled != nil) [localStyle setObject:self.maxTrackImageDisabled forKey:@"maxTrackImageDisabled"];
        if(self.maxTrackImageHighlighted != nil) [localStyle setObject:self.maxTrackImageHighlighted forKey:@"maxTrackImageHighlighted"];
        if(self.maxTrackImageSelected != nil) [localStyle setObject:self.maxTrackImageSelected forKey:@"maxTrackImageSelected"];
    } else {
        if(self.maximumTrackTintColor != nil) [localStyle setObject:self.maximumTrackTintColor forKey:@"maximumTrackTintColor"];
    }

    if(_usesMinTrackImage) {
        if(self.minTrackImage != nil) [localStyle setObject:self.minTrackImage forKey:@"minTrackImage"];
        if(self.minTrackImageDisabled != nil) [localStyle setObject:self.minTrackImageDisabled forKey:@"minTrackImageDisabled"];
        if(self.minTrackImageHighlighted != nil) [localStyle setObject:self.minTrackImageHighlighted forKey:@"minTrackImageHighlighted"];
        if(self.minTrackImageSelected != nil) [localStyle setObject:self.minTrackImageSelected forKey:@"minTrackImageSelected"];
    } else {
        if(self.minimumTrackTintColor != nil) [localStyle setObject:self.minimumTrackTintColor forKey:@"minimumTrackTintColor"];
    }

    if(_usesThumbImage) {
        if(self.thumbImage != nil) [localStyle setObject:self.thumbImage forKey:@"thumbImage"];
        if(self.thumbImageDisabled != nil) [localStyle setObject:self.thumbImageDisabled forKey:@"thumbImageDisabled"];
        if(self.thumbImageHighlighted != nil) [localStyle setObject:self.thumbImageHighlighted forKey:@"thumbImageHighlighted"];
        if(self.thumbImageSelected != nil) [localStyle setObject:self.thumbImageSelected forKey:@"thumbImageSelected"];
    } else {
        if(self.thumbTintColor != nil) [localStyle setObject:self.thumbTintColor forKey:@"thumbTintColor"];
    }
    
    NSMutableDictionary *controlStyle = [NSMutableDictionary dictionaryWithDictionary:
                                         @{
                                         @"alpha":@(self.alpha),
                                         @"borderColor":self.borderColor,
                                         @"borderWidth":@(self.borderWidth),
                                         @"cornerRadius":@(self.cornerRadius),
                                         @"masksToBounds":@(self.masksToBounds),
                                         @"shadowOpacity":@(self.shadowOpacity),
                                         @"shadowOffset":[NSValue valueWithCGSize:self.shadowOffset],
                                         @"shadowRadius":@(self.shadowRadius)
                                         }];
    if (self.backgroundColor != nil) [controlStyle setObject:self.backgroundColor forKey:@"backgroundColor"];
    if (self.shadowColor != nil) [controlStyle setObject:self.shadowColor forKey:@"shadowColor"];
    if (self.shadowPath != nil) [controlStyle setObject:(__bridge UIBezierPath *)self.shadowPath forKey:@"shadowPath"];
    else [controlStyle setObject:[NSNull null] forKey:@"shadowPath"];

    NSMutableDictionary *localAndControlStyle = [NSMutableDictionary dictionaryWithDictionary:localStyle];
    [localAndControlStyle addEntriesFromDictionary:controlStyle];
    
    localStyle = nil;
    controlStyle = nil;
    
    return (NSDictionary *)localAndControlStyle;
}

-(SEL)setterSelectorFromPropertyName:(NSString *)propertyName {
    NSString *firstLetter = [propertyName substringToIndex:1];
    NSRange range = {0,1};
    NSString *capitalizedPropertyName = [propertyName stringByReplacingCharactersInRange:range withString:[firstLetter uppercaseString]];
    NSString *selectorName = [NSString stringWithFormat:@"set%@:",capitalizedPropertyName];
    SEL selector = NSSelectorFromString(selectorName);
    if([self respondsToSelector:selector]) return selector;
    return nil;
}

-(void)setStyle:(NSDictionary *)style {
    // FIXME: These two loops work, but don't differentiate between "types" of objects
    // ... they will NOT, for instance, pull a value out of an NSNumber
    //    for(NSString *propertyName in self.localStylePropertyNames) {
    //        if([styleKeys containsObject:propertyName]) {
    //            SEL selector = [self setterSelectorFromPropertyName:propertyName];
    //            if(selector != nil && [styleKeys containsObject:propertyName]){
    //                objc_msgSend(self,selector,[style objectForKey:propertyName]);
    //            }
    //        }
    //    }
    //
    //    for(NSString *propertyName in self.controlStylePropertyNames) {
    //        if([styleKeys containsObject:propertyName]) {
    //            SEL selector = [self setterSelectorFromPropertyName:propertyName];
    //            if(selector != nil && [styleKeys containsObject:propertyName]){
    //                objc_msgSend(self,selector,[style objectForKey:propertyName]);
    //            }
    //        }
    //    }
 
    NSArray *styleKeys = [style allKeys];
    NSString *key;
    
    // Local Style Values
    key = @"minValueImage";
    if([styleKeys containsObject:key]) self.minValueImage = [style objectForKey:key];
    
    key = @"maxValueImage";
    if([styleKeys containsObject:key]) self.maxValueImage = [style objectForKey:key];
    
    key = @"thumbImage";
    if([styleKeys containsObject:key]) self.thumbImage = [style objectForKey:key];

    key = @"thumbImageDisabled";
    if([styleKeys containsObject:key]) self.thumbImageDisabled = [style objectForKey:key];

    key = @"thumbImageSelected";
    if([styleKeys containsObject:key]) self.thumbImageSelected = [style objectForKey:key];

    key = @"minTrackImage";
    if([styleKeys containsObject:key]) self.minTrackImage = [style objectForKey:key];

    key = @"minTrackImageHighlighted";
    if([styleKeys containsObject:key]) self.minTrackImageHighlighted = [style objectForKey:key];

    key = @"minTrackImageDisabled";
    if([styleKeys containsObject:key]) self.minTrackImageDisabled = [style objectForKey:key];

    key = @"minTrackImageDisabled";
    if([styleKeys containsObject:key]) self.minTrackImageDisabled = [style objectForKey:key];

    key = @"minTrackImageSelected";
    if([styleKeys containsObject:key]) self.minTrackImageSelected = [style objectForKey:key];

    key = @"maxTrackImage";
    if([styleKeys containsObject:key]) self.maxTrackImage = [style objectForKey:key];

    key = @"maxTrackImageHighlighted";
    if([styleKeys containsObject:key]) self.maxTrackImageHighlighted = [style objectForKey:key];

    key = @"maxTrackImageDisabled";
    if([styleKeys containsObject:key]) self.maxTrackImageDisabled = [style objectForKey:key];

    key = @"maxTrackImageSelected";
    if([styleKeys containsObject:key]) self.maxTrackImageSelected = [style objectForKey:key];

    key = @"minimumTrackTintColor";
    if([styleKeys containsObject:key]) self.minimumTrackTintColor = [style objectForKey:key];

    key = @"maximumTrackTintColor";
    if([styleKeys containsObject:key]) self.maximumTrackTintColor = [style objectForKey:key];

    key = @"thumbTintColor";
    if([styleKeys containsObject:key]) self.thumbTintColor = [style objectForKey:key];

    //Control Style Values
    key = @"alpha";
    if([styleKeys containsObject:key]) self.alpha = [[style objectForKey:key] floatValue];
    
    key = @"backgroundColor";
    if([styleKeys containsObject:key]) self.backgroundColor = [style objectForKey:key];

    key = @"borderColor";
    if([styleKeys containsObject:key]) self.borderColor = [style objectForKey:key];
    
    key = @"borderWidth";
    if([styleKeys containsObject:key]) self.borderWidth = [[style objectForKey:key] floatValue];
    
    key = @"cornerRadius";
    if([styleKeys containsObject:key]) self.cornerRadius = [[style objectForKey:key] floatValue];
    
    key = @"masksToBounds";
    if([styleKeys containsObject:key]) self.masksToBounds = [[style objectForKey:key] boolValue];
    
    key = @"shadowColor";
    if([styleKeys containsObject:key]) self.shadowColor = [style objectForKey:key];
    
    key = @"shadowOpacity";
    if([styleKeys containsObject:key]) self.shadowOpacity = [[style objectForKey:key] floatValue];
    
    key = @"shadowOffset";
    if([styleKeys containsObject:key]) self.shadowOffset = [[style objectForKey:key] CGSizeValue];
    
    key = @"shadowPath";
    if([styleKeys containsObject:key]) self.shadowPath = [style objectForKey:key] == [NSNull null] ? nil : (__bridge CGPathRef)[style objectForKey:key];
    
    key = @"shadowRadius";
    if([styleKeys containsObject:key]) self.shadowRadius = [[style objectForKey:key] floatValue];
    
    

//Control
//    for(NSString *key in [style allKeys]) {
//        if([_stylePropertyNames containsObject:key]) {
//            if (key == @"minValueImage") {
//                self.minValueImage = [style objectForKey:key];
//            } else if (key == @"maxValueImage") {
//                self.maxValueImage = [style objectForKey:key];
//            } else if (key == @"thumbImage") {
//                self.thumbImage = [style objectForKey:key];
//            } else if (key == @"thumbImageDisabled") {
//                self.thumbImageDisabled = [style objectForKey:key];
//            } else if (key == @"thumbImageHighlighted") {
//                self.thumbImageHighlighted = [style objectForKey:key];
//            } else if (key == @"thumbImageSelected") {
//                self.thumbImageSelected = [style objectForKey:key];
//            } else if (key == @"minTrackImage") {
//                self.minTrackImage = [style objectForKey:key];
//            } else if (key == @"minTrackImageHighlighted") {
//                self.minTrackImageHighlighted = [style objectForKey:key];
//            } else if (key == @"minTrackImageDisabled") {
//                self.minTrackImageDisabled = [style objectForKey:key];
//            } else if (key == @"minTrackImageSelected") {
//                self.minTrackImageSelected = [style objectForKey:key];
//            } else if (key == @"maxTrackImage") {
//                self.maxTrackImage = [style objectForKey:key];
//            } else if (key == @"maxTrackImageHighlighted") {
//                self.maxTrackImageHighlighted = [style objectForKey:key];
//            } else if (key == @"maxTrackImageDisabled") {
//                self.maxTrackImageDisabled = [style objectForKey:key];
//            } else if (key == @"maxTrackImageSelected") {
//                self.maxTrackImageSelected = [style objectForKey:key];
//            }
//            
//            if(key == @"minimumTrackTintColor") {
//                self.minimumTrackTintColor = [style objectForKey:key];
//            } else if (key == @"maximumTrackTintColor") {
//                self.maximumTrackTintColor = [style objectForKey:key];
//            } else if (key == @"thumbTintColor") {
//                self.thumbTintColor = [style objectForKey:key];
//            }
//        }
//    }
    
//    for(NSString *_key in [style allKeys]) {
//        if([_controlStylePropertyNames containsObject:_key]) {
//            if(_key == @"alpha") {
//                self.alpha = [[style valueForKey:_key] floatValue];
//            } else if (_key == @"backgroundColor") {
//                self.backgroundColor = [style objectForKey:_key];
//            } else if (_key == @"borderColor") {
//                self.borderColor = [style objectForKey:_key];
//            } else if (_key == @"borderWidth") {
//                self.borderWidth = [[style valueForKey:_key] floatValue];
//            } else if(_key == @"cornerRadius") {
//                self.cornerRadius = [[style valueForKey:_key] floatValue];
//            } else if(_key == @"masksToBounds") {
//                self.masksToBounds = [[style valueForKey:_key] boolValue];
//            } else if(_key == @"shadowColor") {
//                self.shadowColor = [style objectForKey:_key];
//            } else if(_key == @"shadowOpacity") {
//                self.shadowOpacity = [[style valueForKey:_key] floatValue];
//            } else if(_key == @"shadowOffset") {
//                self.shadowOffset = [[style valueForKey:_key] CGSizeValue];
//            } else if(_key == @"shadowPath") {
//                self.shadowPath = [style objectForKey:_key] == [NSNull null] ? nil : (__bridge CGPathRef)[style objectForKey:_key];
//            } else if(_key == @"shadowRadius") {
//                self.shadowRadius = [[style valueForKey:_key] floatValue];
//            }
//        }
//    }
}

+(C4Slider *)defaultStyle {
    return (C4Slider *)[C4Slider appearance];
}

-(C4Slider *)copyWithZone:(NSZone *)zone {
    C4Slider *slider = [[C4Slider allocWithZone:zone] initWithFrame:self.frame];
    slider.style = self.style;
    return slider;
}

-(C4Image *)minValueImage {
    return self.minimumValueImage == nil ? nil : [C4Image imageWithUIImage:self.minimumValueImage];
}

-(void)setMinValueImage:(C4Image *)minValueImage {
    if(minValueImage == (C4Image *)[NSNull null]) self.minValueImage = nil;
    else self.minimumValueImage = minValueImage.UIImage;
}

-(C4Image *)maxValueImage {
    return self.maximumValueImage == nil ? nil : [C4Image imageWithUIImage:self.maximumValueImage];
}

-(void)setMaxValueImage:(C4Image *)maxValueImage {
    self.maximumValueImage = maxValueImage.UIImage;
}

-(void)setThumbTintColor:(UIColor *)thumbTintColor {
    _usesThumbImage = NO;
    self.thumbImage = nil;
    self.thumbImageDisabled = nil;
    self.thumbImageHighlighted = nil;
    self.thumbImageSelected = nil;
    [super setThumbTintColor:thumbTintColor];
}

-(C4Image *)thumbImage {
    UIImage *image = [super thumbImageForState:UIControlStateNormal];
    return [C4Image imageWithUIImage:image];
}

-(void)setThumbImage:(C4Image *)image {
    _usesThumbImage = YES;
    [super setThumbImage:image.UIImage forState:UIControlStateNormal];
}

-(C4Image *)thumbImageHighlighted {
    UIImage *image = [super thumbImageForState:UIControlStateHighlighted];
    return [C4Image imageWithUIImage:image];
}

-(void)setThumbImageHighlighted:(C4Image *)image {
    _usesThumbImage = YES;
    [super setThumbImage:image.UIImage forState:UIControlStateHighlighted];
}

-(C4Image *)thumbImageDisabled {
    UIImage *image = [super thumbImageForState:UIControlStateDisabled];
    return [C4Image imageWithUIImage:image];
}

-(void)setThumbImageDisabled:(C4Image *)image {
    _usesThumbImage = YES;
    [super setThumbImage:image.UIImage forState:UIControlStateDisabled];
}

-(C4Image *)thumbImageSelected {
    UIImage *image = [super thumbImageForState:UIControlStateSelected];
    return [C4Image imageWithUIImage:image];
}
-(void)setThumbImageSelected:(C4Image *)image {
    _usesThumbImage = YES;
    [super setThumbImage:image.UIImage forState:UIControlStateHighlighted];
}

-(C4Image *)minTrackImage {
    UIImage *image = [super minimumTrackImageForState:UIControlStateNormal];
    return [C4Image imageWithUIImage:image];
}
-(void)setMinTrackImage:(C4Image *)image {
    _usesMinTrackImage = YES;
    [super setMinimumTrackImage:image.UIImage forState:UIControlStateNormal];
}

-(C4Image *)minTrackImageHighlighted {
    UIImage *image = [super minimumTrackImageForState:UIControlStateHighlighted];
    return [C4Image imageWithUIImage:image];
}
-(void)setMinTrackImageHighlighted:(C4Image *)image {
    _usesMinTrackImage = YES;
    [super setMinimumTrackImage:image.UIImage forState:UIControlStateHighlighted];
}

-(C4Image *)minTrackImageDisabled {
    UIImage *image = [super minimumTrackImageForState:UIControlStateDisabled];
    return [C4Image imageWithUIImage:image];
}
-(void)setMinTrackImageDisabled:(C4Image *)image {
    _usesMinTrackImage = YES;
    [super setMinimumTrackImage:image.UIImage forState:UIControlStateDisabled];
}

-(C4Image *)minTrackImageSelected {
    UIImage *image = [super minimumTrackImageForState:UIControlStateSelected];
    return [C4Image imageWithUIImage:image];
}

-(void)setMinTrackImageSelected:(C4Image *)image {
    _usesMinTrackImage = YES;
    [super setMinimumTrackImage:image.UIImage forState:UIControlStateSelected];
}

-(C4Image *)maxTrackImage {
    UIImage *image = [super maximumTrackImageForState:UIControlStateNormal];
    return [C4Image imageWithUIImage:image];
}
-(void)setMaxTrackImage:(C4Image *)image {
    _usesMaxTrackImage = YES;
    [super setMaximumTrackImage:image.UIImage forState:UIControlStateNormal];
}

-(C4Image *)maxTrackImageHighlighted {
    _usesMaxTrackImage = YES;
    UIImage *image = [super maximumTrackImageForState:UIControlStateHighlighted];
    return [C4Image imageWithUIImage:image];
}
-(void)setMaxTrackImageHighlighted:(C4Image *)image {
    _usesMaxTrackImage = YES;
    [super setMaximumTrackImage:image.UIImage forState:UIControlStateHighlighted];
}

-(C4Image *)maxTrackImageDisabled {
    UIImage *image = [super maximumTrackImageForState:UIControlStateDisabled];
    return [C4Image imageWithUIImage:image];
}
-(void)setMaxTrackImageDisabled:(C4Image *)image {
    _usesMaxTrackImage = YES;
//    if(image.UIImage == nil) self.maximumTrackTintColor = [C4Slider defaultStyle].maximumTrackTintColor;
//    else self.minimumTrackTintColor = nil;
    [super setMaximumTrackImage:image.UIImage forState:UIControlStateDisabled];
}

-(C4Image *)maxTrackImageSelected {
    UIImage *image = [super maximumTrackImageForState:UIControlStateSelected];
    return [C4Image imageWithUIImage:image];
}
-(void)setMaxTrackImageSelected:(C4Image *)image {
//    if(image.UIImage == nil) self.maximumTrackTintColor = [C4Slider defaultStyle].maximumTrackTintColor;
//    else self.minimumTrackTintColor = nil;
    [super setMaximumTrackImage:image.UIImage forState:UIControlStateSelected];
}

#pragma mark other Control Methods (target:action)
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

+(C4Slider *)slider:(CGRect)rect {
    return [[C4Slider alloc] initWithFrame:rect];
}
@end
