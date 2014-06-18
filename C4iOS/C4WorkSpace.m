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

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *theShape;
}

-(void)setup {
    //setup up the initial shape
    theShape = [C4Shape rect:CGRectMake(0,0,240,240)];
    theShape.center = self.canvas.center;
    theShape.borderWidth = 1.0f;
    
    //set its animation duration which will be used for all animations
    theShape.animationDuration = 1.0f;
    
    //add it to the canvas
    [self.canvas addControl:theShape];
    
    //run the -(void)ellipse method 2 seconds later...
    [self run:^{ [self ellipse]; } afterDelay:2.0f];
}

-(void)rect {
    [theShape rect:CGRectMake(0,0,240,240)];
    theShape.center = self.canvas.center;
    theShape.center = self.canvas.center;
    [self run:^{ [self ellipse]; } afterDelay:2.0f];
}

-(void)ellipse {
    [theShape ellipse:theShape.frame];
    theShape.center = self.canvas.center;
    [self run:^{
        [self triangle];
    } afterDelay:2.0f];
}

-(void)triangle {
    CGPoint pts[3] = {
        CGPointMake(self.canvas.center.x-100, self.canvas.center.y),
        CGPointMake(self.canvas.center.x, self.canvas.center.y-100),
        CGPointMake(self.canvas.center.x+100, self.canvas.center.y)
    };
    [theShape triangle:pts];
    theShape.center = self.canvas.center;
    [self run:^{ [self arc]; } afterDelay:2.0f];
}

-(void)arc {
    [theShape arcWithCenter:self.canvas.center
                     radius:100.0f
                 startAngle:PI / 3.0f
                   endAngle:PI*2/3.0f
                  clockwise:YES];
    theShape.center = self.canvas.center;
    [self run:^{ [self wedge]; } afterDelay:2.0f];
}

-(void)wedge {
    [theShape wedgeWithCenter:self.canvas.center
                       radius:100.0
                   startAngle:PI / 3.0f
                     endAngle:PI*2/3.0f
                    clockwise:NO];
    theShape.center = self.canvas.center;
    [self run:^{ [self bezierCurve]; } afterDelay:2.0f];
}

-(void)bezierCurve {
    CGPoint endPoints[2] = {
        CGPointMake(self.canvas.center.x-100, self.canvas.center.y),
        CGPointMake(self.canvas.center.x+100, self.canvas.center.y)
    };
    CGPoint ctrlPoints[2] = {
        CGPointMake([C4Math randomInt:(int)self.canvas.width],
                    [C4Math randomInt:(int)self.canvas.height]),
        CGPointMake([C4Math randomInt:(int)self.canvas.width],
                    [C4Math randomInt:(int)self.canvas.height])
    };
    [theShape curve:endPoints controlPoints:ctrlPoints];
    theShape.center = self.canvas.center;
    [self run:^{ [self quadCurve]; } afterDelay:2.0f];
}

-(void)quadCurve {
    CGPoint endPoints[2] = {
        CGPointMake(self.canvas.center.x-100, self.canvas.center.y),
        CGPointMake(self.canvas.center.x+100, self.canvas.center.y)
    };
    CGPoint ctrlPoint = CGPointMake([C4Math randomInt:(int)self.canvas.width],
                                    [C4Math randomInt:(int)self.canvas.height]);
    
    [theShape quadCurve:endPoints controlPoint:ctrlPoint];
    theShape.center = self.canvas.center;
    [self run:^{ [self polygon]; } afterDelay:2.0f];
}

-(void)polygon {
    CGPoint pts[10];
    for(int i = 0; i < 10; i++) {
        pts[i] = CGPointMake([C4Math randomInt:200]+self.canvas.center.x-100,
                             [C4Math randomInt:200]+self.canvas.center.y-100);
    }
    [theShape polygon:pts pointCount:10];
    theShape.center = self.canvas.center;
    [self run:^{ [self text]; } afterDelay:2.0f];
}

-(void)text{
    C4Font *f = [C4Font fontWithName:@"DINAlternate-Bold" size:240.0f];
    [theShape shapeFromString:@"C4" withFont:f];
    theShape.center = self.canvas.center;
    theShape.center = self.canvas.center;
    [self run:^{ [self rect]; } afterDelay:2.0f];
}@end
