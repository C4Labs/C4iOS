//
//  HiddenNavView.m
//  C4iOS
//
//  Created by moi on 12-12-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "HiddenNavView.h"
#import "C4TransformableControl.h"

@interface HiddenNavView ()
@property (readwrite, atomic) CGRect halfFrame;
@property (readwrite, strong, atomic) C4View *navView;
@property (readwrite, strong, atomic) C4TransformableControl *flipView;
@property (readwrite, atomic, getter = isFlippedOut) BOOL flippedOut;
@property (readwrite, atomic) BOOL hasShadow;
@end

@implementation HiddenNavView

@synthesize flippedOut, flipView, flipViewImage = _flipViewImage, halfFrame, hasShadow;

-(void)setup {
    CGRect r = self.bounds;
    r.size.width /= 2;
    self.halfFrame = r;
    
    self.navView = [[C4View alloc] initWithFrame:self.halfFrame];
    self.navView.backgroundColor = C4RED;
    
    self.flipView = [[C4TransformableControl alloc] initWithFrame:self.halfFrame];
    self.flipView.anchorPoint = CGPointMake(1.0,0.5);
    self.flipView.frame = self.halfFrame;

    for(int i = 0; i < 6; i++) {
        CGRect buttonRect = CGRectMake(2, 2+i*40, 40, 40);
        C4Shape *button = [C4Shape ellipse:buttonRect];
        button.lineWidth = 0.0f;
        button.zPosition = -1;
        [self listenFor:@"touchesBegan" fromObject:button andRunMethod:@"changeColor:"];
        [self.flipView addShape:button];
    }

    [self addSubview:self.navView];
    [self addSubview:self.flipView];
    
    self.flippedOut = NO;
    self.hidden = YES;
}

-(void)changeColor:(NSNotification *)notification {
    if([[notification object] isKindOfClass:[C4Shape class]])
        ((C4Shape *)[notification object]).fillColor = [UIColor colorWithRed:[C4Math randomInt:255]/255.0f
                                                                       green:[C4Math randomInt:255]/255.0f
                                                                        blue:1
                                                                       alpha:1];
}

-(void)setFlipViewImage:(C4Image *)image {
    C4Image *oldImage;
    if (self.flipViewImage != nil) oldImage = self.flipViewImage;
    _flipViewImage = image;
    [self.flipView addSubview:self.flipViewImage];
    self.flipViewImage.zPosition = 0;
    self.flipViewImage.userInteractionEnabled = NO;
    if (self.flipViewImage != nil) [oldImage removeFromSuperview];
    hasShadow = NO;
    if(self.isHidden) self.hidden = NO;
}

-(void)flipIn {
    [self sendSubviewToBack:self.navView];
    if(self.isFlippedOut && !self.isHidden) {
        self.flipView.animationDuration = 1.5;
        self.flipView.perspectiveDistance = -200.0f;
        self.flipView.rotationY = -PI;
        self.flipView.center = self.center;
        self.flippedOut = NO;
    }
}

-(void)flipOut {
    [self sendSubviewToBack:self.navView];
    if(!self.isFlippedOut && !self.isHidden) {
        if(hasShadow == NO)[self addShadow];
        self.flipView.animationDuration = 1.5;
        self.flipView.perspectiveDistance = -200.0f;
        self.flipView.rotationY = PI;
        self.flippedOut = YES;
    }
}

-(void)addShadow {
    self.flipViewImage.shadowOpacity = 0.8;
    self.flipViewImage.shadowOffset = CGSizeMake(-4,0);
    self.flipViewImage.shadowRadius = 2;
    self.hasShadow = YES;
}


@end
