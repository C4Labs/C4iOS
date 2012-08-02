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
@property (readonly, nonatomic, getter = isDisplayLinkSupported) BOOL displayLinkSupported;
@property (readonly, strong, nonatomic) C4EAGLLayer *eaglLayer;
@property (readwrite, strong, nonatomic) id displayLink;
@property (readwrite, strong, nonatomic) NSTimer *animationTimer;
@property (readwrite, atomic) BOOL shouldAutoreverse;
@end

@implementation C4GL
@synthesize animationOptions = _animationOptions;
@synthesize animating, animationFrameInterval;
@synthesize renderer, displayLinkSupported;
@synthesize eaglLayer;
@synthesize displayLink;
@synthesize animationTimer;
@synthesize drawOnce;
@synthesize shouldAutoreverse = _shouldAutoreverse;

+(C4GL *)glWithFrame:(CGRect)frame {
    C4GL *gl = [[C4GL alloc] init];
    gl.frame = frame;
    return gl;
}

-(id)init {
    return [self initWithRenderer:[[C4GL1Renderer alloc] init]];
}

-(id)initWithRenderer:(id <C4EAGLESRenderer>)_renderer {
    self = [super init];
    if (self != nil) {        
        eaglLayer = (C4EAGLLayer *)self.layer;
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
        self.masksToBounds = NO;
        [self setup];
    }
    return self;
}

-(void)dealloc {
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

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:[UIColor clearColor]];
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    /*
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    
    //shapelayer animation options should be set first
    self.eaglLayer.animationOptions = animationOptions;
    
    //strip the autoreverse from the control's animation options if needed
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    _animationOptions = animationOptions | BEGINCURRENT;
}

@end
