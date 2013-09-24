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
 
 @param label A C4Label object.
 */
-(void)addLabel:(C4Label *)label;

/** Adds a C4Movie to the view.
 
 Takes a C4Movie object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Movie objects, because if there are special conditions for adding shapes this method will handle those.
 
 @param movie A C4Movie object.
 */
-(void)addMovie:(C4Movie *)movie;

/** A method for adding multiple objects to the canvas at one time.
 
 This will run the appropriate add method for all C4 objects, and will run the default addSubview for any other objects.
 
 @param array The array of visual objects to remove from their parent view.
 */
-(void)addObjects:(NSArray *)array;

/** Adds a C4Shape to the view.
 
 Takes a C4Shape object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4Shapes, because if there are special conditions for adding shapes this method will handle those.
 
 @param shape A C4Shape object.
 */
-(void)addShape:(C4Shape *)shape;

/** Adds a C4UIElement to the view.
 
 Takes a C4UIElement object and adds it to the view hierarchy.
 
 Use this method instead of addSubview: when adding C4UIElements, because if there are special conditions for adding shapes this method will handle those.
 
 @param object an object that conforms to the C4UIElement protocol.
 */
-(void)addUIElement:(id <C4UIElement> )object;

/** A method to remove another object from its view.
 
 For the object in question, use this method to remove any visible object that was previously added to it as a subview.
 
 @param visualObject the visible object to remove from its parent view
 */
-(void)removeObject:(id)visualObject;

/** A method to remove an array of objects from their view.
 
 This will run the removeObject: method on each object in an array.
 
 @param array The array of visual objects to remove from their parent view
 */
-(void)removeObjects:(NSArray *)array;
@end
