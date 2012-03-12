//
//  C4Window.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-07.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import <UIKit/UIKit.h>

/**The C4Window class is a subclass of UIWindow. The two principal functions of a window are to provide an area for displaying its views and to distribute events to the views. The window is the root view in the view hierarchy. Typically, there is only one window in an iOS application.

For more information about how to use windows, see View Programming Guide for iOS.
 
 The C4Window is a subclass of UIWindow, which is also a subclass of UIView. Because we cannot create chains of subclasses i.e. C4Window : C4View, the addShape: and addLabel: methods are coded directly into this class for sake of convenience.

 @warning *Note:* in C4 you should never have to worry about constructing windows.
*/
@interface C4Window : UIWindow 
/// @name Adding Object Methods
#pragma mark Adding Objects

/** Adds a C4Shape to the window.
 
 Takes a C4Shape object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Shape objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param shape A C4Shape object.
 */
-(void)addShape:(C4Shape *)shape;

/** Adds a C4Label to the window.
 
 Takes a C4Label object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Label objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param label A C4Label object.
 */

-(void)addLabel:(C4Label *)label;

/** Adds a C4GL to the window.
 
 Takes a C4GL object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4GL objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param gl A C4GL object.
 */
-(void)addGL:(C4GL *)gl;

/** Adds a C4Image to the window.
 
 Takes a C4Image object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Image objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param image A C4Image object.
 */
-(void)addImage:(C4Image *)image;

/** Adds a C4Movie to the window.
 
 Takes a C4Movie object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Movie objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param image A C4Movie object.
 */
-(void)addMovie:(C4Movie *)movie;

/// @name Accessing the Root View Controller
#pragma mark Root View Controller

/** A controller which will be set at the window's root view controller.
 
 This property provides access for setting a C4Window's root view controller. 
 
 The C4CanvasController is a subclass of UIViewController and is the principle object within C4 in which programmers will set up and control their applications.
 
 @warning *Note:* When programming a C4 project the canvasController is preset. This shouldn't change unless the entire project structure is changing.
  */
@property (readwrite, strong) C4CanvasController *canvasController;
@end
