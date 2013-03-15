//
//  C4ImageView.m
//  C4iOS
//
//  Created by moi on 13-02-18.
//  Copyright (c) 2013 POSTFL. All rights reserved.
//

#import "C4ImageView.h"

@implementation C4ImageView

-(C4Layer *)imageLayer {
    return (C4Layer *)self.layer;
}

+(Class)layerClass {
    return [C4Layer class];
}

-(void)animateContents:(CGImageRef)_image {
    [CATransaction begin];
    CABasicAnimation *animation = [self.imageLayer setupBasicAnimationWithKeyPath:@"contents"];
    animation.fromValue = self.imageLayer.contents;
    animation.toValue = (__bridge id)_image;
    if (animation.repeatCount != FOREVER && !self.imageLayer.autoreverses) {
        [CATransaction setCompletionBlock:^ {
            self.imageLayer.contents = (__bridge id)_image;
            [self.imageLayer removeAnimationForKey:@"animateContents"];
        }];
    }
    [self.imageLayer addAnimation:animation forKey:@"animateContents"];
    [CATransaction commit];
}

-(void)rotationDidFinish:(CGFloat)rotationAngle {
    [(C4Image *)self.superview rotationDidFinish:rotationAngle];
}

@end