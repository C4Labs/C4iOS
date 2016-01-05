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

///  The C4Vector class is used for coordinate values and direction vectors.
public struct C4Vector : Equatable, CustomStringConvertible {
    /// The x-value of the vector.
    public var x: Double = 0
    /// The y-value of the vector.
    public var y: Double = 0
    /// The z-value of the vector.
    public var z: Double = 0
    
    /// Creates a vector with default values {0,0,0,}
    ///
    /// ````
    /// let v = C4Vector()
    /// ````
    public init() {
    }

    /// Create a vector with a cartesian representation: an x and a y coordinates. The `z` variable is optional.
    ///
    /// ````
    /// let v = C4Vector(x: 1.0, y: 1.0, z: 1.0)
    /// let v = C4Vector(x: 1.0, y: 1.0)
    /// ````
    public init(x: Double, y: Double, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    /// Create a vector with a cartesian representation: an x and a y coordinates.
    ///
    /// ````
    /// let v = C4Vector(x: 1, y: 1, z: 1)
    /// ````
    public init(x: Int, y: Int, z: Int = 0) {
        self.x = Double(x)
        self.y = Double(y)
        self.z = Double(z)
    }
    
    /// Create a vector with a polar representation: a magnitude and an angle in radians. The `z` variable is optional.
    /// [Polar coordinate system - Wikipedia](http://en.wikipedia.org/wiki/Polar_coordinate_system)
    ///
    /// ````
    /// let m = sqrt(2.0)
    /// let h = M_PI_4
    /// let v = C4Vector(magnitude: m, heading: h)
    /// v //-> {1,1,0}
    /// ````
    public init(magnitude: Double, heading: Double, z: Double = 0) {
        x = magnitude * cos(heading)
        y = magnitude * sin(heading)
        self.z = z
    }

    ///  Initializes a C4Vector from a CGPoint
    ///
    ///  - parameter point: a previously initialized CGPoint
    public init(_ point: CGPoint) {
        x = Double(point.x)
        y = Double(point.y)
        z = 0
    }

    ///  Initializes a C4Vector from a C4Point
    ///
    ///  - parameter point: a previously initialized C4Point
    public init(_ point: C4Point) {
        x = point.x
        y = point.y
        z = 0
    }

    /// The polar representation magnitude of the vector.
    ///
    /// ````
    /// let v = C4Vector(x: 2.0, y: 1.0, z: 0.0)
    /// v.magnitude //-> √2
    /// ````
    public var magnitude: Double {
        get {
            return sqrt(x * x + y * y + z * z)
        }
        set {
            x = newValue * cos(heading)
            y = newValue * sin(heading)
        }
    }
    
    /// The polar representation heading angle of the vector, in radians.
    ///
    /// ````
    /// let v = C4Vector(1,1,0)
    /// v.heading //-> M_PI_4
    /// ````
    public var heading : Double {
        get {
            return atan2(y, x);
        }
        set {
            x = magnitude * cos(newValue)
            y = magnitude * sin(newValue)
        }
    }
    
    /// The angle between two vectors, based on {0,0}
    ///
    /// ````
    /// let v1 = C4Vector(x: 1, y: 1, z: 0)
    /// let v2 = C4Vector(x: -1, y: 1, z: 0)
    /// v1.angleTo(v2) //-> M_PI_2
    /// ````
    public func angleTo(vec: C4Vector) -> Double {
        return acos(self ⋅ vec / (self.magnitude * vec.magnitude))
    }
    
    /// The angle between two vectors, based on a provided point
    ///
    /// ````
    /// let v1 = C4Vector(x: 1, y: 1, z: 0)
    /// let v2 = C4Vector(x: -1, y: 1, z: 0)
    /// let b = C4Vector(x: 0, y: 1, z: 0)
    /// v1.angleTo(v2, basedOn: b) //-> PI
    /// ````
    public func angleTo(vec: C4Vector, basedOn: C4Vector) -> Double {
        var vecA = self
        var vecB = vec
        
        vecA -= basedOn
        vecB -= basedOn
        
        return acos(vecA ⋅ vecB / (vecA.magnitude * vecB.magnitude))
    }
    
    /// Return the dot product. **You should use the ⋅ operator instead.**
    ///
    /// ````
    /// let v1 = C4Vector(x: 1, y: 1, z: 0)
    /// let v2 = C4Vector(x: -1, y: 1, z: 0)
    /// v1.dot(v2) //-> 0.0
    /// ````
    public func dot(vec: C4Vector) -> Double {
        return x * vec.x + y * vec.y + z * vec.z
    }
    
    /// Return a vector with the same heading but a magnitude of 1.
    ///
    /// ````
    /// let v1 = C4Vector(x: 1, y: 1, z: 0)
    /// v1.unitVector() //-> {M_PI_4,M_PI_4,0}
    /// ````
    public func unitVector() -> C4Vector? {
        let mag = self.magnitude
        if mag == 0 {
            return nil
        }
        return C4Vector(x: x / mag, y: y / mag, z: z / mag)
    }
    
    /// Return `true` if the vector is zero.
    ///
    /// ````
    /// let v = C4Vector()
    /// v.isZero() //-> true
    /// ````
    public func isZero() -> Bool {
        return x == 0 && y == 0 && z == 0
    }
    
    /// Transform the vector.
    ///
    /// ````
    /// var v = C4Vector(x: 1, y: 1, z:0)
    /// let t = C4Transform.makeRotation(M_PI, axis: C4Vector(x: 0, y:0, z:1))
    /// v.transform(t) //-> {-1, -1, 0}
    /// ````
    public mutating func transform(t: C4Transform) {
        x = x * t[0, 0] + y * t[0, 1] + z * t[0, 2]
        y = x * t[1, 0] + y * t[1, 1] + z * t[1, 2]
        z = x * t[2, 0] + y * t[2, 1] + z * t[2, 2]
    }
    
    /// A string representation of the vector.
    ///
    /// - returns: A string formatted to look like {x,y,z}
    public var description : String {
        get {
            return "{\(x), \(y), \(z)}"
        }
    }
}

/// Returns true if the coordinates of both vectors are identical
///
/// ````
/// let v1 = C4Vector(x: 1, y: 1)
/// let v2 = C4Vector(x: 1, y: 0)
/// v1 == v2 //-> false
/// ````
public func == (lhs: C4Vector, rhs: C4Vector) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

/// Transforms the left-hand vector by adding the values of the right-hand vector
///
/// ````
/// let v1 = C4Vector(x: 1, y: 1)
/// let v2 = C4Vector(x: 1, y: 0)
/// v1 += v2 //-> v1 = {2,1,0}
/// ````
public func += (inout lhs: C4Vector, rhs: C4Vector) {
    lhs.x += rhs.x
    lhs.y += rhs.y
    lhs.z += rhs.z
}

/// Transforms the left-hand vector by subtracting the values of the right-hand vector
///
/// ````
/// let v1 = C4Vector(x: 1, y: 1)
/// let v2 = C4Vector(x: 1, y: 0)
/// v1 += v2 //-> v1 = {0,1,0}
/// ````
public func -= (inout lhs: C4Vector, rhs: C4Vector) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
    lhs.z -= rhs.z
}

/// Transforms the left-hand vector by multiplying each by the values of the right-hand vector
///
/// ````
/// let v1 = C4Vector(x: 1, y: 1)
/// v *= 2.0 //-> v1 = {2,2,0}
/// ````
public func *= (inout lhs: C4Vector, rhs: Double) {
    lhs.x *= rhs
    lhs.y *= rhs
    lhs.z *= rhs
}

/// Transforms the left-hand vector by dividing each by the values of the right-hand vector
///
/// ````
/// let v1 = C4Vector(x: 1, y: 1)
/// v /= 2.0 //-> v = {0.5,0.5,0.0}
/// ````
public func /= (inout lhs: C4Vector, rhs: Double) {
    lhs.x /= rhs
    lhs.y /= rhs
    lhs.z /= rhs
}

/// Returns a new vector whose coordinates are the sum of both input vectors
///
/// ````
/// let v1 = C4Vector(x: 1, y: 1)
/// let v2 = C4Vector(x: 1, y: 0)
/// v1+v2 //-> {2,1,0}
/// ````
public func + (lhs: C4Vector, rhs: C4Vector) -> C4Vector {
    return C4Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

/// Returns a new vector whose coordinates are the subtraction of the right-hand vector from the left-hand vector
///
/// ````
/// var v1 = C4Vector(x: 1, y: 1)
/// var v2 = C4Vector(x: 1, y: 1)
/// v1-v2 //-> {0,0,0}
/// ````
public func - (lhs: C4Vector, rhs: C4Vector) -> C4Vector {
    return C4Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
}

infix operator ⋅ { associativity left precedence 150 }

/// Returns a new vector that is the dot product of the both input vectors. **Use this instead of v.dot(v)**
///
/// ````
/// let v1 = C4Vector(x: 1, y: 1)
/// let v2 = C4Vector(x: -1, y: 1)
/// v1 ⋅ v2 //-> 0.0
/// ````
public func ⋅ (lhs: C4Vector, rhs: C4Vector) -> Double {
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
}

/// Returns a new vector whose coordinates are the division of the left-hand vector coordinates by those of the right-hand vector
///
/// ````
/// var v1 = C4Vector(x: 1, y: 1)
/// var v2 = v1 / 2.0
/// v2 //-> {0.5,0.5,0}
/// ````
public func / (lhs: C4Vector, rhs: Double) -> C4Vector {
    return C4Vector(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
}


/// Returns a new vector whose coordinates are the multiplication of the left-hand vector coordinates by those of the right-hand
/// vector
///
/// ````
/// var v1 = C4Vector(x: 1, y: 1)
/// var v2 = v2 * 2.0
/// v2 //-> {2,2,0}
/// ````
public func * (lhs: C4Vector, rhs: Double) -> C4Vector {
    return C4Vector(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
}


/// Returns a new vector whose coordinates are the multiplication of the right-hand vector coordinates by the left-hand scalar
///
/// ````
/// var v1 = C4Vector(x: 1, y: 1)
/// var v2 = 2.0 * v2
/// v2 //-> {2,2,0}
///
public func * (lhs: Double, rhs: C4Vector) -> C4Vector {
    return C4Vector(x: rhs.x * lhs, y: rhs.y * lhs, z: rhs.z * lhs)
}


/// Returns a new vector whose coordinates are the negative values of the receiver
///
/// ````
/// var v1 = C4Vector(x: 1, y: 1)
/// var v2 = -v1
/// v2 //-> {-1,-1}
/// ````
public prefix func - (vector: C4Vector) -> C4Vector {
    return C4Vector(x: -vector.x, y: -vector.y, z: -vector.z)
}