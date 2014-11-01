// Copyright © 2014 C4
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

import QuartzCore

/// Rules for determining the region of a path that gets filled with color.
public enum FillRule {
    /**
    Specifies the non-zero winding rule. Count each left-to-right path as +1 and each right-to-left path as -1. If the
    sum of all crossings is 0, the point is outside the path. If the sum is nonzero, the point is inside the path and
    the region containing it is filled.
    */
    case NonZero
    
    /**
    Specifies the even-odd winding rule. Count the total number of path crossings. If the number of crossings is even,
    the point is outside the path. If the number of crossings is odd, the point is inside the path and the region
    containing it should be filled.
    */
    case EvenOdd
}


/**
A Path is a sequence of geometric segments which can be straight lines or curves.
*/
@IBDesignable
public class Path: Equatable {
    internal var internalPath: CGMutablePathRef = CGPathCreateMutable()
    
    public init() {
        internalPath = CGPathCreateMutable()
    }
    
    internal init(path: CGMutablePathRef) {
        internalPath = path
    }
    
    /// Determine if the path is empty
    public func isEmpty() -> Bool {
        return CGPathIsEmpty(internalPath)
    }
    
    /**
    Return the path bounding box. The path bounding box is the smallest rectangle completely enclosing all points
    in the path, *not* including control points for Bézier cubic and quadratic curves. If the path is empty, then
    return `CGRectNull`.
    */
    public func boundingBox() -> CGRect {
        return CGPathGetPathBoundingBox(internalPath)
    }
    
    /**
    Return true if `point` is contained in `path`; false otherwise. A point is contained in a path if it is inside the
    painted region when the path is filled; if `fillRule` is `EvenOdd`, then the even-odd fill rule is used to evaluate
    the painted region of the path, otherwise, the winding-number fill rule is used.
    */
    public func containsPoint(point: CGPoint, fillRule: FillRule = .NonZero) -> Bool {
        return CGPathContainsPoint(internalPath, nil, point, fillRule == .EvenOdd)
    }
    
    /// Create a copy of the path
    public func copy() -> Path {
        return Path(path: CGPathCreateMutableCopy(internalPath))
    }
}

/// Determine if two paths are equal
public func == (left: Path, right: Path) -> Bool {
    return CGPathEqualToPath(left.internalPath, right.internalPath)
}

extension Path {
    /**
    Return the current point of the current subpath.
    */
    public var currentPoint: CGPoint {
        get {
            return CGPathGetCurrentPoint(internalPath)
        }
        set(point) {
            moveToPoint(point)
        }
    }
    
    /**
    Move the current point of the current subpath.
    */
    public func moveToPoint(point: CGPoint) {
        CGPathMoveToPoint(internalPath, nil, point.x, point.y)
    }
    
    /**
    Append a straight-line segment fron the current point to `point` and move the current point to `point`.
    */
    public func addLineToPoint(point: CGPoint) {
        CGPathAddLineToPoint(internalPath, nil, point.x, point.y)
    }
    
    /**
    Append a quadratic curve from the current point to `point` with control point `control` and move the current
    point to `point`.
    */
    public func addQuadCurveToPoint(#control: CGPoint, point: CGPoint) {
        CGPathAddQuadCurveToPoint(internalPath, nil, control.x, control.y, point.x, point.y)
    }
    
    /**
    Append a cubic Bézier curve from the current point to `point` with control points `control1` and `control2`
    and move the current point to `point`.
    */
    public func addCurveToPoint(control1: CGPoint, control2: CGPoint, point: CGPoint) {
        CGPathAddCurveToPoint(internalPath, nil, control1.x, control1.y, control2.x, control2.y, point.x, point.y)
    }
    
    /**
    Append a line from the current point to the starting point of the current subpath and end the subpath.
    */
    public func closeSubpath() {
        CGPathCloseSubpath(internalPath)
    }
    
    /**
    Add a rectangle to the path.
    */
    public func addRect(rect: CGRect) {
        CGPathAddRect(internalPath, nil, rect)
    }
    
    /**
    Add a rounded rectangle to the path. The rounded rectangle coincides with the edges of `rect`. Each corner consists
    of one-quarter of an ellipse with axes equal to `cornerWidth` and `cornerHeight`. The rounded rectangle forms a
    complete subpath of the path --- that is, it begins with a "move to" and ends with a "close subpath" --- oriented
    in the clockwise direction.
    */
    public func addRoundedRect(rect: CGRect, cornerWidth: CGFloat, cornerHeight: CGFloat) {
        CGPathAddRoundedRect(internalPath, nil, rect, cornerWidth, cornerHeight)
    }
    
    /**
    Add an ellipse (an oval) inside `rect`. The ellipse is approximated by a sequence of Bézier curves. The center of
    the ellipse is the midpoint of `rect`. If `rect` is square, then the ellipse will be circular with radius equal to
    one-half the width (equivalently, one-half the height) of `rect`. If `rect` is rectangular, then the major- and
    minor-axes will be the width and height of `rect`. The ellipse forms a complete subpath --- that is, it begins with
    a "move to" and ends with a "close subpath" --- oriented in the clockwise direction. 
    */
    public func addEllipse(rect: CGRect) {
        CGPathAddEllipseInRect(internalPath, nil, rect)
    }
    
    /**
    Add an arc of a circle, possibly preceded by a straight line segment. The arc is approximated by a sequence of
    Bézier curves.
    
    :center:     The center of the arc.
    :radius:     The radius of the arc.
    :startAngle: The angle in radians to the first endpoint of the arc, measured counter-clockwise from the positive
                 x-axis.
    :delta:      The angle between `startAngle` and the second endpoint of the arc, in radians. If `delta' is positive,
                 then the arc is drawn counter-clockwise; if negative, clockwise.
    */
    public func addRelativeArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, delta: CGFloat) {
        CGPathAddRelativeArc(internalPath, nil, center.x, center.y, radius, startAngle, delta)
    }
    
    /**
    Add an arc of a circle, possibly preceded by a straight line segment. The arc is approximated by a sequence of
    Bézier curves.
    
    Note that using values very near 2π can be problematic. For example, setting `startAngle` to 0, `endAngle` to 2π,
    and `clockwise` to true will draw nothing. (It's easy to see this by considering, instead of 0 and 2π, the values
    ε and 2π - ε, where ε is very small.) Due to round-off error, however, it's possible that passing the value
    `2 * M_PI` to approximate 2π will numerically equal to 2π + δ, for some small δ; this will cause a full circle to
    be drawn.
    
    If you want a full circle to be drawn clockwise, you should set `startAngle` to 2π, `endAngle` to 0, and
    `clockwise` to true. This avoids the instability problems discussed above.
    
    :center:     The center of the arc.
    :radius:     The radius of the arc.
    :startAngle: The angle to the first endpoint of the arc in radians.
    :endAngle:   The angle to the second endpoint of the arc.
    :clockwise:  If true the arc is drawn clockwise.

    */
    public func addArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) {
        CGPathAddArc(internalPath, nil, center.x, center.y, radius, startAngle, endAngle, clockwise)
    }
    
    /**
    Add an arc of a circle, possibly preceded by a straight line segment. The arc is approximated by a sequence of
    Bézier curves. The resulting arc is tangent to the line from the current point to `point1`, and the line from
    `point1` to `point2`.
    */
    public func addArcToPoint(point1: CGPoint, point2: CGPoint, radius: CGFloat) {
        CGPathAddArcToPoint(internalPath, nil, point1.x, point1.y, point2.x, point2.y, radius)
    }
    
    /**
    Append a path.
    */
    public func addPath(path: Path) {
        CGPathAddPath(internalPath, nil, path.internalPath)
    }
    
    public var CGPath: CGPathRef {
        get {
            return internalPath
        }
    }
}
