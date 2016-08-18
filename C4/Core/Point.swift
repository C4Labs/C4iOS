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

import CoreGraphics

///A structure that contains a point in a two-dimensional coordinate system.
public struct Point: Equatable, CustomStringConvertible {

    ///The x value of the coordinate.
    public var x: Double = 0

    /// The y value of the coordinate.
    public var y: Double = 0

    ///  Initializes a new point with the coordinates {0,0}
    ///
    ///  ````
    ///  let p = Point()
    ///  ````
    public init() {
    }

    ///  Initializes a new point with the specified coordinates {x,y}
    ///
    ///  ````
    ///  let p = Point(10.5,10.5)
    ///  ````
    ///
    /// - parameter x: a Double value
    /// - parameter y: a Double value
    public init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }

    ///  Initializes a new point with the specified coordinates {x,y}, converting integer values to doubles
    ///
    ///  ````
    ///  let p = Point(10,10)
    ///  ````
    public init(_ x: Int, _ y: Int) {
        self.x = Double(x)
        self.y = Double(y)
    }

    ///  Initializes a Point initialized with a CGPoint.
    ///
    /// - parameter point: a previously initialized CGPoint
    public init(_ point: CGPoint) {
        x = Double(point.x)
        y = Double(point.y)
    }

    ///   Returns true if the point's coordinates are {0,0}, otherwise returns false
    public func isZero() -> Bool {
        return x == 0 && y == 0
    }

    ///  Transforms the point.
    ///
    ///  ````
    ///  var p = Point(10,10)
    ///  let v = Vector(x: 0, y: 0, z: 1)
    ///  let t = Transform.makeRotation(M_PI, axis: v)
    ///  p.transform(t) // -> {-10.0, -10.0}
    ///  ````
    ///
    /// - parameter t: A Transform to apply to the point
    public mutating func transform(_ t: Transform) {
        x = x * t[0, 0] + y * t[0, 1] + t[3, 0]
        y = x * t[1, 0] + y * t[1, 1] + t[3, 1]
    }

    ///  A string representation of the point.
    ///
    ///  ````
    ///  let p = Point()
    ///  println(p)
    ///  ````
    ///
    /// - returns: A string formatted to look like {x,y}
    public var description: String {
        get {
            return "{\(x), \(y)}"
        }
    }
}

///  Translate a point by the given vector.
///
/// - parameter lhs: a Point to translate
/// - parameter rhs: a Vector whose values will be applied to the point
public func += (lhs: inout Point, rhs: Vector) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

///  Translate a point by the negative of the given vector
///
/// - parameter lhs: a Point to translate
/// - parameter rhs: a Vector whose values will be applied to the point
public func -= (lhs: inout Point, rhs: Vector) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
}

///  Calculate the vector between two points
///
/// - parameter lhs: a Point
/// - parameter rhs: a Point
///
/// - returns: a Vector whose value is the left-hand side _minus_ the right-hand side
public func - (lhs: Point, rhs: Point) -> Vector {
    return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

///  Translate a point by the given vector.
///
/// - parameter lhs: a Point to translate
/// - parameter rhs: a Vector whose values will be applied to the point
///
/// - returns: A new point whose coordinates have been translated by the values from the vector (e.g. point.x = lhs.x + rhs.x)
public func + (lhs: Point, rhs: Vector) -> Point {
    return Point(lhs.x + rhs.x, lhs.y + rhs.y)
}

///  Translate a point by the negative of the vector.
///
/// - parameter lhs: a Point to translate
/// - parameter rhs: a Vector whose values will be applied to the point
///
/// - returns: A new point whose coordinates have been translated by the negative vector (e.g. point.x = lhs.x - rhs.x)
public func - (lhs: Point, rhs: Vector) -> Point {
    return Point(lhs.x - rhs.x, lhs.y - rhs.y)
}

///  Calculates the distance between two points.
///
/// - parameter lhs: left-hand point
/// - parameter rhs: right-hand point
///
/// - returns: The linear distance between two points
public func distance(_ lhs: Point, rhs: Point) -> Double {
    let dx = rhs.x - lhs.x
    let dy = rhs.y - lhs.y
    return sqrt(dx*dx + dy*dy)
}

///  Checks to see if two points are equal.
///
/// - parameter lhs: a Point
/// - parameter rhs: a Point
///
/// - returns: true if the two structs have identical coordinates
public func == (lhs: Point, rhs: Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

///  Linear interpolation.
///
///  For any two points `a` and `b` return a point that is the linear interpolation between a and b
///  for interpolation parameter `param`. For instance, a parameter of 0 will return `a`, a parameter of 1 will return `b`
///  and a parameter of 0.5 will return the midpoint between `a` and `b`.
///
/// - parameter a:     the first point
/// - parameter b:     the second point
/// - parameter param: a Double value (between 0.0 and 1.0) used to calculate the point between a and b
///
/// - returns: an interpolated point
public func lerp(_ a: Point, _ b: Point, at: Double) -> Point {
    return a + (b - a) * at
}

public extension CGPoint {
    ///Initializes a CGPoint from a Point
    public init(_ point: Point) {
        x = CGFloat(point.x)
        y = CGFloat(point.y)
    }
}
