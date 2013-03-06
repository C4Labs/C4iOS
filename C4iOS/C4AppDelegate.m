//
//  AppDelegate.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4AppDelegate.h"
#import "C4AssertionHandler.h"
#import "C4Slider.h"

@interface C4AppDelegate ()
/* The main view of the application.
  
 Need to have this in here so that we can associate the CAZZ4View in our C4Canvas.xib file with something. The main reason is that a static lib will discard and not recognize any class that isn't called or referenced in some part of some implementation.
 */
@property (readonly, nonatomic, weak) C4View *mainView;
@end

@implementation C4AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    launchOptions = launchOptions;

    C4AssertionHandler* customAssertionHandler = [[C4AssertionHandler alloc] init];
	[[[NSThread currentThread] threadDictionary] setValue:customAssertionHandler forKey:NSAssertionHandlerKey];
	// NB: your windowing code goes here - e.g. self.window.rootViewController = self.viewController;
    
    application.statusBarHidden = YES;
    self.window = [[C4Window alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.workspace = [[C4WorkSpace alloc] initWithNibName:@"C4Canvas" bundle:nil];    

    _window.rootViewController = self.workspace;
    /* don't ever do the following !
     self.canvasController.view = self.window;
     */

    [self.window makeKeyAndVisible];
    
    //strangely, if the following call to set the background color isn't made, then the view doesn't receive touch events...
    self.workspace.view.backgroundColor = [UIColor whiteColor];

    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    _mainView = (C4View *)self.workspace.view;

    [self.workspace setup];
    return YES;
}

+(void)initialize {
    //set these before everything else.
    
    [C4Control defaultStyle].alpha = 1.0f;
    [C4Control defaultStyle].animationDuration = 0.0f;
    [C4Control defaultStyle].animationDelay = 0.0f;
    [C4Control defaultStyle].animationOptions = BEGINCURRENT;
    [C4Control defaultStyle].backgroundColor = [UIColor clearColor];
    [C4Control defaultStyle].cornerRadius = 0.0f;
    [C4Control defaultStyle].layer.delegate = self;
    [C4Control defaultStyle].shadowColor = C4GREY;
    [C4Control defaultStyle].shadowOpacity = 0.0f;
    [C4Control defaultStyle].shadowOffset = CGSizeZero;
    [C4Control defaultStyle].repeatCount = 0;

    NSDictionary *basicStyle = @{
    @"alpha":@([C4Control defaultStyle].alpha),
    @"animationDuration":@([C4Control defaultStyle].animationDuration),
    @"animationDelay":@([C4Control defaultStyle].animationDelay),
    @"animationOptions":@([C4Control defaultStyle].animationOptions),
    @"backgroundColor":[C4Control defaultStyle].backgroundColor,
    @"cornerRadius":@([C4Control defaultStyle].cornerRadius),
    @"shadowColor":[C4Control defaultStyle].shadowColor,
    @"shadowOpacity":@([C4Control defaultStyle].shadowOpacity),
    @"shadowOffset":[NSValue valueWithCGSize:[C4Control defaultStyle].shadowOffset],
    @"repeatCount":@([C4Control defaultStyle].repeatCount)
    };
    
    [C4Control defaultStyle].style = basicStyle;
    [C4ActivityIndicator defaultStyle].color = C4BLUE;
    
    [C4Button defaultStyle].style = basicStyle;
    [C4Button defaultStyle].tintColor = C4GREY;
    
    [C4Label defaultStyle].style = basicStyle;
    [C4Label defaultStyle].textColor = C4GREY;
    [C4Label defaultStyle].highlightedTextColor = C4RED;
    [C4Label defaultStyle].backgroundColor = [UIColor clearColor];

    [C4Shape defaultStyle].style = basicStyle;
    [C4Shape defaultStyle].fillColor = C4GREY;
    [C4Shape defaultStyle].fillRule = FILLNORMAL;
    [C4Shape defaultStyle].lineCap = CAPBUTT;
    [C4Shape defaultStyle].lineDashPattern = nil;
    [C4Shape defaultStyle].lineDashPhase = 0.0f;
    [C4Shape defaultStyle].lineJoin = JOINMITER;
    [C4Shape defaultStyle].lineWidth = 5.0f;
    [C4Shape defaultStyle].miterLimit = 5.0f;
    [C4Shape defaultStyle].strokeColor = C4BLUE;
    [C4Shape defaultStyle].strokeEnd = 1.0f;
    [C4Shape defaultStyle].strokeStart = 0.0f;
    
    [C4Slider defaultStyle].style = basicStyle;
    [C4Slider defaultStyle].thumbTintColor = C4BLUE;
    [C4Slider defaultStyle].minimumTrackTintColor = C4RED;
    [C4Slider defaultStyle].maximumTrackTintColor = C4GREY;

    [[C4Stepper defaultStyle] setBackgroundImage:[C4Image imageNamed:@"stepperDisabled"] forState:DISABLED];
    [[C4Stepper defaultStyle] setBackgroundImage:[C4Image imageNamed:@"stepperHighlighted"] forState:HIGHLIGHTED];
    [[C4Stepper defaultStyle] setBackgroundImage:[C4Image imageNamed:@"stepperNormal"] forState:NORMAL];
    [[C4Stepper defaultStyle] setBackgroundImage:[C4Image imageNamed:@"stepperSelected"] forState:SELECTED];
    
    [[C4Stepper defaultStyle] setDividerImage:[C4Image imageNamed:@"dividerNormal"] forLeftSegmentState:NORMAL rightSegmentState:NORMAL];
    [[C4Stepper defaultStyle] setDividerImage:[C4Image imageNamed:@"dividerLeftActive"] forLeftSegmentState:HIGHLIGHTED rightSegmentState:NORMAL];
    [[C4Stepper defaultStyle] setDividerImage:[C4Image imageNamed:@"dividerRightActive"] forLeftSegmentState:NORMAL rightSegmentState:HIGHLIGHTED];
    
    [[C4Stepper defaultStyle] setDividerImage:[C4Image imageNamed:@"dividerDisabled"] forLeftSegmentState:DISABLED rightSegmentState:DISABLED];
    [[C4Stepper defaultStyle] setDividerImage:[C4Image imageNamed:@"dividerLeftDisabled"] forLeftSegmentState:DISABLED rightSegmentState:NORMAL];
    [[C4Stepper defaultStyle] setDividerImage:[C4Image imageNamed:@"dividerRightDisabled"] forLeftSegmentState:NORMAL rightSegmentState:DISABLED];

}

@end
