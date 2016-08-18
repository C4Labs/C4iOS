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

///  The Vector class is used for coordinate values and direction vectors.
public struct Vector: Equatable, CustomStringConvertible {
    /// The x-value of the vector.
    public var x: Double = 0
    /// The y-value of the vector.
    public var y: Double = 0
    /// The z-value of the vector.
    public var z: Double = 0

    /// Creates a vector with default values {0,0,0,}
    /// ````
    /// let v = Vector()
    /// ````
    public init() {
    }

    /// Create a vector with a cartesian representation: an x and a y coordinates. The `z` variable is optional.
    /// ````
    /// let v = Vector(x: 1.0, y: 1.0, z: 1.0)
    /// let v = Vector(x: 1.0, y: 1.0)
    /// ````
    /// - parameter x: the x-value of the new vector
    /// - parameter y: the y-value of the new vector
    /// - parameter z: the z-value of the new vector (defaults to 0)
    public init(x: Double, y: Double, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }

    /// Create a vector with a cartesian representation: an x and a y coordinates.
    /// ````
    /// let v = Vector(x: 1, y: 1, z: 1)
    /// ````
    /// - parameter x: the x-value of the new vector
    /// - parameter y: the y-value of the new vector
    /// - parameter z: the z-value of the new vector (defaults to 0)
    public init(x: Int, y: Int, z: Int = 0) {
        self.x = Double(x)
        self.y = Double(y)
        self.z = Double(z)
    }

    /// Create a vector with a polar representation: a magnitude and an angle in radians. The `z` variable is optional.
    /// [Polar coordinate system - Wikipedia](http://en.wikipedia.org/wiki/Polar_coordinate_system)
    /// ````
    /// let m = sqrt(2.0)
    /// let h = M_PI_4
    /// let v = Vector(magnitude: m, heading: h)
    /// v //-> {1,1,0}
    /// ````
    /// - parameter magnitude: the magnitude of the new vector
    /// - parameter heading: the heading (angle) of the new vector
    /// - parameter z: the z-value of the new vector (defaults to 0)
    public init(magnitude: Double, heading: Double, z: Double = 0) {
        x = magnitude * cos(heading)
        y = magnitude * sin(heading)
        self.z = z
    }

    ///  Initializes a Vector from a CGPoint
    /// - parameter point: a previously initialized CGPoint
    public init(_ point: CGPoint) {
        x = Double(point.x)
        y = Double(point.y)
        z = 0
    }

    ///  Initializes a Vector from a Point
    /// - parameter point: a previously initialized Point
    public init(_ point: Point) {
        x = point.x
        y = point.y
        z = 0
    }

    ///  Initializes a Vector from another Vector
    /// - parameter copy: a previously initialized Vector
    public init(copy original: Vector) {
        x = original.x
        y = original.y
        z = original.z
    }

    /// The polar representation magnitude of the vector.
    /// ````
    /// let v = Vector(x: 2.0, y: 1.0, z: 0.0)
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
    /// ````
    /// let v = Vector(1,1,0)
    /// v.heading //-> M_PI_4
    /// ````
    public var heading: Double {
        get {
            return atan2(y, x)
        }
        set {
            x = magnitude * cos(newValue)
            y = magnitude * sin(newValue)
        }
    }

    /// The angle between two vectors, based on {0,0}
    /// ````
    /// let v1 = Vector(x: 1, y: 1, z: 0)
    /// let v2 = Vector(x: -1, y: 1, z: 0)
    /// v1.angleTo(v2) //-> M_PI_2
    /// ````
    /// - parameter vec: The vector used to calcuate the angle to the receiver
    /// - returns: The angle, measured in radians, between the receiver and `vec`
    public func angleTo(_ vec: Vector) -> Double {
        return acos(self ⋅ (vec / (self.magnitude * vec.magnitude)))
    }

    /// The angle between two vectors, based on a provided point
    /// ````
    /// let v1 = Vector(x: 1, y: 1, z: 0)
    /// let v2 = Vector(x: -1, y: 1, z: 0)
    /// let b = Vector(x: 0, y: 1, z: 0)
    /// v1.angleTo(v2, basedOn: b) //-> PI
    /// ````
    /// - parameter vec: The vector used to calcuate the angle to the receiver
    /// - parameter basedOn: A second vector used to calcuate the angle to the receiver
    /// - returns: The angle, measured in radians, between the receiver and `vec`
    public func angleTo(_ vec: Vector, basedOn: Vector) -> Double {
        var vecA = self
        var vecB = vec

        vecA -= basedOn
        vecB -= basedOn

        return acos(vecA ⋅ (vecB / (vecA.magnitude * vecB.magnitude)))
    }

    /// Return the dot product. **You should use the ⋅ operator instead.**
    /// ````
    /// let v1 = Vector(x: 1, y: 1, z: 0)
    /// let v2 = Vector(x: -1, y: 1, z: 0)
    /// v1.dot(v2) //-> 0.0
    /// ````
    /// - parameter vec: The vector used to calcuate the dot product
    /// - returns: The dot product of the receiver and `vec`
    public func dot(_ vec: Vector) -> Double {
        return x * vec.x + y * vec.y + z * vec.z
    }

    /// Return a vector with the same heading but a magnitude of 1.
    /// ````
    /// let v1 = Vector(x: 1, y: 1, z: 0)
    /// v1.unitVector() //-> {M_PI_4,M_PI_4,0}
    /// ````
    /// - returns: A new vector that is the unit vector of the receiver
    public func unitVector() -> Vector? {
        guard self.magnitude != 0.0 else {
            return nil
        }
        return Vector(x: x / self.magnitude, y: y / self.magnitude, z: z / self.magnitude)
    }

    /// Return `true` if the vector is zero.
    /// ````
    /// let v = Vector()
    /// v.isZero() //-> true
    /// ````
    /// - returns: A boolean, `true` if all values are 0, `false` otherwise
    public func isZero() -> Bool {
        return x == 0 && y == 0 && z == 0
    }

    /// Transform the vector.
    /// ````
    /// var v = Vector(x: 1, y: 1, z:0)
    /// let t = Transform.makeRotation(M_PI, axis: Vector(x: 0, y:0, z:1))
    /// v.transform(t) //-> {-1, -1, 0}
    /// ````
    /// - parameter t: A Transform to apply to the receiver
    public mutating func transform(_ t: Transform) {
        x = x * t[0, 0] + y * t[0, 1] + z * t[0, 2]
        y = x * t[1, 0] + y * t[1, 1] + z * t[1, 2]
        z = x * t[2, 0] + y * t[2, 1] + z * t[2, 2]
    }

    /// A string representation of the vector.
    /// - returns: A string formatted to look like {x,y,z}
    public var description: String {
        return "{\(x), \(y), \(z)}"
    }
}

/// Returns true if the coordinates of both vectors are identical
///
/// ````
/// let v1 = Vector(x: 1, y: 1)
/// let v2 = Vector(x: 1, y: 0)
/// v1 == v2 //-> false
/// ````
/// - parameter lhs: A Vector
/// - parameter rhs: A Vector
/// - returns: A boolean, `true` if the vectors are equal, `false` otherwise
public func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

/// Transforms the left-hand vector by adding the values of the right-hand vector
///
/// ````
/// let v1 = Vector(x: 1, y: 1)
/// let v2 = Vector(x: 1, y: 0)
/// v1 += v2 //-> v1 = {2,1,0}
/// ````
/// - parameter lhs: A Vector to which the values of `rhs` will be added
/// - parameter rhs: A Vector
public func += (lhs: inout Vector, rhs: Vector) {
    lhs.x += rhs.x
    lhs.y += rhs.y
    lhs.z += rhs.z
}

/// Transforms the left-hand vector by subtracting the values of the right-hand vector
///
/// ````
/// let v1 = Vector(x: 1, y: 1)
/// let v2 = Vector(x: 1, y: 0)
/// v1 += v2 //-> v1 = {0,1,0}
/// ````
/// - parameter lhs: A Vector to which the values of `rhs` will be subtracted
/// - parameter rhs: A Vector
public func -= (lhs: inout Vector, rhs: Vector) {
    lhs.x -= rhs.x
    lhs.y -= rhs.y
    lhs.z -= rhs.z
}

/// Transforms the left-hand vector by multiplying each by the values of the right-hand vector
///
/// ````
/// let v1 = Vector(x: 1, y: 1)
/// v *= 2.0 //-> v1 = {2,2,0}
/// ````
/// - parameter lhs: A Vector whose values will be multiplied by `rhs`
/// - parameter rhs: A scalar value
public func *= (lhs: inout Vector, rhs: Double) {
    lhs.x *= rhs
    lhs.y *= rhs
    lhs.z *= rhs
}

/// Transforms the left-hand vector by dividing each by the values of the right-hand vector
///
/// ````
/// let v1 = Vector(x: 1, y: 1)
/// v /= 2.0 //-> v = {0.5,0.5,0.0}
/// ````
/// - parameter lhs: A Vector whose values will be divided by `rhs`
/// - parameter rhs: A scalar value
public func /= (lhs: inout Vector, rhs: Double) {
    lhs.x /= rhs
    lhs.y /= rhs
    lhs.z /= rhs
}

/// Returns a new vector whose coordinates are the sum of both input vectors
///
/// ````
/// let v1 = Vector(x: 1, y: 1)
/// let v2 = Vector(x: 1, y: 0)
/// v1+v2 //-> {2,1,0}
/// ````
/// - parameter lhs: A Vector
/// - parameter rhs: A Vector
/// - returns: A new vector whose values are the sum of `lhs` and `rhs`
public func + (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

/// Returns a new vector whose coordinates are the subtraction of the right-hand vector from the left-hand vector
///
/// ````
/// var v1 = Vector(x: 1, y: 1)
/// var v2 = Vector(x: 1, y: 1)
/// v1-v2 //-> {0,0,0}
/// ````
/// - parameter lhs: A Vector
/// - parameter rhs: A Vector
/// - returns: A new vector whose values are the difference of `lhs` and `rhs`
public func - (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
}

infix operator ⋅

/// Returns a new vector that is the dot product of the both input vectors. **Use this instead of v.dot(v)**
///
/// ````
/// let v1 = Vector(x: 1, y: 1)
/// let v2 = Vector(x: -1, y: 1)
/// v1 ⋅ v2 //-> 0.0
/// ````
/// - parameter lhs: A Vector
/// - parameter rhs: A Vector
/// - returns: The dot product of `lhs` and `rhs`
public func ⋅ (lhs: Vector, rhs: Vector) -> Double {
    return lhs.x * rhs.x + lhs.y * rhs.y + lhs.z * rhs.z
}

/// Returns a new vector whose coordinates are the division of the left-hand vector coordinates by those of the right-hand vector
///
/// ````
/// var v1 = Vector(x: 1, y: 1)
/// var v2 = v1 / 2.0
/// v2 //-> {0.5,0.5,0}
/// ````
/// - parameter lhs: A Vector
/// - parameter rhs: A scalar
/// - returns: A new vector whose values are those of `lhs` divided by `rhs`
public func / (lhs: Vector, rhs: Double) -> Vector {
    return Vector(x: lhs.x / rhs, y: lhs.y / rhs, z: lhs.z / rhs)
}

/// Returns a new vector whose coordinates are the multiplication of the left-hand vector coordinates by those of the right-hand
/// vector
///
/// ````
/// var v1 = Vector(x: 1, y: 1)
/// var v2 = v2 * 2.0
/// v2 //-> {2,2,0}
/// ````
/// - parameter lhs: A Vector
/// - parameter rhs: A scalar
/// - returns: A new vector whose values are those of `lhs` multiplied by `rhs`
public func * (lhs: Vector, rhs: Double) -> Vector {
    return Vector(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
}

/// Returns a new vector whose coordinates are the multiplication of the right-hand vector coordinates by the left-hand scalar
///
/// ````
/// var v1 = Vector(x: 1, y: 1)
/// var v2 = 2.0 * v2
/// v2 //-> {2,2,0}
/// - parameter lhs: A scalar
/// - parameter rhs: A Vector
/// - returns: A new vector whose values are those of `lhs` divided by `rhs`
public func * (lhs: Double, rhs: Vector) -> Vector {
    return Vector(x: rhs.x * lhs, y: rhs.y * lhs, z: rhs.z * lhs)
}

/// Returns a new vector whose coordinates are the negative values of the receiver
///
/// ````
/// var v1 = Vector(x: 1, y: 1)
/// var v2 = -v1
/// v2 //-> {-1,-1}
/// ````
/// - parameter vector: A Vector
/// - returns: A new vector whose values are the negative of `vector`
public prefix func - (vector: Vector) -> Vector {
    return Vector(x: -vector.x, y: -vector.y, z: -vector.z)
}
