//
//  C4ShapeView.h
//  C4iOS
//
//  Created by Travis Kirton on 12-02-14.
//  Copyright (c) 2012 POSTFL. All rights reserved.
//

#import "C4ShapeLayer.h"

/**The C4Shape class implements a modifiable view that handles shapes. You can use this class to create almost any kind of basic shape, as well as more complicated polygons.
 
 C4Shape is a subclass of C4Control and inherits all its gesture, animation and notification abilities.
 
 This is the class that you should use to construct and add any shapes to C4's canvas.
 
 In C4, the main role of C4Shape is to provide access to constructing and manipulating the appearance of shapes. Almost all properties of shapes are animatable. The main goal for a C4Shape is to provide interactivity while encapsulating all the methods that act on its underlying shape layer.
*/

@interface C4Shape : C4Control {
}

#pragma mark Changing a Shape's Path
/// @name Creating Shapes

/**Creates and returns an instance of C4Shape, whose path is an ellipse.
 
 @param rect A rectangle that defines the shape of an ellipse.
 @return The initialized C4Shape object created with an ellipse path or nil if initialization is not successful.
 */
+(C4Shape *)ellipse:(CGRect)rect;

/**Creates and returns an instance of C4Shape, whose path is a rectangle.
 
 @param rect A rectangle that defines the shape.
 @return The initialized C4Shape object created with an rectangular path or nil if initialization is not successful.
 */
+(C4Shape *)rect:(CGRect)rect;

/**Creates and returns an instance of C4Shape, whose path is a line.
 
 @warning *Note:* Lines are the only shape objects which are not touchable, draggable, etc.
 
 @param pointArray A C-Array containing 2 CGPoints like: {CGpoint,CGPoint}.
 @return The initialized C4Shape object created with a line path or nil if initialization is not successful.
 */
+(C4Shape *)line:(CGPoint *)pointArray;

/**Creates and returns an instance of C4Shape, whose path is a triangle.

 @param pointArray A C-Array containing 3 CGPoints like: {CGpoint,CGPoint,CGPoint}.
 @return The initialized C4Shape object created with a triangle path or nil if initialization is not successful.
 */
+(C4Shape *)triangle:(CGPoint *)pointArray;

/**Creates and returns an instance of C4Shape, whose path is a polygon.
 
 This method requires a secondary variable, called pointCount, because the length of the C-Array is unknown once it is passed to the method. 
 
 @param pointArray A C-Array containing any number of CGPoints like: {CGpoint, .. , CGPoint}.
 @param pointCount The number of points in the array.
 @return The initialized C4Shape object created with a polygon path or nil if initialization is not successful.
 */
+(C4Shape *)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount;

/**Creates and returns an instance of C4Shape, whose path is an arc.
 
 @param centerPoint The center point of the arc.
 @param radius The radius of the arc.
 @param startAngle The starting angle of the arc, in radians in the range of (0 .. 2*PI)
 @param endAngle The ending angle of the arc, in radians in the range of (0 .. 2*PI)
 @return The initialized C4Shape object created with an arc path or nil if initialization is not successful.
 */
+(C4Shape *)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;

/**Creates and returns an instance of C4Shape, whose path is an arc.
 
 @param beginEndPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the beginning and end of the curve.
 @param controlPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the control points that distort the curve.
 @return The initialized C4Shape object created with a curve path or nil if initialization is not successful.
 */
+(C4Shape *)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;

/**Creates and returns an instance of C4Shape, whose path is a combination of curves made up from a string of text.
 
 @param string The string to turn into a shape.
 @param font The font used to generate the paths that will be drawn.
 @return The initialized C4Shape object created with a combination of paths that look like characters or nil if initialization is not successful.
 */
+(C4Shape *)shapeFromString:(NSString *)string withFont:(C4Font *)font;


#pragma mark Changing a Shape's Path
/// @name Changing a Shape's Path

/**Changes the object's current shape to an ellipse

The change will happen based on the shape's current animation options, duration and delay.
 @param rect A rectangle that defines the shape of an ellipse.
*/
-(void)ellipse:(CGRect)rect;

/**Changes the object's current shape to a rectangle
 
The change will happen based on the shape's current animation options, duration and delay. 

 @param rect A rectangle that defines the shape.
 */
-(void)rect:(CGRect)rect;

/**Changes the object's current shape to a line
 
The change will happen based on the shape's current animation options, duration and delay. 

 @param pointArray A C-Array containing 2 CGPoints like: {CGpoint,CGPoint}.
 */
-(void)line:(CGPoint *)pointArray;

/**Changes the object's current shape to a triangle
 
The change will happen based on the shape's current animation options, duration and delay. 

 @param pointArray A C-Array containing 3 CGPoints like: {CGpoint,CGPoint,CGPoint}.
 */
-(void)triangle:(CGPoint *)pointArray;

/**Changes the object's current shape to a polygon
 
The change will happen based on the shape's current animation options, duration and delay. 

 @param pointArray A C-Array containing any number of CGPoints like: {CGpoint, .. , CGPoint}.
 @param pointCount The number of points in the array.
 */
-(void)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount;

/**Changes the object's current shape to an arc
 
The change will happen based on the shape's current animation options, duration and delay. 

 @param centerPoint The center point of the arc.
 @param radius The radius of the arc.
 @param startAngle The starting angle of the arc, in radians in the range of (0 .. 2*PI)
 @param endAngle The ending angle of the arc, in radians in the range of (0 .. 2*PI)
 */
-(void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle;

/**Changes the object's current shape to a curve
 
The change will happen based on the shape's current animation options, duration and delay. 

 @param beginEndPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the beginning and end of the curve.
 @param controlPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the control points that distort the curve.
 */
-(void)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;

/**Changes the object's current shape to one made from the paths of a given string
 
The change will happen based on the shape's current animation options, duration and delay. 

 @param string The string to turn into a shape.
 @param font The font used to generate the paths that will be drawn.
 */
-(void)shapeFromString:(NSString *)string withFont:(C4Font *)font;

/**Closes the path of a shape that currently does not have a line from its last point to its beginning point.
 
 When a polygon is created, the last point and first point are not connected. This method connects them.
 
 You cannot undo this action (i.e. there is no openShape method)
*/
-(void)closeShape;

/**Sets the dash pattern for the shape's line.
 
 When call this method the line for the shape will change to have a pattern rather than appear solid.
 
 The change will happen based on the shape's current animation options, duration and delay.
 
 @param dashPattern A C-Array of float values, like {5, 10, 15, 20} to use as the distances for gaps and dashes.
 @param pointCount The number of values in the dashPattern.
 */
-(void)setDashPattern:(CGFloat *)dashPattern pointCount:(NSUInteger)pointCount;

#pragma mark Properties
/// @name Properties

/**The color used to fill the shape’s path. Animatable.
 
 Setting fillColor to nil results in no fill being rendered.
 
 Default is C4BLUE.
 */
@property (readwrite, strong, nonatomic) UIColor *fillColor;

/**The color used to stroke the shape’s path. Animatable.
 
 Setting strokeColor to nil results in no stroke being rendered.
 
 Default is nil.
 */
@property (readwrite, strong, nonatomic) UIColor *strokeColor;

/**The color used to stroke the shape’s shadow. Animatable.
 
 Setting shadowColor to nil results in no shadow being rendered.
 
 Default is nil.

 */
@property (readwrite, strong, nonatomic) UIColor *shadowColor;

/**The dash phase applied to the shape’s path when stroked. Animatable.
 
 Line dash phase specifies how far into the dash pattern the line starts.
 
 Default is 0.
 */
@property (readwrite, nonatomic) CGFloat lineDashPhase;

/**Specifies the line width of the shape’s path. Animatable.
 */
@property (readwrite, nonatomic) CGFloat lineWidth;

/**The miter limit used when stroking the shape’s path. Animatable.
 
 If the current line join style is set to JOINMITER (see lineJoin), the miter limit determines whether the lines should be joined with a bevel instead of a miter. The length of the miter is divided by the line width. If the result is greater than the miter limit, the path is drawn with a bevel.
 
 Default is 10.0.
 */
@property (readwrite, nonatomic) CGFloat miterLimit;

/**The relative location at which to stop stroking the path. Animatable.
 
 @property CGFloat strokeEnd
 
 The value of this property must be in the range 0.0 to 1.0. The default value of this property is 1.0.
 
 Combined with the strokeStart property, this property defines the subregion of the path to stroke. The value in this property indicates the relative point along the path at which to finish stroking while the strokeStart property defines the starting point. A value of 0.0 represents the beginning of the path while a value of 1.0 represents the end of the path. Values in between are interpreted linearly along the path length.
 
 */
@property (readwrite, nonatomic) CGFloat strokeEnd;

/**The relative location at which to begin stroking the path. Animatable.
 
    The value of this property must be in the range 0.0 to 1.0. The default value of this property is 0.0.
 
 Combined with the strokeEnd property, this property defines the subregion of the path to stroke. The value in this property indicates the relative point along the path at which to begin stroking while the strokeEnd property defines the end point. A value of 0.0 represents the beginning of the path while a value of 1.0 represents the end of the path. Values in between are interpreted linearly along the path length.
 */
@property (readwrite, nonatomic) CGFloat strokeStart;

/**Specifies the opacity of the receiver’s shadow. Animatable.
 
 The value of this property must be in the range 0.0 to 1.0. The default value of this property is 0.0.
 */
@property (readwrite, nonatomic) CGFloat shadowOpacity;

/**Specifies the blur radius used to render the receiver’s shadow. Animatable.
 
 The value of this property must be in the range 0.0 to 1.0. The default value of this property is 0.0.
 */
@property (readwrite, nonatomic) CGFloat shadowRadius;

/**
 */
@property (readwrite, nonatomic) CGSize shadowOffset;

/**Defines the shape of the shadow. Animatable.
 
 Unlike most animatable properties, shadowPath does not support implicit animation. 
 
 If the value in this property is non-nil, the shadow is created using the specified path instead of the layer’s composited alpha channel. The path defines the outline of the shadow. It is filled using the non-zero winding rule and the current shadow color, opacity, and blur radius.
 
 Specifying an explicit path usually improves rendering performance.
 
 The default value of this property is NULL.
 */
@property (readwrite, nonatomic) CGPathRef shadowPath;

/**The dash pattern applied to the shape’s path when stroked.
 
 The dash pattern is specified as an array of NSNumber objects that specify the lengths of the painted segments and unpainted segments, respectively, of the dash pattern.
 
 For example, passing an array with the values {2,3} sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment. Passing the values {1,3,4,2} sets the pattern to a 1-unit painted segment, a 3-unit unpainted segment, a 4-unit painted segment, and a 2-unit unpainted segment.
 
 Default is nil, a solid line.
 */
@property (readwrite, strong, nonatomic) NSArray *lineDashPattern;

/**The fill rule used when filling the shape’s path.
 
 The possible values are FILLNORMAL and FILLNONZERO which are equivalent to Cocoa's default winding mode values. See “Winding Rules” in Cocoa Drawing Guide for examples of the two fill rules.
  */
@property (readwrite, strong, nonatomic) NSString *fillRule;

/**Specifies the line cap style for the shape’s path.
 
 The line cap style specifies the shape of the endpoints of an open path when stroked. The supported values are described in “Line Cap Values.”
 
 The possible values are: CAPBUTT, CAPROUND and CAPSQUARE which are equivalent to Cocoa's default line cap values.
 
 The default is CAPBUTT.
 */
@property (readwrite, strong, nonatomic) NSString *lineCap;

/**Specifies the line join style for the shape’s path.
 
 The line join style specifies the shape of the joints between connected segments of a stroked path. The supported values are JOINMITER, JOINROUND, JOINBEVEL which are equivalent to Cocoa's default line join values.
 
 The default is JOINMITRE.
 */
@property (readwrite, strong, nonatomic) NSString *lineJoin;

/**Specifies whether or not the shape is a line.
 */
@property (readonly) BOOL isLine;

/**Specifies the origin point of a line. Animatable.
 */
@property (readwrite, nonatomic) CGPoint pointA;

/**Specifies the end point of a line. Animatable.
 */
@property (readwrite, nonatomic) CGPoint pointB;

/**The shape's view backing layer.
 
 C4Shapes are actually views, and have a backing layer. This layer is a C4ShapeLayer which is a subclass of CAShapelayer, allowing for the creation and drawing of bezier paths.
 
 Accessing the shape layer is allowed, but modifying it is not. Changing properties of the shape will automatically inform and apply them to shapeLayer.
 */
@property (readonly, weak) C4ShapeLayer *shapeLayer;

@end
