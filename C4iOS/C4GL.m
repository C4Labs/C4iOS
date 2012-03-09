//
//  C4GL.m
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4GL.h"
#import "C4EAGLLayer.h"
#import "C4GL1Renderer.h"

@interface C4GL () 
-(void)render;
@property (readonly, nonatomic, getter = isDisplayLinkSupported) BOOL displayLinkSupported;
@property (readonly, strong, nonatomic) C4EAGLLayer *eaglLayer;
@property (readwrite, strong, nonatomic) id displayLink;
@property (readwrite, strong, nonatomic) NSTimer *animationTimer;
@end

@implementation C4GL
@synthesize animating, animationFrameInterval;
@synthesize renderer, displayLinkSupported;
@synthesize eaglLayer;
@synthesize displayLink;
@synthesize animationTimer;

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
        
		animating = NO;
		displayLinkSupported = NO;
		animationFrameInterval = 1;
		displayLink = nil;
		animationTimer = nil;
		
		CGFloat minimumSystemVersion = 3.1;
        CGFloat currentSystemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (currentSystemVersion >= minimumSystemVersion) {
			displayLinkSupported = YES;
        }
    }
    return self;
}

-(void)render {
    [renderer render];
}

- (void) layoutSubviews {
	[renderer resizeFromLayer:(C4EAGLLayer*)self.layer];
    [self render];
}

- (void) setAnimationFrameIntervalm:(NSInteger)frameInterval {
	// Frame interval defines how many display frames must pass between each time the
	// display link fires. The display link will only fire 30 times a second when the
	// frame internal is two on a display that refreshes 60 times a second. The default
	// frame interval setting of one will fire 60 times a second when the display refreshes
	// at 60 times a second. A frame interval setting of less than one results in undefined
	// behavior.
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
@end
