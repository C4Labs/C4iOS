// Copyright © 2012 Travis Kirton
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

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