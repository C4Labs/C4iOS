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

import Foundation
import CoreGraphics

///  A structure that contains the location and dimensions of a rectangle.
public struct Rect: Equatable, CustomStringConvertible {
    /// The origin (top-left) of the rect.
    public var origin: Point

    /// The size (width / height) of the rect.
    public var size: Size

    /// The width of the rect.
    public var width: Double {
        get {
            return size.width
        } set {
            size.width = newValue
        }
    }

    /// The height of the rect.
    public var height: Double {
        get {
            return size.height
        } set {
            size.height = newValue
        }
    }

    /// Initializes a new Rect with the origin {0,0} and the size {0,0}
    /// ````
    /// let r = Rect()
    /// ````
    public init() {
        self.init(0, 0, 0, 0)
    }

    /// Initializes a new Rect with the origin {x,y} and the size {w,h}
    /// ````
    /// let r = Rect(0.0,0.0,10.0,10.0)
    /// ````
    public init(_ x: Double, _ y: Double, _ w: Double, _ h: Double) {
        origin = Point(x, y)
        size = Size(w, h)
    }

    /// Initializes a new Rect with the origin {x,y} and the size {w,h}, converting values from Int to Double
    /// ````
    /// let r = Rect(0,0,10,10)
    /// ````
    public init(_ x: Int, _ y: Int, _ w: Int, _ h: Int) {
        origin = Point(x, y)
        size = Size(w, h)
    }

    /// Initializes a new Rect with the origin {o.x,o.y} and the size {s.w,s.h}
    /// ````
    /// let p = Point()
    /// let s = Size()
    /// let r = Rect(p,s)
    /// ````
    public init(_ o: Point, _ s: Size) {
        origin = o
        size = s
    }

    /// Initializes a Rect from a CGRect
    public init(_ rect: CGRect) {
        origin = Point(rect.origin)
        size = Size(rect.size)
    }

    /// Initializes a rectangle that contains all of the specified coordinates in an array.
    /// ````
    /// let pts = [Point(), Point(0,5), Point(10,10), Point(9,8)]
    /// let r = Rect(pts) //-> {{0.0, 0.0}, {10.0, 10.0}}
    /// ````
    /// - parameter points: An array of Point coordinates
    public init(_ points: [Point]) {
        let count = points.count
        assert(count >= 2, "To create a Polygon you need to specify an array of at least 2 points")
        var cgPoints = [CGPoint]()
        for i in 0..<count {
            cgPoints.append(CGPoint(points[i]))
        }
        let r = CGRectMakeFromPoints(cgPoints)
        let f = Rect(r)
        self.init(f.origin, f.size)
    }

    /// Initializes a rectangle that contains the specified coordinates in a tuple.
    /// ````
    /// let pts = (Point(), Point(0,5))
    /// let r = Rect(pts)
    /// ````
    /// - parameter points: An tuple of Point coordinates
    public init(_ points: (Point, Point)) {
        let r = CGRectMakeFromPoints([CGPoint(points.0), CGPoint(points.1)])
        let f = Rect(r)
        self.init(f.origin, f.size)
    }

    //MARK: - Comparing

    /// Returns whether two rectangles intersect.
    /// ````
    /// let r1 = Rect(0,0,10,10)
    /// let r2 = Rect(5,5,10,10)
    /// let r3 = Rect(10,10,10,10)
    /// r1.intersects(r2) //-> true
    /// r1.intersects(r3) //-> false
    /// ````
    /// - parameter rect: The rectangle to examine.
    /// - returns:	true if the two specified rectangles intersect; otherwise, false.
    public func intersects(_ rect: Rect) -> Bool {
        return CGRect(self).intersects(CGRect(rect))
    }

    //MARK: - Center & Max

    /// The center point of the receiver.
    /// ````
    /// let r = Rect(0,0,10,10)
    /// r.center //-> {5,5}
    /// ````
    public var center: Point {
        get {
            return Point(origin.x + size.width/2, origin.y + size.height/2)
        }
        set {
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }

    /// The bottom-right point of the receiver.
    /// ````
    /// let r = Rect(5,5,10,10)
    /// r.max //-> {15,15}
    /// ````
    public var max: Point {
        get {
            return Point(origin.x + size.width, origin.y + size.height)
        }
    }

    /// Checks to see if the receiver has zero size and position
    /// ````
    /// let r = Point()
    /// r.isZero() //-> true
    /// ````
    /// - returns: true if origin = {0,0} and size = {0,0}
    public func isZero() -> Bool {
        return origin.isZero() && size.isZero()
    }

    //MARK: - Membership

    /// Returns whether a rectangle contains a specified point.
    /// ````
    /// let r1 = Rect(0,0,10,10)
    /// let r2 = Rect(5,5,10,10)
    /// let p = Rect(2,2,2,2)
    /// r1.contains(p) //-> true
    /// r2.contains(p) //-> false
    /// ````
    /// - parameter point:	The point to examine.
    /// - returns: true if the rectangle is not null or empty and the point is located within the rectangle; otherwise, false.
    public func contains(_ point: Point) -> Bool {
        return CGRect(self).contains(CGPoint(point))
    }

    /// Returns whether the first rectangle contains the second rectangle.
    /// ````
    /// let r1 = Rect(0,0,10,10)
    /// let r2 = Rect(5,5,10,10)
    /// let r3 = Rect(2,2,2,2)
    /// r1.contains(r2) //-> false
    /// r1.contains(r3) //-> true
    /// ````
    /// - parameter rect:	The rectangle to examine for containment.
    /// - returns: `true` if the rectangle is contained in this rectangle; otherwise, `false`.
    public func contains(_ rect: Rect) -> Bool {
        return CGRect(self).contains(CGRect(rect))
    }

    /// A string representation of the rect.
    /// - returns: A string formatted to look like {{x,y},{w,h}}
    public var description: String {
        get {
            return "{\(origin),\(size)}"
        }
    }
}

//MARK: - Comparing

/// Checks to see if two Rects share identical origin and size
///
/// ````
/// let r1 = Rect(0,0,10,10)
/// let r2 = Rect(0,0,10,10.5)
/// println(r1 == r2) //-> false
/// ````
/// - parameter lhs: The first rectangle to compare
/// - parameter rhs: The second rectangle to compare
/// - returns: A bool, `true` if the rects are identical, otherwise `false`.
public func == (lhs: Rect, rhs: Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
}

//MARK: - Manipulating

/// Returns the intersection of two rectangles.
///
/// ````
/// let r1 = Rect(0,0,10,10)
/// let r2 = Rect(5,5,10,10)
/// intersection(r1,r2) //-> {5,5,5,5}
/// ````
///
/// - parameter rect1:	The first source rectangle.
/// - parameter rect2:	The second source rectangle.
///
/// - returns: A rectangle that represents the intersection of the two specified rectangles.
public func intersection(_ rect1: Rect, rect2: Rect) -> Rect {
    return Rect(CGRect(rect1).intersection(CGRect(rect2)))
}

/// Returns the smallest rectangle that contains the two source rectangles.
///
/// ````
/// let r1 = Rect(0,0,10,10)
/// let r2 = Rect(5,5,10,10)
/// intersection(r1,r2) //-> {0,0,15,15}
/// ````
///
/// - parameter rect1:	The first source rectangle.
/// - parameter rect2:	The second source rectangle.
/// - returns:	The smallest rectangle that completely contains both of the source rectangles.
public func union(_ rect1: Rect, rect2: Rect) -> Rect {
    return Rect(CGRect(rect1).union(CGRect(rect2)))
}

/// Returns the smallest rectangle that results from converting the source rectangle values to integers.
///
/// ````
/// let r = Rect(0.1, 0.9, 9.1, 9.9)
/// integral(r) //-> {0, 0, 10, 10}
/// ````
///
/// - parameter r:	The source rectangle.
/// - returns: A rectangle with the smallest integer values for its origin and size that contains the source rectangle.
public func integral(_ r: Rect) -> Rect {
    return Rect(CGRect(r).integral)
}

/// Returns a rectangle with a positive width and height.
///
/// ````
/// let r = Rect(0, 0, -10, -10)
/// standardize(r) //-> {-10, -10, 10, 10}
/// ````
///
/// - parameter r:	The source rectangle.
/// - returns:	A rectangle that represents the source rectangle, but with positive width and height values.
public func standardize(_ r: Rect) -> Rect {
    return Rect(CGRect(r).standardized)
}

/// Returns a rectangle that is smaller or larger than the source rectangle, with the same center point.
///
/// ````
/// let r = Rect(0,0,10,10)
/// inset(r, 1, 1) //-> {1,1,8,8}
/// ````
///
/// - parameter r:	The source Rect structure.
/// - parameter dx:	The x-coordinate value to use for adjusting the source rectangle.
/// - parameter dy:	The y-coordinate value to use for adjusting the source rectangle.
/// - returns:	A rectangle.
public func inset(_ r: Rect, dx: Double, dy: Double) -> Rect {
    return Rect(CGRect(r).insetBy(dx: CGFloat(dx), dy: CGFloat(dy)))
}

// MARK: - Casting to CGRect
public extension CGRect {
    /// Initializes a CGRect from a Rect
    public init(_ rect: Rect) {
        origin = CGPoint(rect.origin)
        size = CGSize(rect.size)
    }
}
