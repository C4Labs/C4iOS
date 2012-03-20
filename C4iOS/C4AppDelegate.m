//
//  AppDelegate.m
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4AppDelegate.h"

@interface C4AppDelegate ()
/* The main view of the application.
  
 Need to have this in here so that we can associate the C4View in our C4Canvas.xib file with something. The main reason is that a static lib will discard and not recognize any class that isn't called or referenced in some part of some implementation.
                         */
@property (readonly, weak, nonatomic) C4View *mainView;
@end

@implementation C4AppDelegate

@synthesize window = _window;
@synthesize workspace = _workspace;
@synthesize mainView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    application.statusBarHidden = YES;
    self.window = [[C4Window alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.workspace = [[C4WorkSpace alloc] initWithNibName:@"C4Canvas" bundle:nil];
    self.window.rootViewController = self.workspace;
    /* don't ever do the following !
     self.canvasController.view = self.window;
     */
    
    [self.window makeKeyAndVisible];
    [[AVAudioSession sharedInstance] setDelegate:self.workspace];
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

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
