//
//  AppDelegate.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

/** This document describes the basic C4AppDelegate, a subclass of UIResponder which conforms to the UIApplicationDelegate protocol.
 
 The C4AppDelegate class is used to define the main window of an application as a C4Window, and to specify the a canvas controller of the C4CanvasController type (rather than the defaults for both).
 */

@interface C4AppDelegate : UIResponder <UIApplicationDelegate>

/** The main application window.

 @return C4Window a subclass of UIWindow customized specifically for the C4 Framework
 */
@property (strong, nonatomic) IBOutlet C4Window *window;

/** The root view controller of the main application window.
 
 @return C4CanvasController a subclass of UIViewController customized specifically for the C4 Framework
 */
@property (strong, nonatomic) C4CanvasController *canvasController;

@end