//
//  AppDelegate.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4AppDelegate.h"
#import "C4ScrollView.h"

@interface C4AppDelegate ()
/* The main view of the application.
  
 Need to have this in here so that we can associate the CAZZ4View in our C4Canvas.xib file with something. The main reason is that a static lib will discard and not recognize any class that isn't called or referenced in some part of some implementation.
                         */
@property (readonly, nonatomic, weak) C4View *mainView;
@property (readwrite, nonatomic, strong) C4ScrollView *scrollView;
@end

@implementation C4AppDelegate

@synthesize window = _window;
@synthesize workspace = _workspace;
@synthesize mainView;
@synthesize scrollView = _scrollView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.statusBarHidden = YES;
    self.window = [[C4Window alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.scrollView = [[C4ScrollView alloc] initWithFrame:self.window.frame];
    
//    self.workspace = [[C4WorkSpace alloc] initWithNibName:@"C4Canvas" bundle:nil];
    self.workspace = [[C4WorkSpace alloc] init];
//    CGSize bigSize = self.window.frame.size;
//    bigSize.width *= 4;
//    bigSize.height *= 4;
//    CGRect bigFrame = self.window.frame;
//    bigFrame.size = bigSize;
//    
//    C4View *mainCanvas = [[C4View alloc] initWithFrame:bigFrame];
    C4View *mainCanvas = [[C4View alloc] initWithFrame:self.window.frame];
    
    self.scrollView.minimumZoomScale = 1.0;
    self.scrollView.maximumZoomScale = 10.0;
    self.scrollView.delegate = self;
    
    self.workspace.view = mainCanvas;
    

    _window.rootViewController = self.workspace;
    [self.scrollView addSubview:self.workspace.view];
    
    [self.window addSubview:self.scrollView];
    /* don't ever do the following !
     self.canvasController.view = self.window;
     */
    
    [self.window makeKeyAndVisible];
    
    //strangely, if the following call to set the background color isn't made, then the view doesn't receive touch events...
    self.workspace.view.backgroundColor = [UIColor whiteColor]; 
    [(AVAudioSession*)[AVAudioSession sharedInstance] setDelegate:self.workspace];
    [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategorySoloAmbient error: nil];
    [self.workspace setup];
    mainView = (C4View *)self.workspace.view;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

-(void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.workspace.view;
}

@end
