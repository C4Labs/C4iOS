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

#import "C4Control.h"

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
+ (instancetype)ellipse:(CGRect)rect;

/**Creates and returns an instance of C4Shape, whose path is a rectangle.
 
 @param rect A rectangle that defines the shape.
 @return The initialized C4Shape object created with an rectangular path or nil if initialization is not successful.
 */
+ (instancetype)rect:(CGRect)rect;

/**Creates and returns an instance of C4Shape, whose path is a line.
 
 @warning *Note:* Lines are the only shape objects which are not touchable, draggable, etc.
 
 @param pointArray A C-Array containing 2 CGPoints like: {CGpoint,CGPoint}.
 @return The initialized C4Shape object created with a line path or nil if initialization is not successful.
 */
+ (instancetype)line:(CGPoint *)pointArray;

/**Creates and returns an instance of C4Shape, whose path is a triangle.
 
 @param pointArray A C-Array containing 3 CGPoints like: {CGpoint,CGPoint,CGPoint}.
 @return The initialized C4Shape object created with a triangle path or nil if initialization is not successful.
 */
+ (instancetype)triangle:(CGPoint *)pointArray;

/**Creates and returns an instance of C4Shape, whose path is a polygon.
 
 This method requires a secondary variable, called pointCount, because the length of the C-Array is unknown once it is passed to the method.
 
 @param pointArray A C-Array containing any number of CGPoints like: {CGpoint, .. , CGPoint}.
 @param pointCount The number of points in the array.
 @return The initialized C4Shape object created with a polygon path or nil if initialization is not successful.
 */
+ (instancetype)polygon:(CGPoint *)pointArray pointCount:(NSInteger)pointCount;

/**Creates and returns an instance of C4Shape, whose path is an arc.
 
 @param centerPoint The center point of the arc.
 @param radius The radius of the arc.
 @param startAngle The starting angle of the arc, in radians in the range of (0 .. 2*PI)
 @param endAngle The ending angle of the arc, in radians in the range of (0 .. 2*PI)
 @param clockwise A Boolean value specifying whether or not the arc will draw in a clockwise direction from the start to end angle
 @return The initialized C4Shape object created with an arc path or nil if initialization is not successful.
 */
+ (instancetype)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

/**Creates and returns an instance of C4Shape, whose path is a wedge.
 
 @param centerPoint The center point of the wedge.
 @param radius The radius of the wedge.
 @param startAngle The starting angle of the wedge, in radians in the range of (0 .. 2*PI)
 @param endAngle The ending angle of the wedge, in radians in the range of (0 .. 2*PI)
 @param clockwise A Boolean value specifying whether or not the wedge will draw in a clockwise direction from the start to end angle
 @return The initialized C4Shape object created with a wedge path or nil if initialization is not successful.
 */
+ (instancetype)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

/**Creates and returns an instance of C4Shape, whose path is a bezier curve.
 
 @param beginEndPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the beginning and end of the curve.
 @param controlPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the control points that distort the curve.
 @return The initialized C4Shape object created with a curve path or nil if initialization is not successful.
 */
+ (instancetype)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;


/**Creates and returns an instance of C4Shape, whose path is a quadratic curve
 
 @param beginEndPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the beginning and end of the curve.
 @param controlPoint A CGPoint used to defined the quadratic curve.
 @return The initialized C4Shape object created with a curve path or nil if initialization is not successful.
 */
+ (instancetype)quadCurve:(CGPoint *)beginEndPointArray controlPoint:(CGPoint)controlPoint;

/**Creates and returns an instance of C4Shape, whose path is a combination of curves made up from a string of text.
 
 @param string The string to turn into a shape.
 @param font The font used to generate the paths that will be drawn.
 @return The initialized C4Shape object created with a combination of paths that look like characters or nil if initialization is not successful.
 */
+ (instancetype)shapeFromString:(NSString *)string withFont:(C4Font *)font;

/**Creates and returns an instance of C4Shape, whose configuration is specified by a template.
 
 @param template The template to use.
 */
+ (instancetype)shapeFromTemplate:(C4Template*)template;

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
 @param clockwise A Boolean value specifying whether or not the arc will draw in a clockwise direction from the start to end angle
 @param endAngle The ending angle of the arc, in radians in the range of (0 .. 2*PI)
 */
-(void)arcWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

/**Changes the object's current shape to a wedge
 
 The change will happen based on the shape's current animation options, duration and delay.
 
 @param centerPoint The center point of the wedge.
 @param radius The radius of the wedge.
 @param startAngle The starting angle of the wedge, in radians in the range of (0 .. 2*PI)
 @param clockwise A Boolean value specifying whether or not the wedge will draw in a clockwise direction from the start to end angle
 @param endAngle The ending angle of the wedge, in radians in the range of (0 .. 2*PI)
 */
-(void)wedgeWithCenter:(CGPoint)centerPoint radius:(CGFloat)radius startAngle:(CGFloat)startAngle endAngle:(CGFloat)endAngle clockwise:(BOOL)clockwise;

/**Changes the object's current shape to a curve
 
 The change will happen based on the shape's current animation options, duration and delay.
 
 @param beginEndPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the beginning and end of the curve.
 @param controlPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the control points that distort the curve.
 */
-(void)curve:(CGPoint *)beginEndPointArray controlPoints:(CGPoint *)controlPointArray;

/**Changes the object's current shape to a quadratic curve
 
 The change will happen based on the shape's current animation options, duration and delay.
 
 @param beginEndPointArray A C-Array consisting of two points, like: {CGPoint,CGPoint}, which mark the beginning and end of the curve.
 @param controlPoint A CGPoint used to defined the quadratic curve.
 */
-(void)quadCurve:(CGPoint *)beginEndPointArray controlPoint:(CGPoint)controlPoint;

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
@property(nonatomic, strong) UIColor *fillColor;

/**The color used to stroke the shape’s path. Animatable.
 
 Setting strokeColor to nil results in no stroke being rendered.
 
 Default is nil.
 */
@property(nonatomic, strong) UIColor *strokeColor;

/**The dash phase applied to the shape’s path when stroked. Animatable.
 
 Line dash phase specifies how far into the dash pattern the line starts.
 
 Default is 0.
 */
@property(nonatomic) CGFloat lineDashPhase;

/**Specifies the line width of the shape’s path. Animatable.
 */
@property(nonatomic) CGFloat lineWidth;

/**The miter limit used when stroking the shape’s path. Animatable.
 
 If the current line join style is set to JOINMITER (see lineJoin), the miter limit determines whether the lines should be joined with a bevel instead of a miter. The length of the miter is divided by the line width. If the result is greater than the miter limit, the path is drawn with a bevel.
 
 Default is 10.0.
 */
@property(nonatomic) CGFloat miterLimit;

/**The relative location at which to stop stroking the path. Animatable.
 
 @property CGFloat strokeEnd
 
 The value of this property must be in the range 0.0 to 1.0. The default value of this property is 1.0.
 
 Combined with the strokeStart property, this property defines the subregion of the path to stroke. The value in this property indicates the relative point along the path at which to finish stroking while the strokeStart property defines the starting point. A value of 0.0 represents the beginning of the path while a value of 1.0 represents the end of the path. Values in between are interpreted linearly along the path length.
 
 */
@property(nonatomic) CGFloat strokeEnd;

/**The relative location at which to begin stroking the path. Animatable.
 
 The value of this property must be in the range 0.0 to 1.0. The default value of this property is 0.0.
 
 Combined with the strokeEnd property, this property defines the subregion of the path to stroke. The value in this property indicates the relative point along the path at which to begin stroking while the strokeEnd property defines the end point. A value of 0.0 represents the beginning of the path while a value of 1.0 represents the end of the path. Values in between are interpreted linearly along the path length.
 */
@property(nonatomic) CGFloat strokeStart;

/**The dash pattern applied to the shape’s path when stroked.
 
 The dash pattern is specified as an array of NSNumber objects that specify the lengths of the painted segments and unpainted segments, respectively, of the dash pattern.
 
 For example, passing an array with the values {2,3} sets a dash pattern that alternates between a 2-user-space-unit-long painted segment and a 3-user-space-unit-long unpainted segment. Passing the values {1,3,4,2} sets the pattern to a 1-unit painted segment, a 3-unit unpainted segment, a 4-unit painted segment, and a 2-unit unpainted segment.
 
 Default is nil, a solid line.
 */
@property(nonatomic, copy) NSArray *lineDashPattern;

/**The fill rule used when filling the shape’s path.
 
 The possible values are FILLNORMAL and FILLNONZERO which are equivalent to Cocoa's default winding mode values. See “Winding Rules” in Cocoa Drawing Guide for examples of the two fill rules.
 */
@property(nonatomic, copy) NSString *fillRule;

/**Specifies the line cap style for the shape’s path.
 
 The line cap style specifies the shape of the endpoints of an open path when stroked. The supported values are described in “Line Cap Values.”
 
 The possible values are: CAPBUTT, CAPROUND and CAPSQUARE which are equivalent to Cocoa's default line cap values.
 
 The default is CAPBUTT.
 */
@property(nonatomic, copy) NSString *lineCap;

/**Specifies the line join style for the shape’s path.
 
 The line join style specifies the shape of the joints between connected segments of a stroked path. The supported values are JOINMITER, JOINROUND, JOINBEVEL which are equivalent to Cocoa's default line join values.
 
 The default is JOINMITRE.
 */
@property(nonatomic, copy) NSString *lineJoin;

/**Specifies whether or not the shape is a line.
 */
@property(nonatomic, readonly, getter = isLine) BOOL line;

/**Specifies whether or not the shape is an arc.
 */
@property(nonatomic, readonly, getter = isArc) BOOL arc;

/**Specifies the origin point of a line. Animatable.
 */
@property(nonatomic) CGPoint pointA;

/**Specifies the end point of a line. Animatable.
 */
@property(nonatomic) CGPoint pointB;

/**Specifies the first control point of a curve, both bezier and quad curves. Animatable.
 */
@property(nonatomic) CGPoint controlPointA;

/**Specifies the second control point (bezier curves only). Animatable.
 */
@property(nonatomic) CGPoint controlPointB;

/**Specifies whether the given shape is closed or not. This is useful for determining if polygons are open or closed.
 */
@property(nonatomic, readonly, getter = isClosed) BOOL closed;

/**Specifies whether the given shape is a wedge.
 
 This property is specifically used in the `pointA` and `pointB` methods to determine if the current object is capable of setting them. In particular, only lines, beziers and quadratic curves should be able to acces the `pointA` and `pointB` properties of the `C4Shape` class.
 */
@property(nonatomic, readonly, getter = isWedge) BOOL wedge;

/**Specifies whether the given shape is a bezier curve.
 
 This property is specifically used in the `pointA` and `pointB` methods to determine if the current object is capable of setting them. In particular, only lines, beziers and quadratic curves should be able to acces the `pointA` and `pointB` properties of the `C4Shape` class.
 */
@property(nonatomic, readonly, getter = isBezierCurve) BOOL bezierCurve;

/**Specifies whether the given shape is a quadratic curve.
 
 This property is specifically used in the `pointA` and `pointB` methods to determine if the current object is capable of setting them. In particular, only lines, beziers and quadratic curves should be able to acces the `pointA` and `pointB` properties of the `C4Shape` class.
 */
@property(nonatomic, readonly, getter = isQuadCurve) BOOL quadCurve;

/**The path defining the shape to be rendered. Animatable.
 
 Paths will interpolate as a linear blend of the "on-line" points; "off-line" points may be interpolated non-linearly (e.g. to preserve continuity of the curve's derivative). If the two paths have a different number of control points or segments the results are undefined. If the path extends outside the layer bounds it will not automatically be clipped to the layer, only if the normal layer masking rules cause that.
 
 If the value in this property is non-nil, the path is created using the specified path instead of the layer’s composited alpha channel. The path defines the outline of the shape layer. It is filled using the non-zero winding rule and the current color, opacity, and blur radius.
 
 Specifying an explicit path usually improves rendering performance.
 */
@property(nonatomic) CGPathRef path;

@end
