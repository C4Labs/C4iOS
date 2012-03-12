//
//  ViewController.h
//  C4iOSDevelopment
//
//  Created by Travis Kirton on 11-10-06.
//  Copyright (c) 2011 mediart. All rights reserved.
//

#import <UIKit/UIKit.h>
@class C4Window;

@interface C4CanvasController : UIViewController {
}
-(void)setup;

#pragma mark Adding Objects
/** Adds a C4Shape to the view.
 
 Takes a C4Shape object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Shapes, because if there are special conditions for adding shapes this method will handle those.
 
 @param aShape A C4Shape object.
 */
-(void)addShape:(C4Shape *)shape;

/** Adds a C4Label to the view.
 
 Takes a C4Label object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Labels, because if there are special conditions for adding shapes this method will handle those.
 
 @param aLabel A C4Label object.
 */
-(void)addLabel:(C4Label *)label;

/// @name Setting A View's Origin Point
/** The origin point of the view.
 
 Takes a CGPoint and animates the view's origin position from its current point to the new point.
 
 This method positions the origin point of the current view by calculating the difference between this point and what the view's new center point will be. It then initiates the animation by setting the displaced new center point.
 */

/** Adds a C4GL to the view.
 
 Takes a C4GL object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4GL objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param gl A C4GL object.
 */
-(void)addGL:(C4GL *)gl;

/** Adds a C4Image to the view.
 
 Takes a C4Image object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Image objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param image A C4Image object.
 */
-(void)addImage:(C4Image *)image;

/** Adds a C4Movie to the view.
 
 Takes a C4Movie object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Movie objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param image A C4Movie object.
 */
-(void)addMovie:(C4Movie *)movie;

@property (nonatomic) CGPoint origin;

@property (readonly, strong, nonatomic) C4Window *canvas;
@end