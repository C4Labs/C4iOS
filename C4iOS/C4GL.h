//
//  C4GL.h
//  C4iOS
//
//  Created by Travis Kirton on 12-03-08.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4Control.h"

/*
 NEED TO ADD LAYER ANIMATIONS TO THIS CLASS
 */

@interface C4GL : C4Control {    
}

-(id)initWithRenderer:(id)renderer;
-(void)startAnimation;
-(void)stopAnimation;

@property (readwrite, strong, nonatomic) id <C4EAGLESRenderer> renderer;
@property (readonly, nonatomic, getter=isAnimating) BOOL animating;
@property (nonatomic) NSInteger animationFrameInterval;
@end
