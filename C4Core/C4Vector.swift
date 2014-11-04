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

public struct C4Vector : Equatable {
    public var x: Double = 0
    public var y: Double = 0
    
    public init() {
    }
    
    /**
    Create a vector with a cartesian representation: an x and a y coordinates.
    */
    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
    
    public init(_ x: Int, _ y: Int) {
        self.x = Double(x)
        self.y = Double(y)
    }
    
    /**
    Create a vector with a polar representation: a magnitude and an angle in radians.
    http://en.wikipedia.org/wiki/Polar_coordinate_system
    */
    public init(magnitude: Double, heading: Double) {
        x = magnitude * cos(heading)
        y = magnitude * sin(heading)
    }
    
    /**
    The polar representation magnitude of the vector.
    */
    public var magnitude: Double {
        get {
            return sqrt(x * x + y * y)
        }
        set {
            x = newValue * cos(heading)
            y = newValue * sin(heading)
        }
    }
    
    /**
    The polar representation heading angle of the vector, in radians.
    */
    public var heading : Double {
        get {
            return atan2(y, x);
        }
        set {
            x = magnitude * cos(newValue)
            y = magnitude * sin(newValue)
        }
    }
    
    /**
    The angle between two vectors, based on {0,0}
    */
    public func angleTo(vec: C4Vector) -> Double {
        return acos(self ⋅ vec / (self.magnitude * vec.magnitude))
    }

    /**
    The angle between two vectors, based on a provided point
    */
    public func angleTo(vec: C4Vector, basedOn: C4Vector) -> Double {
        var vecA = C4Vector(x: x, y: y)
        var vecB = C4Vector(x: vec.x, y: vec.y)
        
        vecA -= basedOn
        vecB -= basedOn
        
        return acos(vecA ⋅ vecB / (self.magnitude * vecB.magnitude))
    }

    /**
    Return the dot product. You should use the ⋅ operator instead.
    */
    public func dot(vec: C4Vector) -> Double {
        return x * vec.x + y * vec.y
    }
    
    /**
    Return a vector with the same heading but a magnitude of 1.
    */
    public func unitVector() -> C4Vector {
        let mag = self.magnitude
        if mag == 0 {
            return C4Vector()
        }
        return C4Vector(x: x / mag, y: y / mag)
    }

    /**
    Return `true` if the vector is zero.
    */
    public func isZero() -> Bool {
        return x == 0 && y == 0
    }
}

public func == (lhs: C4Vector, rhs: C4Vector) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

public func += (inout lhs: C4Vector, rhs: C4Vector) {
    lhs.x += rhs.x
    lhs.y += rhs.y
}

public func -= (inout lhs: C4Vector, rhs: C4Vector) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
}

public func *= (inout lhs: C4Vector, rhs: Double) {
    lhs.x *= rhs
    lhs.y *= rhs
}

public func /= (inout lhs: C4Vector, rhs: Double) {
    lhs.x /= rhs
    lhs.y /= rhs
}

public func + (lhs: C4Vector, rhs: C4Vector) -> C4Vector {
    return C4Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}

public func - (lhs: C4Vector, rhs: C4Vector) -> C4Vector {
    return C4Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

infix operator ⋅ { associativity left precedence 150 }
public func ⋅ (lhs: C4Vector, rhs: C4Vector) -> Double {
    return lhs.x * rhs.x + lhs.y * rhs.y
}

public func / (lhs: C4Vector, rhs: Double) -> C4Vector {
    return C4Vector(x: lhs.x / rhs, y: lhs.y / rhs)
}

public func * (lhs: C4Vector, rhs: Double) -> C4Vector {
    return C4Vector(x: lhs.x * rhs, y: lhs.y * rhs)
}

public prefix func - (vector: C4Vector) -> C4Vector {
    return C4Vector(x: -vector.x, y: -vector.y)
}
