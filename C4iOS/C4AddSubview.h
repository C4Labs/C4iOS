//
//  C4AddSubview.h
//  C4iOS
//
//  Created by Travis Kirton on 12-07-15.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import <Foundation/Foundation.h>
@class C4GL;
@class C4Image;
@class C4Label;
@class C4Movie;
@class C4Shape;
@class C4Camera;

/** The C4AddSubview protocol defines a set of methods for adding objects to the canvas and to one another.
 
 All visual objects in C4 conform to this protocol, its purpose is to make sure that the proper method is used for adding a given object to the canvas or to another object.
 */
@protocol C4AddSubview <NSObject>
/** Adds a C4Camera to the view.
 
 Takes a C4Camera object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Objects, because if there are special conditions for adding cameras this method will handle those.
 
 @param camera A C4Camera object.
 */
-(void)addCamera:(C4Camera *)camera;

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

/** Adds a C4Label to the view.
 
 Takes a C4Label object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Labels, because if there are special conditions for adding shapes this method will handle those.
 
 @param aLabel A C4Label object.
 */
-(void)addLabel:(C4Label *)label;

/** Adds a C4Movie to the view.
 
 Takes a C4Movie object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Movie objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param image A C4Movie object.
 */
-(void)addMovie:(C4Movie *)movie;

/** Adds a C4Shape to the view.
 
 Takes a C4Shape object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Shapes, because if there are special conditions for adding shapes this method will handle those.
 
 @param shape A C4Shape object.
 */
-(void)addShape:(C4Shape *)shape;

@end
