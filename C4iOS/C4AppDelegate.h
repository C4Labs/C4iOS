//
//  AppDelegate.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface C4AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) IBOutlet C4Window *window;

@property (strong, nonatomic) C4CanvasController *canvasController;

@end