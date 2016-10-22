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

import Accelerate
import CoreGraphics
import QuartzCore

///  A structure for holding a transform matrix.
///
///  Transform can translate, rotate, scale.
public struct Transform: Equatable {
    var matrix = [Double](repeating: 0, count: 16)

    public subscript(row: Int, col: Int) -> Double {
        get {
            assert(row >= 0 && row < 4, "Row index out of bounds")
            assert(col >= 0 && col < 4, "Column index out of bounds")
            return matrix[row + col * 4]
        }
        set {
            assert(row >= 0 && row < 4, "Row index out of bounds")
            assert(col >= 0 && col < 4, "Column index out of bounds")
            matrix[row + col * 4] = newValue
        }
    }

    ///  Initializes a Transform. Defaults to an identity transform.
    public init() {
        self[0, 0] = 1
        self[1, 1] = 1
        self[2, 2] = 1
        self[3, 3] = 1
    }

    /// Creates a new transform from a `CGAffineTransform` structure.
    /// - parameter t: A `CGAffineTransform` structure.
    public init(_ t: CGAffineTransform) {
        self.init()
        self[0, 0] = Double(t.a)
        self[0, 1] = Double(t.b)
        self[1, 0] = Double(t.c)
        self[1, 1] = Double(t.d)
        self[0, 3] = Double(t.tx)
        self[1, 3] = Double(t.ty)
    }

    /// Creates a new transform from a `CATransform3D` structure.
    /// - parameter t: A `CATransform3D` structure.
    public init(_ t: CATransform3D) {
        self[0, 0] = Double(t.m11)
        self[0, 1] = Double(t.m12)
        self[0, 2] = Double(t.m13)
        self[0, 3] = Double(t.m14)
        self[1, 0] = Double(t.m21)
        self[1, 1] = Double(t.m22)
        self[1, 2] = Double(t.m23)
        self[1, 3] = Double(t.m24)
        self[2, 0] = Double(t.m31)
        self[2, 1] = Double(t.m32)
        self[2, 2] = Double(t.m33)
        self[2, 3] = Double(t.m34)
        self[3, 0] = Double(t.m41)
        self[3, 1] = Double(t.m42)
        self[3, 2] = Double(t.m43)
        self[3, 3] = Double(t.m44)
    }

    /// Returns `true` if transform is affine, otherwise `false`.
    public func isAffine() -> Bool {
        return self[3, 0] == 0.0 && self[3, 1] == 0.0 && self[3, 2] == 0.0 && self[3, 3] == 1.0
    }

    /// The translation component of the tranform.
    /// - returns: A `Vector` that represents the translation of the transform, where x = [0,3], y = [1,3]
    public var translation: Vector {
        get {
            return Vector(x: self[3, 0], y: self[3, 1])
        }
        set {
            self[3, 0] = newValue.x
            self[3, 1] = newValue.y
        }
    }

    /// Creates a transform that represents a translation in 2d (x,y)
    /// ````
    /// let v = Vector(x: 1, y: 1)
    /// let t = Transform.makeTranslation(v)
    /// ````
    /// - parameter translation: A `Vector` that represents the translation to apply.
    /// - returns: A `Transform` that can be used to apply a translation to a receiver.
    public static func makeTranslation(_ translation: Vector) -> Transform {
        var t = Transform()
        t[3, 0] = translation.x
        t[3, 1] = translation.y
        return t
    }

    /// Creates a transform that represents a scale in 3d (x, y, z). The `z` component is optional.
    /// ````
    /// let t = Transform.makeScale(2.0, 2.0)
    /// ````
    /// - parameter sx: The amount to scale in the `x` axis
    /// - parameter sy: The amount to scale in the `y` axis
    /// - parameter sz: The amount to scale in the `z` axis
    /// - returns: A `Transform` that can be used to scale a receiver.
    public static func makeScale(_ sx: Double, _ sy: Double, _ sz: Double = 1) -> Transform {
        var t = Transform()
        t[0, 0] = sx
        t[1, 1] = sy
        t[2, 2] = sz
        return t
    }

    /// Creates a transform that represents a rotation. The `axis` component is optional.
    /// ````
    /// let t = Transform.makeRotation(M_PI)
    /// ````
    /// - parameter angle: The angle, in radians, to rotate
    /// - parameter axis: The axis around which to rotate, defaults to the z axis {0,0,1}
    /// - returns: A `Transform` that can be used to rotate a receiver.
    public static func makeRotation(_ angle: Double, axis: Vector = Vector(x: 0, y: 0, z : 1)) -> Transform {
        if axis.isZero() {
            return Transform()
        }

        let unitAxis = axis.unitVector()!
        let ux = unitAxis.x
        let uy = unitAxis.y
        let uz = unitAxis.z

        let ca = cos(angle)
        let sa = sin(angle)

        var t = Transform()
        t[0, 0] = ux * ux * (1 - ca) + ca
        t[0, 1] = ux * uy * (1 - ca) - uz * sa
        t[0, 2] = ux * uz * (1 - ca) + uy * sa
        t[1, 0] = uy * ux * (1 - ca) + uz * sa
        t[1, 1] = uy * uy * (1 - ca) + ca
        t[1, 2] = uy * uz * (1 - ca) - ux * sa
        t[2, 0] = uz * ux * (1 - ca) - uy * sa
        t[2, 1] = uz * uy * (1 - ca) + ux * sa
        t[2, 2] = uz * uz * (1 - ca) + ca
        return t
    }

    /// Applies a translation to the receiver.
    /// ````
    /// let v = Vector(x: 1, y: 1)
    /// let t = Transform()
    /// t.translate(v)
    /// ````
    /// - parameter translation: A `Vector` that represents the translation to apply.
    public mutating func translate(_ translation: Vector) {
        let t = Transform.makeTranslation(translation)
        self = concat(self, t2: t)
    }

    /// Applies a scale to the receiver. The `z` variable is optional.
    /// ````
    /// let t = Transform()
    /// t.scale(2.0, 2.0)
    /// ````
    /// - parameter sx: The amount to scale in the `x` axis
    /// - parameter sy: The amount to scale in the `y` axis
    /// - parameter sz: The amount to scale in the `z` axis
    public mutating func scale(_ sx: Double, _ sy: Double, _ sz: Double = 1) {
        let s = Transform.makeScale(sx, sy, sz)
        self = concat(self, t2: s)
    }

    /// Applies a rotation. The `axis` component is optional.
    /// ````
    /// let t = Transform()
    /// t.rotate(M_PI)
    /// ````
    /// - parameter angle: The angle, in radians, to rotate
    /// - parameter axis: The axis around which to rotate, defaults to the z axis {0,0,1}
    public mutating func rotate(_ angle: Double, axis: Vector = Vector(x: 0, y: 0, z: 1)) {
        let r = Transform.makeRotation(angle, axis: axis)
        self = concat(self, t2: r)
    }

    /// The CGAffineTransform version of the receiver.
    /// - returns: A `CGAffineTransform` that is equivalent to the receiver.
    public var affineTransform: CGAffineTransform {
        return CGAffineTransform(
            a:  CGFloat(self[0, 0]),
            b:  CGFloat(self[0, 1]),
            c:  CGFloat(self[1, 0]),
            d:  CGFloat(self[1, 1]),
            tx: CGFloat(self[0, 3]),
            ty: CGFloat(self[1, 3]))
    }

    /// The CATransform3D version of the receiver.
    /// - returns: A `CATransform3D` that is equivalent to the receiver.
    public var transform3D: CATransform3D {
        let t = CATransform3D(
            m11: CGFloat(self[0, 0]),
            m12: CGFloat(self[0, 1]),
            m13: CGFloat(self[0, 2]),
            m14: CGFloat(self[0, 3]),
            m21: CGFloat(self[1, 0]),
            m22: CGFloat(self[1, 1]),
            m23: CGFloat(self[1, 2]),
            m24: CGFloat(self[1, 3]),
            m31: CGFloat(self[2, 0]),
            m32: CGFloat(self[2, 1]),
            m33: CGFloat(self[2, 2]),
            m34: CGFloat(self[2, 3]),
            m41: CGFloat(self[3, 0]),
            m42: CGFloat(self[3, 1]),
            m43: CGFloat(self[3, 2]),
            m44: CGFloat(self[3, 3])
        )
        return t
    }
}

/// Returns true if the two source Transform structs share identical dimensions
/// - parameter lhs: The first transform to compare
/// - parameter rhs: The second transform to compare
/// - returns: A boolean, `true` if the both transforms are equal
public func == (lhs: Transform, rhs: Transform) -> Bool {
    var equal = true
    for col in 0...3 {
        for row in 0...3 {
            equal = equal && lhs[row, col] == rhs[row, col]
        }
    }
    return equal
}

/// Transform matrix multiplication
/// - parameter lhs: The first transform to multiply
/// - parameter rhs: The second transform to multiply
/// - returns: A new transform that is the result of multiplying `lhs` and `rhs`
public func * (lhs: Transform, rhs: Transform) -> Transform {
    var t = Transform()
    for col in 0...3 {
        for row in 0...3 {
            t[row, col] = lhs[row, 0] * rhs[0, col] + lhs[row, 1] * rhs[1, col] + lhs[row, 2] * rhs[2, col] + lhs[row, 3] * rhs[3, col]
        }
    }
    return t
}

/// Transform matrix scalar multiplication
/// - parameter t: The transform to scale
/// - parameter s: A scalar value to apply to the transform
/// - returns: A new trasform whose values are the scalar multiple of `t`
public func * (t: Transform, s: Double) -> Transform {
    var r = Transform()
    for col in 0...3 {
        for row in 0...3 {
            r[row, col] = t[row, col] * s
        }
    }
    return r
}


/// Transform matrix scalar multiplication
/// - parameter s: A scalar value to apply to the transform
/// - parameter t: The transform to scale
/// - returns: A new trasform whose values are the scalar multiple of `t`
public func * (s: Double, t: Transform) -> Transform {
    return t * s
}


/// Concatenate two transformations. This is the same as t2 * t1.
/// - parameter t1: The first transform to contatenate
/// - parameter t2: The second transform to contatenate
/// - returns: A new transform that is the contcatenation of `t1` and `t2`
public func concat(_ t1: Transform, t2: Transform) -> Transform {
    return t2 * t1
}

/// Calculates the inverse of a transfomation.
/// - parameter t: The transform to invert
/// - returns: A new transform that is the inverse of `t`
public func inverse(_ t: Transform) -> Transform? {
    var N: __CLPK_integer = 4
    var error: __CLPK_integer = 0
    var pivot = [__CLPK_integer](repeating: 0, count: 4)
    var matrix: [__CLPK_doublereal] = t.matrix

    // LU factorisation
    dgetrf_(&N, &N, &matrix, &N, &pivot, &error)
    if error != 0 {
        return nil
    }

    // matrix inversion
    var workspace = [__CLPK_doublereal](repeating: 0, count: 4)
    dgetri_(&N, &matrix, &N, &pivot, &workspace, &N, &error)
    if error != 0 {
        return nil
    }

    var r = Transform()
    r.matrix = matrix
    return r
}
