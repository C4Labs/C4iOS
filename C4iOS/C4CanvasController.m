//
//  ViewController.m
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import "C4CanvasController.h"
//C4Label *newLabel;
//C4Shape *what;
//CALayer *rLayer;
//UIImageView *imgView;
C4Image *image, *inverted;

@implementation C4CanvasController
@synthesize canvas;

//UIImageView *imgView;
//UIBezierPath *animationPath;
C4GL *gl;

-(void)setup {
    canvas = (C4Window *)self.view;

//    NSArray *filterCategorArray = [NSArray arrayWithObjects:
//                                   kCICategoryDistortionEffect,
//                                   kCICategoryGeometryAdjustment,
//                                   kCICategoryCompositeOperation,
//                                   kCICategoryHalftoneEffect,
//                                   kCICategoryColorAdjustment,
//                                   kCICategoryColorEffect,
//                                   kCICategoryTransition,
//                                   kCICategoryTileEffect,
//                                   kCICategoryGenerator,
//                                   kCICategoryReduction,
//                                   kCICategoryGradient,
//                                   kCICategoryStylize,
//                                   kCICategorySharpen,
//                                   kCICategoryBlur,
//                                   kCICategoryVideo,
//                                   kCICategoryStillImage,
//                                   kCICategoryInterlaced,
//                                   kCICategoryNonSquarePixels,
//                                   kCICategoryHighDynamicRange,
//                                   kCICategoryBuiltIn,
//                                   nil];
//    NSMutableSet *filterNameSet = [[NSMutableSet alloc] initWithCapacity:0];
//    for (NSString *category in filterCategorArray) {
//        for(NSString *filterName in [CIFilter filterNamesInCategory:category]) {
//            [filterNameSet addObject:filterName];
//        }
//    }
//    
//    for(NSString *filterName in filterNameSet) {
//        C4Log(@"%@",filterName);
//    }
//    C4Log(@"Filter Count: %d",[filterNameSet count]);

    /*
     [C4Log] CIHighlightShadowAdjust
     [C4Log] CITemperatureAndTint
     [C4Log] CISourceOverCompositing
     [C4Log] CIAdditionCompositing
     [C4Log] CIToneCurve
     [C4Log] CIColorBlendMode
     [C4Log] CICheckerboardGenerator
     [C4Log] CIColorInvert
     [C4Log] CIOverlayBlendMode
     [C4Log] CIVibrance
     [C4Log] CILinearGradient
     [C4Log] CIDarkenBlendMode
     [C4Log] CIColorMatrix
     [C4Log] CISepiaTone
     [C4Log] CIHueAdjust
     [C4Log] CIColorCube
     [C4Log] CIHueBlendMode
     [C4Log] CIStraightenFilter
     [C4Log] CIRadialGradient
     [C4Log] CIColorDodgeBlendMode
     [C4Log] CIColorBurnBlendMode
     [C4Log] CIDifferenceBlendMode
     [C4Log] CIScreenBlendMode
     [C4Log] CICrop
     [C4Log] CIColorMonochrome
     [C4Log] CISourceOutCompositing
     [C4Log] CIExclusionBlendMode
     [C4Log] CISourceAtopCompositing
     [C4Log] CIFalseColor
     [C4Log] CIExposureAdjust
     [C4Log] CISoftLightBlendMode
     [C4Log] CIMaximumCompositing
     [C4Log] CIHardLightBlendMode
     [C4Log] CIMultiplyBlendMode
     [C4Log] CIColorControls
     [C4Log] CIMinimumCompositing
     [C4Log] CIStripesGenerator
     [C4Log] CIWhitePointAdjust
     [C4Log] CIVignette
     [C4Log] CIConstantColorGenerator
     [C4Log] CIGaussianGradient
     [C4Log] CIGammaAdjust
     [C4Log] CIMultiplyCompositing
     [C4Log] CISaturationBlendMode
     [C4Log] CILightenBlendMode
     [C4Log] CILuminosityBlendMode
     [C4Log] CISourceInCompositing
     [C4Log] CIAffineTransform
     */
    
    image = [C4Image imageNamed:@"candahar256.png"];
    [canvas addImage:image];
    
    inverted = [C4Image imageNamed:@"candahar256Inverted.jpg"];
    [canvas addImage:inverted];
    inverted.origin = CGPointMake(0, 768);
//    gl = [C4GL new];
//    gl.frame = CGRectMake(101, 243, 600, 400);
//    [canvas addSubview:gl];
//    gl.drawOnce = YES;
//    [gl startAnimation];
    
//    imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"candahar256.png"]];
//    imgView.frame = CGRectMake(0, 0, 128, 128);
//    imgView.center = CGPointMake(384, 128);
//    canvas.layer.backgroundColor = [UIColor blueColor].CGColor;
//    [canvas addSubview:imgView];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    image.animationDuration = 1.0f;
    [image invert];
//    image.animationDuration = 2.0f;
//    image.shadowOpacity = 0.8f;
//    image.shadowOffset = CGSizeMake(15.0, 15.0);
//    image.animationOptions = AUTOREVERSE;
//    image.center = CGPointMake(384, 512);
//    imageWithImage.animationOptions = REPEAT;
//    imageWithImage.animationDuration = 2.0f;
//    imageWithImage.frame = CGRectMake(0, 0, 512, 256);
//    imageWithImage.transform = CGAffineTransformRotate(imageWithImage.transform, TWO_PI);
//    imageWithImage.alpha = 0.0f;
//    imageWithImage.center = CGPointMake(384, 512);


}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [UIImageView animateWithDuration:2.0f animations:^{
//        [CATransaction begin];        
//        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        pathAnimation.duration = 2.0f;
//        pathAnimation.calculationMode = kCAAnimationPaced;
//        animationPath = [UIBezierPath bezierPath];
//        [animationPath moveToPoint:imgView.center];
//        [animationPath addLineToPoint:CGPointMake(128, 512)];
//        [animationPath addLineToPoint:CGPointMake(384, 896)];
//        pathAnimation.path = animationPath.CGPath;
//        pathAnimation.fillMode = kCAFillModeForwards;
//        pathAnimation.removedOnCompletion = NO;
//        [imgView.layer addAnimation:pathAnimation forKey:@"animatePosition"];
//        [CATransaction commit];
//
//        CGFloat scaleFactor = 2.0f;
//        CGRect newFrame = imgView.frame;
//        newFrame.size.width *= scaleFactor;
//        newFrame.size.height *= scaleFactor;
//        newFrame.origin = CGPointMake(256, 0);
//        imgView.frame = newFrame;
//        imgView.transform = CGAffineTransformRotate(imgView.transform,90.0*M_PI/180);
//    }];
//}

//-(void)setup {
//    canvas = (C4View *)self.view;
//
//    newLabel = [C4Label new];
//    newLabel.frame = CGRectMake(100, 100, 100, 100);
//    newLabel.font = [C4Font fontWithName:@"arial" size:40];
//    newLabel.text = @"travis";
//    newLabel.shadowOffset = CGSizeMake(1, 1);
//    newLabel.center = CGPointMake(100, 200);
//    newLabel.shadowColor = [UIColor magentaColor];
//    newLabel.backgroundColor = [UIColor orangeColor];
//    [canvas addSubview:newLabel];
//
//    C4Shape *rect = [C4Shape rect:CGRectMake(500, 500, 100, 100)];
//    [canvas addShape:rect];
//    [canvas addSubview:newLabel];
//    [newLabel sizeToFit];
//    [newLabel listenFor:@"touchesBegan" fromObject:rect andRunMethod:@"test"]; 
//}
//
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    newLabel.animationDuration = 1.0f;
//    newLabel.animationDelay = 1.0f;
//    newLabel.animationOptions = AUTOREVERSE | REPEAT;
//    newLabel.backgroundColor = [UIColor whiteColor];
//    newLabel.shadowOffset = CGSizeMake(10, 10);
//    newLabel.shadowOpacity = 0.5;
//    newLabel.textShadowOffset = CGSizeMake(2, 2);
//    newLabel.text = @"kirton";
//    [newLabel sizeToFit];
//    newLabel.center = CGPointMake(300, 300);
//}

@end

//@implementation C4CanvasController
//@synthesize canvas;
//-(void)setup {
//    canvas = (C4View *)self.view;
//    C4Shape *s = [[C4Shape alloc] init];
//    [s rect:CGRectMake(100, 100, 200, 100)];
//    [canvas addShape:s];
//    C4Text *t = [[C4Text alloc] initWithFrame:CGRectMake(100, 100, 200, 100)];
//    t.backgroundColor = [UIColor lightGrayColor];
//    t.string = @"hi there i hope this works";
//    t.font = [C4Font fontWithName:ITALICSYSTEMFONTNAME size:14.0f];
//    t.resizesToFitText = YES;
//    [canvas addSubview:t];
    
//    C4Text * textView = [[C4Text alloc] init];
//    textView.frame = CGRectMake(0, 0, 1024, 1024);
//    textView.font = [UIFont systemFontOfSize:40.0f];
    
//    textView.text = @"something really longer";    // Really long string
//    [textView sizeToFit];
//    textView.backgroundColor = [UIColor lightGrayColor];
//    [self.view addSubview:textView];    
//    C4Font *f = [C4Font systemFontOfSize:20];
    
    
    /*
     asldkfja;sldfkjsalfdaksj
     getting paths from things to things...
     there should be an option: [C4Shape shapeFromText];
     */
//    CGGlyph glyphs;
//    const unichar c = [@"hi" characterAtIndex:0];
//    CTFontGetGlyphsForCharacters (f.CTFont,&c,
//                                       &glyphs,
//                                       1
//                                       );
//    
//    CAShapeLayer *sl = [CAShapeLayer layer];
//    CTFontRef font = CTFontCreateWithName((CFStringRef)@"helvetica", 400.0f, nil);
//    CGAffineTransform afft = CGAffineTransformMakeScale(1, -1);
//    sl.path = CTFontCreatePathForGlyph(font, glyphs, &afft);
//    CGRect pathRect = CGPathGetPathBoundingBox(sl.path);
//    sl.frame = pathRect;
//    sl.lineWidth = 30.0f;
//    sl.position = CGPointMake(368, 512);
//    sl.backgroundColor = [UIColor lightGrayColor].CGColor;
//    [self.view.layer addSublayer:sl];
//}
//@end
//
//#import "CustomShape.h"
//#import "TestView.h"
//
//@implementation C4CanvasController
//@synthesize canvas;
//
//CustomShape *rect;
//TestView *myTestView;
//CALayer *spotlightLayer;

//-(void)setup {
//    canvas = (C4View *)self.view;
//    canvas.backgroundColor = [UIColor blueColor];
//
//    spotlightLayer = [CALayer layer];
//    spotlightLayer.frame = CGRectInset(canvas.layer.bounds, -50, -50);    
//    spotlightLayer.opacity = 0.60;
//    spotlightLayer.delegate = self;
//
//    [canvas.layer addSublayer:spotlightLayer];
//}

//-(void)setup { 
//    canvas = (C4View *)self.view;
//    rect = [[CustomShape alloc] init];
//    [rect rect:CGRectMake(200, 200, 200, 200)];
//    [rect addGesture:TAP name:@"tapGesture" action:@"orangeRect"];
//    [rect addGesture:SWIPERIGHT name:@"swipeGestureRight" action:@"swipedRight"];
//    [rect addGesture:SWIPELEFT name:@"swipeGestureLeft" action:@"swipedLeft"];
//    [rect addGesture:SWIPEUP name:@"swipeGestureUp" action:@"swipedUp"];
//    [rect addGesture:SWIPEDOWN name:@"swipeGestureDown" action:@"swipedDown"];
//    [rect addGesture:LONGPRESS name:@"longPress" action:@"pressedLong"];
//    [canvas addShape:rect];
//    
//    TestView *tv = [[TestView alloc] initWithFrame:CGRectMake(200, 400, 100, 100)];
//    tv.backgroundColor = [UIColor blueColor];
//    [canvas addSubview:tv];
//}

//-(void)setup {
//    canvas = (C4Window *)self.view;
//
//    rect = [[CustomShape alloc] init];
//    [rect rect:CGRectMake(0, 0, 100, 100)];
//    [rect addGesture:PAN name:@"panGesture" action:@"move:"];
//    [rect addGesture:TAP name:@"tapGesture" action:@"circle"];
//    [canvas addShape:rect];
//}

//@end
//
//#import "CustomShape.h"
//
//@interface C4CanvasController ()
//-(void)changeCenters;
//@end
//@implementation C4CanvasController
//@synthesize canvas;
//
//C4Shape *greyrect;
//NSMutableArray *shapes;
//
//-(void)setup {
//    greyrect = [[CustomShape alloc] init];
//    [greyrect rect:CGRectMake(334, -100, 100, 100)];
//    greyrect.fillColor = C4GREY;
//    greyrect.strokeColor = C4GREY;
//
//    shapes = [[NSMutableArray alloc] initWithCapacity:0];
//    canvas = (C4View *)self.view;
//    
//    for(int i = 0; i < 7; i++) {
//        C4Shape *rect = [[CustomShape alloc] init];
//        [rect rect:CGRectMake(334, -100, 100, 100)];
//        rect.fillColor = C4RED;
//        rect.strokeColor = C4RED;
//        [shapes addObject:rect];
//        [canvas addShape:rect];
//    }
//
//    [canvas addShape:greyrect];
//    [shapes addObject:greyrect];
//
//    for(int i = 0; i < 8; i++) {
//        C4Shape *rect = [[CustomShape alloc] init];
//        [rect rect:CGRectMake(334, -100, 100, 100)];
//        rect.fillColor = C4BLUE;
//        rect.strokeColor = C4BLUE;
//        [shapes addObject:rect];
//        [canvas addShape:rect];
//    }
//    [self performSelector:@selector(changeCenters) withObject:self afterDelay:0.25f];
//
//    for(C4Shape *s in shapes) [s listenFor:@"touchesBegan" fromObject:greyrect andRunMethod:@"circle"];
//}
//
//-(C4View *)canvas {
//    return (C4View *)self.view;
//}
//
//-(void)changeCenters {
//    for(C4Shape *s in shapes) s.animationDuration = 1.0f;
//    ((C4Shape *)[shapes objectAtIndex:0]).center = CGPointMake(350, 584);
//    ((C4Shape *)[shapes objectAtIndex:1]).center = CGPointMake(250, 584);
//    ((C4Shape *)[shapes objectAtIndex:2]).center = CGPointMake(150, 584);
//    ((C4Shape *)[shapes objectAtIndex:3]).center = CGPointMake(150, 484);
//    ((C4Shape *)[shapes objectAtIndex:4]).center = CGPointMake(150, 384);
//    ((C4Shape *)[shapes objectAtIndex:5]).center = CGPointMake(150, 284);
//    ((C4Shape *)[shapes objectAtIndex:6]).center = CGPointMake(250, 284);
//    ((C4Shape *)[shapes objectAtIndex:7]).center = CGPointMake(350, 284);
//    ((C4Shape *)[shapes objectAtIndex:8]).center = CGPointMake(350, 384);
//    ((C4Shape *)[shapes objectAtIndex:9]).center = CGPointMake(350, 484);
//    ((C4Shape *)[shapes objectAtIndex:10]).center = CGPointMake(450, 484);
//    ((C4Shape *)[shapes objectAtIndex:11]).center = CGPointMake(550, 484);
//    ((C4Shape *)[shapes objectAtIndex:12]).center = CGPointMake(650, 484);
//    ((C4Shape *)[shapes objectAtIndex:13]).center = CGPointMake(550, 284);
//    ((C4Shape *)[shapes objectAtIndex:14]).center = CGPointMake(550, 384);
//    ((C4Shape *)[shapes objectAtIndex:15]).center = CGPointMake(550, 584);
//}
//@end


//#import "CustomShape.h"
//
//C4Shape *blueCircle, *blueSquare, *redCircle, *redSquare;
//CustomShape *transformer;
//CAShapeLayer *aLayer;

//@implementation C4CanvasController
//@synthesize canvas;
//
//-(void)setup {
//    
//    canvas = (C4View *)self.view;
//    
//    aLayer = [CAShapeLayer layer];
//    aLayer.frame = CGRectMake(0, 0, 200, 200);
//    aLayer.path = CGPathCreateWithEllipseInRect(aLayer.frame, nil);
//    aLayer.position = CGPointMake(384, 512);
//    aLayer.lineWidth = 15.0f;
//    aLayer.strokeColor = [UIColor blackColor].CGColor;
//    aLayer.fillColor = [UIColor clearColor].CGColor;
//    [canvas.layer addSublayer:aLayer];
        
//    blueCircle = [C4Shape ellipse:CGRectMake(73, 562, 100, 100)];
//    [canvas addShape:blueCircle];
//    
//    blueSquare = [C4Shape rect:CGRectMake(246, 562, 100, 100)];
//    [canvas addShape:blueSquare];
//    
//    redCircle = [C4Shape ellipse:CGRectMake(419, 562, 100, 100)];
//    redCircle.fillColor = C4RED;
//    redCircle.strokeColor = C4BLUE;
//    [canvas addShape:redCircle];
//    
//    redSquare = [C4Shape rect:CGRectMake(592, 562, 100, 100)];
//    redSquare.fillColor = C4RED;
//    redSquare.strokeColor = C4BLUE;
//    [canvas addShape:redSquare];
//    
//    CustomShape *transformer = [CustomShape new];
//    [transformer ellipse:CGRectMake(284, 262, 200, 200)];
//    transformer.lineWidth = 10.0f;
//    transformer.lineCap = kCALineCapRound;
//    [canvas addShape:transformer];
//    
//    [transformer listenFor:@"touchesBegan" fromObject:blueCircle andRunMethod:@"blueCircle"];
//    [transformer listenFor:@"touchesBegan" fromObject:blueSquare andRunMethod:@"blueSquare"];
//    [transformer listenFor:@"touchesBegan" fromObject:redCircle andRunMethod:@"redCircle"];
//    [transformer listenFor:@"touchesBegan" fromObject:redSquare andRunMethod:@"redSquare"];
//}

//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    CGPathRef newPath = CGPathCreateWithRect(aLayer.bounds, nil);
//    [CATransaction lock];
//    [CATransaction begin];
//    [CATransaction setAnimationDuration:2.5f];
//    CABasicAnimation *ba = [CABasicAnimation animationWithKeyPath:@"path"];
//    ba.autoreverses = YES;
//    ba.fillMode = kCAFillModeForwards;
//    ba.repeatCount = HUGE_VALF;
//    ba.fromValue = (id)aLayer.path;
//    ba.toValue = (__bridge id)newPath;
//    [aLayer addAnimation:ba forKey:@"animatePath"];
//    [CATransaction commit];
//    [CATransaction unlock];
//}
//@end