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
    public var z: Double = 0
    
    public init() {
    }
    
    /**
      Create a vector with a cartesian representation: an x and a y coordinates.
     */
    public init(x: Double, y: Double, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /**
      Create a vector with a polar representation: a magnitude and an angle in radians.
      http://en.wikipedia.org/wiki/Polar_coordinate_system
     */
    public init(magnitude: Double, heading: Double, z: Double = 0) {
        x = magnitude * cos(heading)
        y = magnitude * sin(heading)
        self.z = z
    }
    
    /**
      The polar representation magnitude of the vector.
     */
    public var magnitude: Double {
        get {
            return sqrt(x * x + y * y + z * z)
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
        var vecA = self
        var vecB = vec
        
        vecA -= basedOn
        vecB -= basedOn
        
        return acos(vecA ⋅ vecB / (self.magnitude * vecB.magnitude))
    }

    /**
      Return the dot product. You should use the ⋅ operator instead.
     */
    public func dot(vec: C4Vector) -> Double {
        return x * vec.x + y * vec.y + z * vec.z
    }
    
    /**
      Return a vector with the same heading but a magnitude of 1.
     */
    public func unitVector() -> C4Vector? {
        let mag = self.magnitude
        if mag == 0 {
            return nil
        }
        return C4Vector(x: x / mag, y: y / mag, z: z / mag)
    }

    /**
      Return `true` if the vector is zero.
     */
    public func isZero() -> Bool {
        return x == 0 && y == 0 && z == 0
    }
    
    /**
      Transform the vector.
     */
    public mutating func transform(t: C4Transform) {
        x = x * t[0, 0] + y * t[0, 1] + z * t[0, 2]
        y = x * t[1, 0] + y * t[1, 1] + z * t[1, 2]
        z = x * t[2, 0] + y * t[2, 1] + z * t[2, 2]
    }
    
    /**
    A string representation of the vector.
    
    :returns: A string formatted to look like {x,y,z}
    */
    public func description() -> String {
        return "{\(x), \(y), \(z)}"
    }
}

/**
Returns true if the coordinates of both vectors are identical
*/
public func == (lhs: C4Vector, rhs: C4Vector) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

/**
Transforms the left-hand vector by adding the values of the right-hand vector
*/
public func += (inout lhs: C4Vector, rhs: C4Vector) {
    lhs.x += rhs.x
    lhs.y += rhs.y
    lhs.z += rhs.z
}

/**
Transforms the left-hand vector by subtracting the values of the right-hand vector
*/
public func -= (inout lhs: C4Vector, rhs: C4Vector) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
    lhs.z -= rhs.z
}

/**
Transforms the left-hand vector by multiplying each by the values of the right-hand vector
*/
public func *= (inout lhs: C4Vector, rhs: Double) {
    lhs.x *= rhs
    lhs.y *= rhs
    lhs.z *= rhs
}

/**
Transforms the left-hand vector by dividing each by the values of the right-hand vector
*/
public func /= (inout lhs: C4Vector, rhs: Double) {
    lhs.x /= rhs
    lhs.y /= rhs
    lhs.z /= rhs
}

/**
Returns a new vector whose coordinates are the sum of both input vectors
*/
public func + (lhs: C4Vector, rhs: C4Vector) -> C4Vector {
    return C4Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

/**
Returns a new vector whose coordinates are the subtraction of the right-hand vector from the left-hand vector
*/
public func - (lhs: C4Vector, rhs: C4Vector) -> C4Vector {
    return C4Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
}

/**
Returns a new vector that is the dot product of the both input vectors
*/
infix operator ⋅ { associativity left precedence 150 }
public func ⋅ (lhs: C4Vector, rhs: C4Vector) -> Double {
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
}

/**
Returns a new vector whose coordinates are the division of the left-hand vector coordinates by those of the right-hand vector
*/
public func / (lhs: C4Vector, rhs: Double) -> C4Vector {
    return C4Vector(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
}

/**
Returns a new vector whose coordinates are the multiplication of the left-hand vector coordinates by those of the right-hand vector
*/
public func * (lhs: C4Vector, rhs: Double) -> C4Vector {
    return C4Vector(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
}

/**
Returns a new vector whose coordinates are the negative values of the receiver
*/
public prefix func - (vector: C4Vector) -> C4Vector {
    return C4Vector(x: -vector.x, y: -vector.y, z: -vector.z)
}

/**
Initializes a C4Vector from a CGPoint
*/
public extension C4Vector {
    public init(_ point: CGPoint) {
        x = Double(point.x)
        y = Double(point.y)
        z = 0
    }
}
