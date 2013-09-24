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
@end

@implementation C4GL
//@synthesize animationOptions = _animationOptions;
//@synthesize animating, animationFrameInterval;
//@synthesize renderer, displayLinkSupported;
//@synthesize eaglLayer;
//@synthesize displayLink;
//@synthesize animationTimer;
//@synthesize drawOnce;
//@synthesize shouldAutoreverse = _shouldAutoreverse;

+(C4GL *)glWithFrame:(CGRect)frame {
    C4GL *gl = [[C4GL alloc] init];
    gl.frame = frame;
    return gl;
}

-(id)init {
    return [self initWithRenderer:[[C4GL1Renderer alloc] init]];
}

-(id)initWithRenderer:(id <C4EAGLESRenderer>)renderer {
    self = [super init];
    if (self != nil) {        
        _eaglLayer = (C4EAGLLayer *)self.layer;
        _eaglLayer.drawableProperties = @{kEAGLDrawablePropertyRetainedBacking: @NO, kEAGLDrawablePropertyColorFormat: kEAGLColorFormatRGBA8};

		if (nil == _renderer) {
			_renderer = renderer;
			if (nil == renderer) {
				return nil;
			}
		}
        
        self.backgroundColor = [UIColor clearColor];
        
		_animating = NO;
		_displayLinkSupported = NO;
		_animationFrameInterval = 1;
		_displayLink = nil;
		_animationTimer = nil;
		
		CGFloat minimumSystemVersion = 3.1f;
        CGFloat currentSystemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
		if (currentSystemVersion >= minimumSystemVersion) {
			_displayLinkSupported = YES;
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
    [_renderer render];
    if (YES == self.drawOnce) {
        [self stopAnimation];
        self.drawOnce = NO;
    }
}

- (void) layoutSubviews {
	[_renderer resizeFromLayer:(C4EAGLLayer*)self.layer];
    [self render];
}

- (void) setAnimationFrameInterval:(NSInteger)frameInterval {
	if (frameInterval >= 1) {
	_animationFrameInterval = frameInterval;
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
			[self.displayLink setFrameInterval:_animationFrameInterval];
			[self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] 
                              forMode:NSDefaultRunLoopMode];
		} else {
            NSTimeInterval sixtyFramesPerSecond = (NSTimeInterval)(1.0 / 60.0);
            NSTimeInterval actualFramesPerSecond = sixtyFramesPerSecond * _animationFrameInterval;
			self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:actualFramesPerSecond 
                                                              target:self 
                                                            selector:@selector(render) 
                                                            userInfo:nil 
                                                             repeats:TRUE];
        }
		_animating = YES;
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
		_animating = NO;
	}
}

-(void)setRenderer:(id<C4EAGLESRenderer>)renderer {
    BOOL wasAnimating = NO;
    if(self.isAnimating) {
        wasAnimating = YES;
        [self stopAnimation];
    }
    
    _renderer = renderer;
    
    if(wasAnimating) [self startAnimation];
}

+ (Class) layerClass {
    return [C4EAGLLayer class];
}

-(void)setBackgroundColor:(UIColor *)backgroundColor {
    backgroundColor = [UIColor clearColor]; // can't remember why... should test and document
    [super setBackgroundColor:backgroundColor];
}

+(C4GL *)defaultStyle {
    return (C4GL *)[C4GL appearance];
}

-(C4GL *)copyWithZone:(NSZone *)zone {
    C4GL *newGL = [[C4GL allocWithZone:zone]
                   initWithRenderer:[(C4GL1Renderer *)self.renderer copy]];
    newGL.frame = self.frame;
    return newGL;
}

@end
