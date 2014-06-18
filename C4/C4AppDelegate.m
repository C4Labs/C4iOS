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

#import "C4AppDelegate.h"
#import "C4AssertionHandler.h"

@implementation C4AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[[NSThread currentThread] threadDictionary] setValue:[C4AssertionHandler class] forKey:NSAssertionHandlerKey];
    // NB: your windowing code goes here - e.g. self.window.rootViewController = self.viewController;
    
    application.statusBarHidden = YES;
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.workspace = [[C4WorkSpace alloc] init];
    _window.rootViewController = self.workspace;
    
    [self.window makeKeyAndVisible];
    
    //strangely, if the following call to set the background color isn't made, then the view doesn't receive touch events...
    self.workspace.view.backgroundColor = [UIColor whiteColor];
    
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.workspace setup];
    return YES;
}

+ (void)initialize {
    //set these before everything else.
    C4Control* controlStyle = [C4Control defaultTemplateProxy];
    controlStyle.alpha = 1.0f;
    controlStyle.animationDuration = 0.0f;
    controlStyle.animationDelay = 0.0f;
    controlStyle.animationOptions = BEGINCURRENT;
    controlStyle.backgroundColor = [UIColor clearColor];
    controlStyle.cornerRadius = 0.0f;
    controlStyle.shadowColor = C4GREY;
    controlStyle.shadowOpacity = 0.0f;
    controlStyle.shadowOffset = CGSizeZero;
    
    [C4ActivityIndicator defaultTemplateProxy].color = C4BLUE;
    
    [C4Button defaultTemplateProxy].tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkBluePattern"]];
    
    [C4Label defaultTemplateProxy].textColor = C4GREY;
    [C4Label defaultTemplateProxy].highlightedTextColor = C4RED;
    [C4Label defaultTemplateProxy].backgroundColor = [UIColor clearColor];
    
    C4Shape* shapeStyle = [C4Shape defaultTemplateProxy];
    shapeStyle.fillColor = C4GREY;
    shapeStyle.fillRule = FILLNORMAL;
    shapeStyle.lineCap = CAPBUTT;
    shapeStyle.lineDashPattern = nil;
    shapeStyle.lineDashPhase = 0.0f;
    shapeStyle.lineJoin = JOINMITER;
    shapeStyle.lineWidth = 5.0f;
    shapeStyle.miterLimit = 10.0f; //this doesn't like being set here...
    shapeStyle.strokeColor = C4BLUE;
    shapeStyle.strokeEnd = 1.0f;
    shapeStyle.strokeStart = 0.0f;
    
    [C4Slider defaultTemplateProxy].thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkBluePattern"]];
    [C4Slider defaultTemplateProxy].minimumTrackTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];
    [C4Slider defaultTemplateProxy].maximumTrackTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];
    
    [C4Stepper defaultTemplateProxy].tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];
    [[C4Stepper defaultTemplateProxy] setDecrementImage:[C4Image imageNamed:@"decrementDisabled"] forState:DISABLED];
    [[C4Stepper defaultTemplateProxy] setDecrementImage:[C4Image imageNamed:@"decrementNormal"] forState:NORMAL];
    [[C4Stepper defaultTemplateProxy] setIncrementImage:[C4Image imageNamed:@"incrementDisabled"] forState:DISABLED];
    [[C4Stepper defaultTemplateProxy] setIncrementImage:[C4Image imageNamed:@"incrementNormal"] forState:NORMAL];
    
    [C4Switch defaultTemplateProxy].onTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightBluePattern"]];
    [C4Switch defaultTemplateProxy].tintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightRedPattern"]];
    [C4Switch defaultTemplateProxy].thumbTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"lightGrayPattern"]];
    [[C4Switch defaultTemplateProxy] setOffImage:[C4Image imageNamed:@"switchOff"]];
    [[C4Switch defaultTemplateProxy] setOnImage:[C4Image imageNamed:@"switchOn"]];
}

@end
