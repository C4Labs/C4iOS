//
//  C4WorkSpace.m
//
//  Created by Travis Kirton
//

#import "C4WorkSpace.h"

@implementation C4WorkSpace {
    C4Shape *s, *t;
}

-(void)setup {
    s = [C4Shape ellipse:CGRectMake(20, 20, 100, 100)];
    [self.canvas addShape:s];

    t = [C4Shape ellipse:CGRectMake(400, 20, 100, 100)];
    [self.canvas addShape:t];

    [self runMethod:@"test" afterDelay:1.0f];
}

-(void)test {
    s.shapeLayer.affineTransform = CGAffineTransformMakeScale(2, 2);
    s.origin = CGPointMake(20,20);

    CGRect newFrame = t.frame;
    newFrame.size.width *= 2;
    newFrame.size.height *= 2;
    [t ellipse:newFrame];
}
@end
/*
#import "C4WorkSpace.h"
#import "HiddenNav.h"
#import "OuterShape.h"

@implementation C4WorkSpace {
    C4Label *moveLabel, *captureLabel, *flipInLabel, *flipOutLabel;
    HiddenNav *hiddenNav;
}

-(void)setup {
//    [self createOuterShapes];
    [self createNav];
//    [self createLabels];
}

-(void)createOuterShapes {
    self.canvas.backgroundColor = [UIColor blackColor];
    for(int i = 0; i < 24; i++) {
        OuterShape *os = [[OuterShape alloc] init];
        [os setup];
        [self.canvas addShape:os];
    }
}

-(void)createLabels {
    moveLabel = [C4Label labelWithText:@"MOVE" font:[C4Font fontWithName:@"Avenir-Light" size:36]];
    [moveLabel sizeToFit];
    moveLabel.origin = CGPointMake(self.canvas.width-moveLabel.width,
                                   self.canvas.height-moveLabel.height);
    [self.canvas addLabel:moveLabel];
    [self listenFor:@"touchesBegan" fromObject:moveLabel andRunMethod:@"moveObjects"];
    
    captureLabel = [C4Label labelWithText:@"CAPTURE"
                                     font:[C4Font fontWithName:@"Avenir-Light" size:36]];
    [captureLabel sizeToFit];
    captureLabel.origin = CGPointMake(self.canvas.width-captureLabel.width,
                                      moveLabel.origin.y-captureLabel.height);
    [self.canvas addLabel:captureLabel];
    [self listenFor:@"touchesBegan" fromObject:captureLabel andRunMethod:@"captureScreen:"];
    
    flipInLabel = [C4Label labelWithText:@"Flip In"
                                    font:[C4Font fontWithName:@"Avenir-Light" size:36]];
    [flipInLabel sizeToFit];
    flipInLabel.origin = CGPointMake(self.canvas.width-flipInLabel.width,
                                     captureLabel.origin.y-flipInLabel.height);
    [self.canvas addLabel:flipInLabel];
    [hiddenNav listenFor:@"touchesBegan" fromObject:flipInLabel andRunMethod:@"flipIn"];
    [self listenFor:@"touchesBegan" fromObject:flipInLabel andRunMethod:@"flipIn"];
    
    flipOutLabel = [C4Label labelWithText:@"Flip Out"
                                     font:[C4Font fontWithName:@"Avenir-Light" size:36]];
    [flipOutLabel sizeToFit];
    flipOutLabel.origin = CGPointMake(self.canvas.width-flipOutLabel.width,
                                      flipInLabel.origin.y-flipOutLabel.height);
    [self.canvas addLabel:flipOutLabel];
    [self listenFor:@"touchesBegan" fromObject:flipOutLabel andRunMethod:@"flipOut"];
    
    [self moveObjects];
}

-(void)createNav {
    hiddenNav = [[HiddenNav alloc] initWithNibName:@"HiddenNav" bundle:nil];
    [hiddenNav setup];
    [self.canvas addSubview:hiddenNav.canvas];
}

-(void)moveObjects {
    for(OuterShape *os in self.canvas.subviews) {
        if([os isKindOfClass:[OuterShape class]])
            [os randomMove];
    }
}

-(void)flipIn {
//    [hiddenNavView flipIn];
}

-(void)flipOut {
//    [hiddenNavView flipOut];
}

-(void)captureScreen:(id)sender{
    CGSize captureSize = CGSizeMake(hiddenNav.canvas.frame.size.width/2, hiddenNav.canvas.frame.size.height);
    NSInteger rowBytes = (NSInteger)captureSize.width * 4;
    NSInteger bitsPerComponent = 8;
    void *imageBuffer = malloc((NSInteger)captureSize.height * rowBytes);
    
    CGContextRef context = CGBitmapContextCreate(imageBuffer, (NSInteger)captureSize.width, (NSInteger)captureSize.height, bitsPerComponent ,rowBytes, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaPremultipliedLast);
    
    CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextFillRect(context, hiddenNav.canvas.bounds);
    CGContextConcatCTM(context, CGAffineTransformMake(1, 0, 0, -1, 0, captureSize.height));
    
    for(OuterShape *os in self.canvas.subviews) {
        if ([os isKindOfClass:[OuterShape class]]) {
            CGContextTranslateCTM(context, 0, os.origin.y);
            [os.layer renderInContext:context];
            CGContextTranslateCTM(context, 0, -1*os.origin.y);
        }
    }

//    C4Image *i = [[C4Image alloc] initWithRawData:imageBuffer
//                                            width:(NSInteger)captureSize.width
//                                           height:(NSInteger)captureSize.height];
    
//    hiddenNavView.flipViewImage = i;
    free(imageBuffer);
}

@end
 */
