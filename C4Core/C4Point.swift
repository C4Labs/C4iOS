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

public struct C4Point : Equatable {
    public var x: Double = 0
    public var y: Double = 0
    
    /**
    Initializes a new point with the coordinates {0,0}
    */
    public init() {
    }
    
    /**
    Initializes a new point with the specified coordinates {x,y}
    */
    public init(_ x: Double, _ y: Double) {
        self.x = x
        self.y = y
    }
    
    /**
    Initializes a new point with the specified coordinates {x,y}, converting integer values to doubles
    */
    public init(_ x: Int, _ y: Int) {
        self.x = Double(x)
        self.y = Double(y)
    }
    
    /**
    Returns true if the point's coordinates are {0,0}, otherwise returns false
    */
    public func isZero() -> Bool {
        return x == 0 && y == 0
    }
    
    /**
    Transforms the point.
    
    :param: t   A C4Transform to apply to the point
    */
    public mutating func transform(t: C4Transform) {
        x = x * t[0, 0] + y * t[0, 1] + t[0, 3]
        y = x * t[1, 0] + y * t[1, 1] + t[1, 3]
    }
    
    /**
    A string representation of the point.
    
    :returns: A string formatted to look like {x,y}
    */
    public func description() -> String {
        return "{\(x), \(y)}"
    }
}

/**
Calculate the vector between two points
*/
public func - (lhs: C4Point, rhs: C4Point) -> C4Vector {
    return C4Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

/**
Translate a point by the given vector

:returns: A new point whose coordinates have been translated by the values from the vector (e.g. point.x = lhs.x + rhs.x)
*/
public func + (lhs: C4Point, rhs: C4Vector) -> C4Point {
    return C4Point(lhs.x + rhs.x,lhs.y + rhs.y)
}

/**
Calculates the distance between two points

:param: lhs left-hand point
:param: rhs right-hand point
:returns: The linear distance between two points
*/
public func distance(lhs: C4Point, rhs: C4Point) -> Double {
    let dx = rhs.x - lhs.x
    let dy = rhs.y - lhs.y
    return sqrt(dx*dx + dy*dy)
}

/**
Returns true if the two structs have identical coordinates
*/
public func == (lhs: C4Point, rhs: C4Point) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

/**
Linear interpolation. For any two points `a` and `b` return a point that is the linear interpolation between a and b
for interpolation parameter `param`. For instance, a parameter of 0 will return `a`, a parameter of 1 will return `b`
and a parameter of 0.5 will return the midpoint between `a` and `b`.

:param: a     first point
:param: b     second point
:param: param parameter between 0 and 1 for interpolation

:returns: The interpolated point
*/
public func lerp(a: C4Point, b: C4Point, param: Double) -> C4Point {
    return a + (b - a) * param
}


// MARK: - Casting to and from CGPoint
/**
Initializes a C4Point initialized with a CGPoint
*/
public extension C4Point {
    public init(_ point: CGPoint) {
        x = Double(point.x)
        y = Double(point.y)
    }
}

/**
Initializes a CGPoint from a C4Point 
*/
public extension CGPoint {
    public init(_ point: C4Point) {
        x = CGFloat(point.x)
        y = CGFloat(point.y)
    }
}