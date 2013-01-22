//
//  C4TransformableControl.m
//  Clock
//
//  Created by moi on 12-08-15.
//  Copyright (c) 2012 moi. All rights reserved.
//

#import "C4TransformableControl.h"

@interface C4TransformableControl ()
@property (readwrite, nonatomic, strong) C4TransformLayer *transformLayer;
@property (readwrite, atomic) BOOL shouldAutoreverse;
@end

@implementation C4TransformableControl
@synthesize shouldAutoreverse = _shouldAutoreverse;
@synthesize animationOptions = _animationOptions;
@synthesize anchorPoint = _anchorPoint;

-(C4TransformLayer *)transformLayer {
    return (C4TransformLayer *)self.layer;
}

+(Class)layerClass {
    return [C4TransformLayer class];
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
    _anchorPoint = anchorPoint;
    CGRect oldFrame = self.frame;
    self.layer.anchorPoint = anchorPoint;
    super.frame = oldFrame;
}

-(void)setAnimationOptions:(NSUInteger)animationOptions {
    /*
     important: we have to intercept the setting of AUTOREVERSE for the case of reversing 1 time
     i.e. reversing without having set REPEAT
     
     UIView animation will flicker if we don't do this...
     */
    
    //shapelayer animation options should be set first
    ((id <C4LayerAnimation>)self.layer).animationOptions = animationOptions;
    
    //strip the autoreverse from the control's animation options if needed
    if ((animationOptions & AUTOREVERSE) == AUTOREVERSE) {
        self.shouldAutoreverse = YES;
        animationOptions &= ~AUTOREVERSE;
    }
    _animationOptions = animationOptions | BEGINCURRENT;
}

@end
