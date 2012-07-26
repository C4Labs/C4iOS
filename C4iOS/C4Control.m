//
//  C4Control.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-23.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Control.h"

@interface C4Control() 
-(void)animateWithBlock:(void (^)(void))blockAnimation;
-(void)animateWithBlock:(void (^)(void))blockAnimation completion:(void (^)(BOOL))completionBlock;
-(void)autoreverseAnimation:(void (^)(void))animationBlock;
-(void)pressedLong:(id)sender;
@property (readwrite, atomic) BOOL shouldAutoreverse;
@property (readwrite, atomic, strong) NSString *longPressMethodName;
@property (readwrite, atomic, strong) NSMutableDictionary *gestureDictionary;
@end

@implementation C4Control
@synthesize longPressMethodName;
@synthesize animationDuration = _animationDuration, animationDelay = _animationDelay, animationOptions = _animationOptions, repeatCount = _repeatCount;
@synthesize gestureDictionary = _gestureDictionary;
@synthesize origin = _origin;
@synthesize width, height;
@synthesize mask;
@synthesize borderColor;
@synthesize masksToBounds;
@synthesize rotation = _rotation;
@synthesize shouldAutoreverse;

-(id)init {
    return [self initWithFrame:CGRectZero];
}

-(id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self != nil) {
        self.animationDuration = 0.0f;
        self.animationDelay = 0.0f;
        self.animationOptions = BEGINCURRENT;
        self.repeatCount = 0;
        self.shouldAutoreverse = NO;
        [self setup];
        self.layer.delegate = self;
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
        UIGestureRecognizer *g = [self.gestureDictionary objectForKey:key];
        [g removeTarget:self action:nil];
        [self removeGestureRecognizer:g];
    }
    [self.gestureDictionary removeAllObjects];
    self.gestureDictionary = nil;
}

-(void)setup {
    
}

#pragma mark UIView animatable property overrides

-(void)setCenter:(CGPoint)center {
    CGPoint oldCenter = CGPointMake(self.center.x, self.center.y);

    void (^animationBlock) (void) = ^ { super.center = center; };
    void (^completionBlock) (BOOL) = nil;

    BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
    if(self.shouldAutoreverse && animationShouldNotRepeat) {
        completionBlock = ^ (BOOL animationIsComplete) {
            [self autoreverseAnimation:^ { super.center = oldCenter;}];
        };
    }
    [self animateWithBlock:animationBlock completion:completionBlock];
}

-(void)setOrigin:(CGPoint)origin {
    _origin = origin;
    CGPoint difference = self.origin;
    difference.x += self.frame.size.width/2.0f;
    difference.y += self.frame.size.height/2.0f;
    self.center = difference;
}

-(void)setFrame:(CGRect)frame {
    CGRect oldFrame = self.frame;
    
    void (^animationBlock) (void) = ^ { super.frame = frame; };
    void (^completionBlock) (BOOL) = nil;
    
    BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
    if(self.shouldAutoreverse && animationShouldNotRepeat) {
        completionBlock = ^ (BOOL animationIsComplete) {
            [self autoreverseAnimation:^ { super.frame = oldFrame;}];
        };
    }
    [self animateWithBlock:animationBlock completion:completionBlock];
}

-(void)setBounds:(CGRect)bounds {
    CGRect oldBounds = self.bounds;
    
    void (^animationBlock) (void) = ^ { super.bounds = bounds; };
    void (^completionBlock) (BOOL) = nil;
    
    BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
    if(self.shouldAutoreverse && animationShouldNotRepeat) {
        completionBlock = ^ (BOOL animationIsComplete) {
            [self autoreverseAnimation:^ { super.bounds = oldBounds;}];
        };
    }
    
    [self animateWithBlock:animationBlock completion:completionBlock];
}

-(void)setTransform:(CGAffineTransform)transform {
    CGAffineTransform oldTransform = self.transform;

    void (^animationBlock) (void) = ^ { super.transform = transform; };
    void (^completionBlock) (BOOL) = nil;
    
    BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
    if(self.shouldAutoreverse && animationShouldNotRepeat) {
        completionBlock = ^ (BOOL animationIsComplete) {
            [self autoreverseAnimation:^ { super.transform = oldTransform;}];
        };
    }
    
    [self animateWithBlock:animationBlock completion:completionBlock];
}

-(void)setAlpha:(CGFloat)alpha {
    CGFloat oldAlpha = self.alpha;
    
    void (^animationBlock) (void) = ^ { super.alpha = alpha; };
    void (^completionBlock) (BOOL) = nil;
    
    BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
    if(self.shouldAutoreverse && animationShouldNotRepeat) {
        completionBlock = ^ (BOOL animationIsComplete) {
            [self autoreverseAnimation:^ { super.alpha = oldAlpha;}];
        };
    }
    
    [self animateWithBlock:animationBlock completion:completionBlock];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    UIColor *oldBackgroundColor = self.backgroundColor;
    
    void (^animationBlock) (void) = ^ { super.backgroundColor = backgroundColor; };
    void (^completionBlock) (BOOL) = nil;
    
    BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
    if(self.shouldAutoreverse && animationShouldNotRepeat) {
        completionBlock = ^ (BOOL animationIsComplete) {
            [self autoreverseAnimation:^ { super.backgroundColor = oldBackgroundColor;}];
        };
    }
    
    [self animateWithBlock:animationBlock completion:completionBlock];
}

-(void)setContentStretch:(CGRect)contentStretch {
    CGRect oldContentStretch = self.contentStretch;

    void (^animationBlock) (void) = ^ { super.contentStretch = contentStretch; };
    void (^completionBlock) (BOOL) = nil;
    
    BOOL animationShouldNotRepeat = (self.animationOptions & REPEAT) !=  REPEAT;
    if(self.shouldAutoreverse && animationShouldNotRepeat) {
        completionBlock = ^ (BOOL animationIsComplete) {
            [self autoreverseAnimation:^ { super.contentStretch = oldContentStretch;}];
        };
    }
    
    [self animateWithBlock:animationBlock completion:completionBlock];
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
                        options:autoReverseOptions
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
                            options:autoreverseOptions
                         animations:animationBlock
                         completion:nil];
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
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
    BOOL containsGesture = ([self.gestureDictionary objectForKey:gestureName] != nil);
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
        [self.gestureDictionary setObject:recognizer forKey:gestureName];
    }
}

-(void)numberOfTapsRequired:(NSInteger)tapCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];
    
    C4Assert([recognizer isKindOfClass:[UITapGestureRecognizer class]] ||
             [recognizer isKindOfClass:[UILongPressGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %s",[recognizer class],_cmd);

    ((UILongPressGestureRecognizer *) recognizer).numberOfTapsRequired = tapCount;
}

-(void)numberOfTouchesRequired:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];
    
    C4Assert([recognizer isKindOfClass:[UITapGestureRecognizer class]] || 
             [recognizer isKindOfClass:[UISwipeGestureRecognizer class]] ||
             [recognizer isKindOfClass:[UILongPressGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %s",[recognizer class],_cmd);

    ((UITapGestureRecognizer *) recognizer).numberOfTouchesRequired = touchCount;
}

-(void)minimumPressDuration:(CGFloat)duration forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];

    C4Assert([recognizer isKindOfClass:[UITapGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method %s",[recognizer class],_cmd);
    
    ((UILongPressGestureRecognizer *) recognizer).minimumPressDuration = duration;
}
  
-(void)minimumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];

    C4Assert([recognizer isKindOfClass:[UIPanGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %s",[recognizer class],_cmd);

    ((UIPanGestureRecognizer *) recognizer).minimumNumberOfTouches = touchCount;
}

-(void)maximumNumberOfTouches:(NSInteger)touchCount forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];
    
    C4Assert([recognizer isKindOfClass:[UIPanGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %s",[recognizer class],_cmd);

    ((UIPanGestureRecognizer *) recognizer).maximumNumberOfTouches = touchCount;
}

-(void)swipeDirection:(C4SwipeDirection)direction forGesture:(NSString *)gestureName {
    UIGestureRecognizer *recognizer = [_gestureDictionary objectForKey:gestureName];

    C4Assert([recognizer isKindOfClass:[UISwipeGestureRecognizer class]],
             @"The gesture type(%@) you tried to configure does not respond to the method: %s",[recognizer class],_cmd);

    ((UISwipeGestureRecognizer *) recognizer).direction = direction;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    C4Log(@"-(void)touchesBegan:withEvent: {} %@ %d",[NSString stringWithUTF8String:__FILE__],__LINE__);
    [super touchesBegan:touches withEvent:event];
    [self postNotification:@"touchesBegan"];
    [self touchesBegan];
}

-(void)touchesBegan {
    C4Log(@"-(void)touchesBegan {} %@ %d",[NSString stringWithUTF8String:__FILE__],__LINE__);
}

-(void)touchesEnded {
}

-(void)touchesMoved {
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self postNotification:@"touchesMoved"];
    [super touchesMoved:touches withEvent:event];
    [self touchesMoved];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self postNotification:@"touchesEnded"];
    [super touchesEnded:touches withEvent:event];
    [self touchesEnded];
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
        [self sendAction:NSSelectorFromString(self.longPressMethodName) to:self forEvent:nil];
}

#pragma mark Test
-(void)test {
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

#pragma mark New Stuff
-(id)copyWithZone:(NSZone *)zone {
    return self;
}

-(CGFloat)width {
    return self.frame.size.width;
}

-(CGFloat)height {
    return self.frame.size.height;
}

-(void)setMask:(C4Control *)maskObject {
    self.layer.mask = maskObject.layer;
}

-(void)runMethod:(NSString *)methodName afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:self afterDelay:seconds];
}

-(void)runMethod:(NSString *)methodName withObject:(id)object afterDelay:(CGFloat)seconds {
    [self performSelector:NSSelectorFromString(methodName) withObject:object afterDelay:seconds];
}

//note, this is a strange hack... opacity can be controlled via 
-(void)setMasksToBounds:(BOOL)_masksToBounds {
    self.layer.masksToBounds = _masksToBounds;
}
-(BOOL)masksToBounds {
    return self.layer.masksToBounds;
}

-(void)setBorderColor:(UIColor *)_borderColor {
    [(C4Layer *)self.layer animateBorderColor:_borderColor.CGColor];
}
-(UIColor *)borderColor {
    return [UIColor colorWithCGColor:self.layer.borderColor];
}

-(void)setBorderWidth:(CGFloat)_borderWidth {
    [(C4Layer *)self.layer animateBorderWidth:_borderWidth];
}
-(CGFloat)borderWidth {
    return self.layer.borderWidth;
}

-(void)setCornerRadius:(CGFloat)_cornerRadius {
    [(C4Layer *)self.layer animateCornerRadius:_cornerRadius];
}
-(CGFloat)cornerRadius {
    return self.layer.cornerRadius;
}

-(void)setZPosition:(CGFloat)_zPosition {
    [(C4Layer *)self.layer animateZPosition:_zPosition];
}
-(CGFloat)zPosition {
    return self.layer.zPosition;
}

-(void)setRotation:(CGFloat)rotation {
    _rotation = rotation;
    [(C4Layer *)self.layer animateRotation:_rotation];
}

-(void)removeObject:(C4Control *)visibleObject {
    C4Assert(self != visibleObject, @"You tried to remove %@ from itself, don't be silly", visibleObject);
    [visibleObject removeFromSuperview];
}

-(void)rotationDidFinish:(CGFloat)rotation {
    [super setTransform:CGAffineTransformMakeRotation(rotation)];
}

#pragma mark C4AddSubview
-(void)addShape:(C4Shape *)shape {
    C4Assert([shape isKindOfClass:[C4Shape class]], 
             @"You tried to add a %@ using [canvas addShape:]", [shape class]);
    [super addSubview:shape];
}

-(void)addSubview:(UIView *)subview {
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
@end
