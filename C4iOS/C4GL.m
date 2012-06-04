//
//  C4GL.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4GL.h"

@interface C4GL () 
-(void)render;
-(void)_setShadowOffset:(NSValue *)shadowOffset;
-(void)_setShadowRadius:(NSNumber *)shadowRadius;
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity;
-(void)_setShadowColor:(UIColor *)shadowColor;
-(void)_setShadowPath:(id)shadowPath;
@property (readonly, nonatomic, getter = isDisplayLinkSupported) BOOL displayLinkSupported;
@property (readonly, strong, nonatomic) C4EAGLLayer *eaglLayer;
@property (readwrite, strong, nonatomic) id displayLink;
@property (readwrite, strong, nonatomic) NSTimer *animationTimer;
@end

@implementation C4GL
//@synthesize animationOptions = _animationOptions;
//@synthesize animationDuration = _animationDuration;
@synthesize animating, animationFrameInterval;
@synthesize renderer, displayLinkSupported;
@synthesize eaglLayer;
@synthesize displayLink;
@synthesize animationTimer;
@synthesize shadowColor = _shadowColor;
@synthesize shadowOffset = _shadowOffset;
@synthesize shadowOpacity = _shadowOpacity;
@synthesize shadowRadius = _shadowRadius;
@synthesize shadowPath = _shadowPath;
@synthesize drawOnce;

-(id)init {
    return [self initWithRenderer:[[C4GL1Renderer alloc] init]];
}

-(id)initWithRenderer:(id <C4EAGLESRenderer>)_renderer {
    self = [super init];
    if (self != nil) {        
        eaglLayer = (C4EAGLLayer *)self.layer;
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];

		if (nil == renderer) {
			renderer = _renderer;
			if (nil == renderer) {
				return nil;
			}
		}
        
        self.backgroundColor = [UIColor clearColor];
        
		animating = NO;
		displayLinkSupported = NO;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
		
		CGFloat minimumSystemVersion = 3.1f;
        CGFloat currentSystemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (currentSystemVersion >= minimumSystemVersion) {
			displayLinkSupported = YES;
        }
    }
    return self;
}

-(void)dealloc {
    _shadowColor = nil;
    self.renderer = nil;
}

-(void)render {
    [renderer render];
    if (YES == self.drawOnce) {
        [self stopAnimation];
        self.drawOnce = NO;
    }
}

- (void) layoutSubviews {
	[renderer resizeFromLayer:(C4EAGLLayer*)self.layer];
    [self render];
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval {
	if (frameInterval >= 1) {
	animationFrameInterval = frameInterval;
		if (self.isAnimating) {
			[self stopAnimation];
			[self startAnimation];
		}
	}
}

-(void)startAnimation {
	if (!self.isAnimating) {
		if (self.isDisplayLinkSupported) {
			self.displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self 
                                                                            selector:@selector(render)];
			[self.displayLink setFrameInterval:animationFrameInterval];
			[self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] 
                              forMode:NSDefaultRunLoopMode];
		} else {
            NSTimeInterval sixtyFramesPerSecond = (NSTimeInterval)(1.0 / 60.0);
            NSTimeInterval actualFramesPerSecond = sixtyFramesPerSecond * animationFrameInterval;
			self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:actualFramesPerSecond 
                                                              target:self 
                                                            selector:@selector(render) 
                                                            userInfo:nil 
                                                             repeats:TRUE];
        }
		animating = YES;
	}
}

- (void)stopAnimation {
	if (self.isAnimating) {
		if (self.isDisplayLinkSupported) {
			[self.displayLink invalidate];
			self.displayLink = nil;
		} else {
			[self.animationTimer invalidate];
			self.animationTimer = nil;
		}
		animating = NO;
	}
}

-(void)setRenderer:(id<C4EAGLESRenderer>)_renderer {
    BOOL wasAnimating = NO;
    if(self.isAnimating) {
        wasAnimating = YES;
        [self stopAnimation];
    }
    
    renderer = _renderer;
    
    if(wasAnimating) [self startAnimation];
}

+ (Class) layerClass {
    return [C4EAGLLayer class];
}

-(void)setShadowOffset:(CGSize)shadowOffset {
    [self performSelector:@selector(_setShadowOffset:) withObject:[NSValue valueWithCGSize:shadowOffset] afterDelay:self.animationDelay];
}
-(void)_setShadowOffset:(NSValue *)shadowOffset {
    [self.eaglLayer animateShadowOffset:[shadowOffset CGSizeValue]];
}

-(void)setShadowRadius:(CGFloat)shadowRadius {
    [self performSelector:@selector(_setShadowRadius:) withObject:[NSNumber numberWithFloat:shadowRadius] afterDelay:self.animationDelay];
}
-(void)_setShadowRadius:(NSNumber *)shadowRadius {
    [self.eaglLayer animateShadowRadius:[shadowRadius floatValue]];
}

-(void)setShadowOpacity:(CGFloat)shadowOpacity {
    [self performSelector:@selector(_setShadowOpacity:) withObject:[NSNumber numberWithFloat:shadowOpacity] afterDelay:self.animationDelay];
}
-(void)_setShadowOpacity:(NSNumber *)shadowOpacity {
    [self.eaglLayer animateShadowOpacity:[shadowOpacity floatValue]];
}

-(void)setShadowColor:(UIColor *)shadowColor {
    [self performSelector:@selector(_setShadowColor:) withObject:shadowColor afterDelay:self.animationDelay];
}
-(void)_setShadowColor:(UIColor *)shadowColor {
    [self.eaglLayer animateShadowColor:shadowColor.CGColor];
}

-(void)setShadowPath:(CGPathRef)shadowPath {
    [self performSelector:@selector(_setShadowPath:) withObject:(__bridge id)shadowPath afterDelay:self.animationDelay];
}
-(void)_setShadowPath:(id)shadowPath {
    [self.eaglLayer animateShadowPath:(__bridge CGPathRef)shadowPath];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
}

-(void)setAnimationDuration:(CGFloat)animationDuration {
    [super setAnimationDuration:animationDuration];
    self.eaglLayer.animationDuration = animationDuration;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    [super setAnimationOptions:animationOptions];
    self.eaglLayer.animationOptions = animationOptions;
}

@end
