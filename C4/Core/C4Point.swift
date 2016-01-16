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
public struct C4Point : Equatable, CustomStringConvertible {
    ///The x value of the coordinate.
    public var x: Double

    /// The y value of the coordinate.
    public var y: Double

    ///   Returns true if the point's coordinates are {0,0}, otherwise returns false
    public func isZero() -> Bool {
        return x == 0 && y == 0
    }

    // MARK: Initialization
    ///  Initializes a new point with the specified coordinates {x,y}
    ///
    ///  ````
    ///  let p = C4Point()
    ///  let p = C4Point(10.5,10.5)
    ///  ````
    ///
    ///  - parameter x: a Double value
    ///  - parameter y: a Double value
    public init(_ x: Double = 0.0, _ y: Double = 0.0) {
        self.x = x
        self.y = y
    }

    ///  Initializes a new point with the specified coordinates {x,y}, converting integer values to doubles
    ///
    ///  ````
    ///  let p = C4Point(10,10)
    ///  ````
    public init(_ x: Int, _ y: Int) {
        self.init(Double(x),Double(y))
    }


    ///  Initializes a new point with the specified coordinates {x,y}, converting CGFloat values to doubles
    ///
    ///  ````
    ///  let p = C4Point(10.0,10.0)
    ///  ````
    public init(_ x: CGFloat, _ y: CGFloat) {
        self.init(Double(x),Double(y))
    }

    ///  Initializes a C4Point initialized with a CGPoint.
    ///
    ///  - parameter point: a previously initialized CGPoint
    ///
    ///  - returns: a C4Point whose values are the same as the CGPoint
    public init(_ point: CGPoint) {
        self.init(Double(point.x),Double(point.y))
    }

    // MARK: Transform
    ///  Transforms the point.
    ///
    ///  ````
    ///  var p = C4Point(10,10)
    ///  let v = C4Vector(x: 0, y: 0, z: 1)
    ///  let t = C4Transform.makeRotation(M_PI, axis: v)
    ///  p.transform(t) // -> {-10.0, -10.0}
    ///  ````
    ///
    ///  - parameter t: A C4Transform to apply to the point
    public mutating func transform(t: C4Transform) {
        x = x * t[0, 0] + y * t[0, 1] + t[3, 0]
        y = x * t[1, 0] + y * t[1, 1] + t[3, 1]
    }

    // MARK: Description
    ///  A string representation of the point.
    /// 
    ///  ````
    ///  let p = C4Point()
    ///  println(p)
    ///  ````
    ///
    ///  - returns: A string formatted to look like {x,y}
    public var description : String {
        get {
            return "{\(x), \(y)}"
        }
    }
}

// MARK: Addition
///  Translate a point by the given vector.
///
///  - parameter lhs: a C4Point to translate
///  - parameter rhs: a C4Vector whose values will be applied to the point
public func += (inout lhs: C4Point, rhs: C4Vector) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

///  Translate a point by the given point.
///
///  - parameter lhs: a C4Point to translate
///  - parameter rhs: a C4Point whose values will be applied to the point
public func += (inout lhs: C4Point, rhs: C4Point) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

///  Translate a point by the given vector.
///
///  - parameter lhs: a C4Point to translate
///  - parameter rhs: a C4Vector whose values will be applied to the point
///
///  - returns: A new point whose coordinates have been translated by the values from the vector (e.g. point.x = lhs.x + rhs.x)
public func + (lhs: C4Point, rhs: C4Vector) -> C4Point {
    return C4Point(lhs.x + rhs.x,lhs.y + rhs.y)
}

///  Translate a point by the given vector.
///
///  - parameter lhs: a C4Point to translate
///  - parameter rhs: a C4Vector whose values will be applied to the point
///
///  - returns: A new point whose coordinates have been translated by the values from the vector (e.g. point.x = lhs.x + rhs.x)
public func + (lhs: C4Point, rhs: C4Point) -> C4Point {
    return C4Point(lhs.x + rhs.x,lhs.y + rhs.y)
}

// MARK: Subtraction
///  Translate a point by the negative of the given vector
///
///  - parameter lhs: a C4Point to translate
///  - parameter rhs: a C4Vector whose values will be applied to the point
public func -= (inout lhs: C4Point, rhs: C4Vector) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
}

///  Translate a point by the negative of the given point
///
///  - parameter lhs: a C4Point to translate
///  - parameter rhs: a C4Point whose values will be applied to the point
public func -= (inout lhs: C4Point, rhs: C4Point) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
}

///  Translate a point by the negative of the vector.
///
///  - parameter lhs: a C4Point to translate
///  - parameter rhs: a C4Vector whose values will be applied to the point
///
///  - returns: A new point whose coordinates have been translated by the negative vector (e.g. point.x = lhs.x - rhs.x)
public func - (lhs: C4Point, rhs: C4Vector) -> C4Point {
    return C4Point(lhs.x - rhs.x,lhs.y - rhs.y)
}

///  Calculate the vector between two points
///
///  - parameter lhs: a C4Point
///  - parameter rhs: a C4Point
///
///  - returns: a C4Vector whose value is the left-hand side _minus_ the right-hand side
public func - (lhs: C4Point, rhs: C4Point) -> C4Point {
    return C4Point(lhs.x - rhs.x, lhs.y - rhs.y)
}

// MARK: Multiplication
///  Multiplies a point by an Integer
///
///  - parameter lhs: a C4Point
///  - parameter rhs: a Double
///
///  - returns: a C4Point whose values are multiplied by rhs
public func * (lhs: C4Point, rhs: Double) -> C4Point {
    return C4Point(lhs.x * Double(rhs), lhs.y * Double(rhs))
}

///  Multiplies a point by an Integer
///
///  - parameter lhs: a C4Point
///  - parameter rhs: an Integer
///
///  - returns: a C4Point whose values are multiplied by rhs
public func * (lhs: C4Point, rhs: Int) -> C4Point {
    return C4Point(lhs.x * Double(rhs), lhs.y * Double(rhs))
}

///  Multiplies a point by an Integer
///
///  - parameter lhs: a C4Point
///  - parameter rhs: an Integer
///
///  - returns: a C4Point whose values are multiplied by rhs
public func * (lhs: C4Point, rhs: CGFloat) -> C4Point {
    return C4Point(lhs.x * Double(rhs), lhs.y * Double(rhs))
}

///  Scales a point by multiplying its values by an Double
///
///  - parameter lhs: a C4Point
///  - parameter rhs: an Integer
public func *= (inout lhs: C4Point, rhs: Double) {
    lhs.x *= rhs
    lhs.y *= rhs
}

///  Scales a point by multiplying its values by an Integer
///
///  - parameter lhs: a C4Point
///  - parameter rhs: an Integer
public func *= (inout lhs: C4Point, rhs: Int) {
    lhs.x *= Double(rhs)
    lhs.y *= Double(rhs)
}

///  Scales a point by multiplying its values by an Integer
///
///  - parameter lhs: a C4Point
///  - parameter rhs: an CGFloat
public func *= (inout lhs: C4Point, rhs: CGFloat) {
    lhs.x *= Double(rhs)
    lhs.y *= Double(rhs)
}

// MARK: Division
///  Divides a point by an double
///
///  - parameter lhs: a C4Point
///  - parameter rhs: an Double
///
///  - returns: a C4Point whose values are multiplied by rhs
public func / (lhs: C4Point, rhs: Double) -> C4Point {
    guard rhs != 0 else {
        print("Cannot divide by 0, returning original point.")
        return lhs
    }
    return C4Point(lhs.x / rhs, lhs.y / rhs)
}
///  Divides a point by an Integer
///
///  - parameter lhs: a C4Point
///  - parameter rhs: an Integer
///
///  - returns: a C4Point whose values are multiplied by rhs
public func / (lhs: C4Point, rhs: Int) -> C4Point {
    guard rhs != 0 else {
        print("Cannot divide by 0, returning original point.")
        return lhs
    }
    return C4Point(lhs.x / Double(rhs), lhs.y / Double(rhs))
}
///  Divides a point by an CGFloat
///
///  - parameter lhs: a C4Point
///  - parameter rhs: an CGFloat
///
///  - returns: a C4Point whose values are multiplied by rhs
public func / (lhs: C4Point, rhs: CGFloat) -> C4Point {
    guard rhs != 0 else {
        print("Cannot divide by 0, returning original point.")
        return lhs
    }
    return C4Point(lhs.x / Double(rhs), lhs.y / Double(rhs))
}

///  Scales a point by an dividing its values by a Double
///
///  - parameter lhs: a C4Point
///  - parameter rhs: a Double
public func /= (inout lhs: C4Point, rhs: Double) {
    lhs.x /= rhs
    lhs.y /= rhs
}

///  Scales a point by an dividing its values by an Integer
///
///  - parameter lhs: a C4Point
///  - parameter rhs: an Integer
public func /= (inout lhs: C4Point, rhs: Int) {
    lhs.x /= Double(rhs)
    lhs.y /= Double(rhs)
}

///  Scales a point by an dividing its values by a CGFloat
///
///  - parameter lhs: a C4Point
///  - parameter rhs: a CGFloat
public func /= (inout lhs: C4Point, rhs: CGFloat) {
    lhs.x /= Double(rhs)
    lhs.y /= Double(rhs)
}

// MARK: Distance
///  Calculates the distance between two points.
///
///  - parameter lhs: left-hand point
///  - parameter rhs: right-hand point
///
///  - returns: The linear distance between two points
public func distance(lhs: C4Point, rhs: C4Point) -> Double {
    let dx = rhs.x - lhs.x
    let dy = rhs.y - lhs.y
    return sqrt(dx*dx + dy*dy)
}

// MARK: Equality
///  Checks to see if two points are equal.
///
///  - parameter lhs: a C4Point
///  - parameter rhs: a C4Point
///
///  - returns: true if the two structs have identical coordinates
public func == (lhs: C4Point, rhs: C4Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

// MARK: Interpolation
///  Linear interpolation.
///  
///  For any two points `a` and `b` return a point that is the linear interpolation between a and b
///  for interpolation parameter `param`. For instance, a parameter of 0 will return `a`, a parameter of 1 will return `b`
///  and a parameter of 0.5 will return the midpoint between `a` and `b`.
///
///  - parameter a:     the first point
///  - parameter b:     the second point
///  - parameter param: a Double value (between 0.0 and 1.0) used to calculate the point between a and b
///
///  - returns: an interpolated point
public func lerp(a a: C4Point, b: C4Point, param: Double) -> C4Point {
    return a + (b - a) * param
}

// MARK: CGPoint initialization
public extension CGPoint {
    ///Initializes a CGPoint from a C4Point
    public init(_ point: C4Point) {
        x = CGFloat(point.x)
        y = CGFloat(point.y)
    }
}