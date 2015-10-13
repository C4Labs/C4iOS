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
    
    /// Specifies the non-zero winding rule. Count each left-to-right path as +1 and each right-to-left path as -1. If the
    /// sum of all crossings is 0, the point is outside the path. If the sum is nonzero, the point is inside the path and
    /// the region containing it is filled.
    case NonZero
    
    /// Specifies the even-odd winding rule. Count the total number of path crossings. If the number of crossings is even,
    /// the point is outside the path. If the number of crossings is odd, the point is inside the path and the region
    /// containing it should be filled.
    case EvenOdd
}


/// A C4Path is a sequence of geometric segments which can be straight lines or curves.
@IBDesignable
public class C4Path: Equatable {
    internal var internalPath: CGMutablePathRef = CGPathCreateMutable()

    ///  Initializes an empty C4Path.
    public init() {
        internalPath = CGPathCreateMutable()
        CGPathMoveToPoint(internalPath, nil, 0, 0)
    }

    ///  Initializes a new C4Path from an existing CGPathRef.
    ///
    ///  - parameter path: a previously initialized CGPathRef
    public init(path: CGPathRef) {
        internalPath = CGPathCreateMutableCopy(path)!
    }
    
    /// Determine if the path is empty
    public func isEmpty() -> Bool {
        return CGPathIsEmpty(internalPath)
    }
    
    /// Return the path bounding box. The path bounding box is the smallest rectangle completely enclosing all points
    /// in the path, *not* including control points for Bézier cubic and quadratic curves. If the path is empty, then
    /// return `CGRectNull`.
    public func boundingBox() -> C4Rect {
        return C4Rect(CGPathGetPathBoundingBox(internalPath))
    }
    
    /// Return true if `point` is contained in `path`; false otherwise. A point is contained in a path if it is inside the
    /// painted region when the path is filled; if `fillRule` is `EvenOdd`, then the even-odd fill rule is used to evaluate
    /// the painted region of the path, otherwise, the winding-number fill rule is used.
    public func containsPoint(point: C4Point, fillRule: FillRule = .NonZero) -> Bool {
        return CGPathContainsPoint(internalPath, nil, CGPoint(point), fillRule == .EvenOdd)
    }
    
    /// Create a copy of the path
    public func copy() -> C4Path {
        return C4Path(path: CGPathCreateMutableCopy(internalPath)!)
    }

    /// A CGPathRef representation of the receiver's path.
    public var CGPath: CGPathRef {
        get {
            return internalPath
        }
    }
}

/// Determine if two paths are equal
public func == (left: C4Path, right: C4Path) -> Bool {
    return CGPathEqualToPath(left.internalPath, right.internalPath)
}

extension C4Path {

    /// Return the current point of the current subpath.
    public var currentPoint: C4Point {
        get {
            return C4Point(CGPathGetCurrentPoint(internalPath))
        }
        set(point) {
            moveToPoint(point)
        }
    }
    
    /// Move the current point of the current subpath.
    public func moveToPoint(point: C4Point) {
        CGPathMoveToPoint(internalPath, nil, CGFloat(point.x), CGFloat(point.y))
    }
    
    /// Append a straight-line segment fron the current point to `point` and move the current point to `point`.
    public func addLineToPoint(point: C4Point) {
        CGPathAddLineToPoint(internalPath, nil, CGFloat(point.x), CGFloat(point.y))
    }
    
    /// Append a quadratic curve from the current point to `point` with control point `control` and move the current
    /// point to `point`.
    public func addQuadCurveToPoint(control control: C4Point, point: C4Point) {
        CGPathAddQuadCurveToPoint(internalPath, nil, CGFloat(control.x), CGFloat(control.y), CGFloat(point.x), CGFloat(point.y))
    }
    
    /// Append a cubic Bézier curve from the current point to `point` with control points `control1` and `control2`
    /// and move the current point to `point`.
    public func addCurveToPoint(control1: C4Point, control2: C4Point, point: C4Point) {
        CGPathAddCurveToPoint(internalPath, nil, CGFloat(control1.x), CGFloat(control1.y), CGFloat(control2.x), CGFloat(control2.y), CGFloat(point.x), CGFloat(point.y))
    }
    
    /// Append a line from the current point to the starting point of the current subpath and end the subpath.
    public func closeSubpath() {
        CGPathCloseSubpath(internalPath)
    }
    
    /// Add a rectangle to the path.
    public func addRect(rect: C4Rect) {
        CGPathAddRect(internalPath, nil, CGRect(rect))
    }
    
    /// Add a rounded rectangle to the path. The rounded rectangle coincides with the edges of `rect`. Each corner consists
    /// of one-quarter of an ellipse with axes equal to `cornerWidth` and `cornerHeight`. The rounded rectangle forms a
    /// complete subpath of the path --- that is, it begins with a "move to" and ends with a "close subpath" --- oriented
    /// in the clockwise direction.
    public func addRoundedRect(rect: C4Rect, cornerWidth: Double, cornerHeight: Double) {
        CGPathAddRoundedRect(internalPath, nil, CGRect(rect), CGFloat(cornerWidth), CGFloat(cornerHeight))
    }
    
    /// Add an ellipse (an oval) inside `rect`. The ellipse is approximated by a sequence of Bézier curves. The center of
    /// the ellipse is the midpoint of `rect`. If `rect` is square, then the ellipse will be circular with radius equal to
    /// one-half the width (equivalently, one-half the height) of `rect`. If `rect` is rectangular, then the major- and
    /// minor-axes will be the width and height of `rect`. The ellipse forms a complete subpath --- that is, it begins with
    /// a "move to" and ends with a "close subpath" --- oriented in the clockwise direction.
    public func addEllipse(rect: C4Rect) {
        CGPathAddEllipseInRect(internalPath, nil, CGRect(rect))
    }
    
    /// Add an arc of a circle, possibly preceded by a straight line segment. The arc is approximated by a sequence of
    /// Bézier curves.
    ///
    /// - parameter center:     The center of the arc.
    /// - parameter radius:     The radius of the arc.
    /// - parameter startAngle: The angle in radians to the first endpoint of the arc, measured counter-clockwise from the positive
    ///                         x-axis.
    /// - parameter delta:      The angle between `startAngle` and the second endpoint of the arc, in radians. If `delta' is positive,
    ///                         then the arc is drawn counter-clockwise; if negative, clockwise.
    public func addRelativeArc(center: C4Point, radius: Double, startAngle: Double, delta: Double) {
        CGPathAddRelativeArc(internalPath, nil, CGFloat(center.x), CGFloat(center.y), CGFloat(radius), CGFloat(startAngle), CGFloat(delta))
    }
    
    /// Add an arc of a circle, possibly preceded by a straight line segment. The arc is approximated by a sequence of
    /// Bézier curves.
    ///
    /// Note that using values very near 2π can be problematic. For example, setting `startAngle` to 0, `endAngle` to 2π,
    /// and `clockwise` to true will draw nothing. (It's easy to see this by considering, instead of 0 and 2π, the values
    /// ε and 2π - ε, where ε is very small.) Due to round-off error, however, it's possible that passing the value
    /// `2 * M_PI` to approximate 2π will numerically equal to 2π + δ, for some small δ; this will cause a full circle to
    /// be drawn.
    ///
    /// If you want a full circle to be drawn clockwise, you should set `startAngle` to 2π, `endAngle` to 0, and
    /// `clockwise` to true. This avoids the instability problems discussed above.
    ///
    /// - parameter center:     The center of the arc.
    /// - parameter radius:     The radius of the arc.
    /// - parameter startAngle: The angle to the first endpoint of the arc in radians.
    /// - parameter endAngle:   The angle to the second endpoint of the arc.
    /// - parameter clockwise:  If true the arc is drawn clockwise.
    public func addArc(center: C4Point, radius: Double, startAngle: Double, endAngle: Double, clockwise: Bool) {
        CGPathAddArc(internalPath, nil, CGFloat(center.x), CGFloat(center.y), CGFloat(radius), CGFloat(startAngle), CGFloat(endAngle), clockwise)
    }
    
    /// Add an arc of a circle, possibly preceded by a straight line segment. The arc is approximated by a sequence of
    /// Bézier curves. The resulting arc is tangent to the line from the current point to `point1`, and the line from
    /// `point1` to `point2`.
    public func addArcToPoint(point1: C4Point, point2: C4Point, radius: Double) {
        CGPathAddArcToPoint(internalPath, nil, CGFloat(point1.x), CGFloat(point1.y), CGFloat(point2.x), CGFloat(point2.y), CGFloat(radius))
    }
    
    /// Append a path.
    ///
    /// - parameter path:      A new C4Path that is added to the end of the receiver.
    public func addPath(path: C4Path) {
        CGPathAddPath(internalPath, nil, path.internalPath)
    }
    
    /// Transform a path.
    ///
    /// - parameter transform: A C4Transform to be applied to the receiver.
    public func transform(transform: C4Transform) {
        var t = transform.affineTransform
        internalPath = CGPathCreateMutableCopyByTransformingPath(internalPath, &t)!
    }
}
