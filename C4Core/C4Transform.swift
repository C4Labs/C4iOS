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

public struct C4Transform : Equatable {
    private var matrix = [Double](count: 16, repeatedValue: 0)
    
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
    
    public init() {
        self[0, 0] = 1
        self[1, 1] = 1
        self[2, 2] = 1
        self[3, 3] = 1
    }
    
    public init(_ t: CGAffineTransform) {
        self.init()
        self[0, 0] = Double(t.a)
        self[0, 1] = Double(t.b)
        self[1, 0] = Double(t.c)
        self[1, 1] = Double(t.d)
        self[0, 3] = Double(t.tx)
        self[1, 3] = Double(t.ty)
    }
    
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
    
    public func isAffine() -> Bool {
        return self[3, 0] == 0.0 && self[3, 1] == 0.0 && self[3, 2] == 0.0 && self[3, 3] == 1.0
    }
    
    public var translation: C4Vector {
        get {
            return C4Vector(x: self[0, 3], y: self[1, 3])
        }
        set {
            self[0, 3] = newValue.x
            self[1, 3] = newValue.y
        }
    }
    
    public static func makeTranslation(translation: C4Vector) -> C4Transform {
        var t = C4Transform()
        t[0, 3] = translation.x
        t[1, 3] = translation.y
        return t
    }
    
    public static func makeScale(sx: Double, _ sy: Double, _ sz: Double = 1) -> C4Transform {
        var t = C4Transform()
        t[0, 0] = sx
        t[1, 1] = sy
        t[2, 2] = sz
        return t
    }
    
    public static func makeRotation(angle: Double, axis: C4Vector = C4Vector(x: 0, y: 0, z : 1)) -> C4Transform {
        if axis.isZero() {
            return C4Transform()
        }
        
        let unitAxis = axis.unitVector()!
        let ux = unitAxis.x
        let uy = unitAxis.y
        let uz = unitAxis.z
        
        let ca = cos(angle)
        let sa = sin(angle)
        
        var t = C4Transform()
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
    
    public mutating func translate(translation: C4Vector) {
        let t = C4Transform.makeTranslation(translation)
        self = concat(self, t)
    }
    
    public mutating func scale(sx: Double, _ sy: Double, _ sz: Double = 1) {
        let s = C4Transform.makeScale(sx, sy, sz)
        self = concat(self, s)
    }
    
    public mutating func rotate(angle: Double, axis: C4Vector = C4Vector(x: 0, y: 0, z: 1)) {
        let r = C4Transform.makeRotation(angle, axis: axis)
        self = concat(self, r)
    }
    
    public var affineTransform: CGAffineTransform {
        return CGAffineTransform(
            a:  CGFloat(self[0, 0]),
            b:  CGFloat(self[0, 1]),
            c:  CGFloat(self[1, 0]),
            d:  CGFloat(self[1, 1]),
            tx: CGFloat(self[0, 3]),
            ty: CGFloat(self[1, 3]))
    }
    
    public var transform3D: CATransform3D {
        var t = CATransform3D(
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

public func == (lhs: C4Transform, rhs: C4Transform) -> Bool {
    var equal = true
    for col in 0...3 {
        for row in 0...3 {
            equal &= lhs[row, col] == rhs[row, col]
        }
    }
    return equal
}

/**
  Transform matrix multiplication
 */
public func * (lhs: C4Transform, rhs: C4Transform) -> C4Transform {
    var t = C4Transform()
    for col in 0...3 {
        for row in 0...3 {
            t[row, col] = lhs[row, 0] * rhs[0, col] + lhs[row, 1] * rhs[1, col] + lhs[row, 2] * rhs[2, col] + lhs[row, 3] * rhs[3, col]
        }
    }
    return t
}

/**
  Transform matrix scalar multiplication
*/
public func * (t: C4Transform, s: Double) -> C4Transform {
    var r = C4Transform()
    for col in 0...3 {
        for row in 0...3 {
            r[row, col] = t[row, col] * s
        }
    }
    return r
}

/**
  Transform matrix scalar multiplication
*/
public func * (s: Double, t: C4Transform) -> C4Transform {
    return t * s
}

/**
  Concatenate two transformations. This is the same as t2 * t1.
 */
public func concat(t1: C4Transform, t2: C4Transform) -> C4Transform {
    return t2 * t1
}

/**
  Calculates the inverse of a transfomation.
 */
public func inverse(t: C4Transform) -> C4Transform? {
    var N: __CLPK_integer = 4
    var error: __CLPK_integer = 0
    var pivot = [__CLPK_integer](count: 4, repeatedValue: 0)
    var matrix: [__CLPK_doublereal] = t.matrix
    
    // LU factorisation
    dgetrf_(&N, &N, &matrix, &N, &pivot, &error);
    if error != 0 {
        return nil;
    }
    
    // matrix inversion
    var workspace = [__CLPK_doublereal](count: 4, repeatedValue: 0)
    dgetri_(&N, &matrix, &N, &pivot, &workspace, &N, &error);
    if error != 0 {
        return nil;
    }
    
    var r = C4Transform()
    r.matrix = matrix
    return r;
}
