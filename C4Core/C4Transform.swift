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

public struct C4Transform : Equatable {
    public var a: Double = 1
    public var b: Double = 0
    public var c: Double = 0
    public var d: Double = 1
    public var tx: Double = 0
    public var ty: Double = 1
    
    public init() {
    }
    
    public init(a: Double, b: Double, c: Double, d: Double, tx: Double, ty: Double) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.tx = tx;
        self.ty = ty;
    }
    
    public var translation: C4Vector {
        get {
            return C4Vector(x: tx, y: ty)
        }
        set {
            tx = newValue.x
            ty = newValue.y
        }
    }
    
    public static func makeTranslation(translation: C4Vector) -> C4Transform {
        return C4Transform(a: 1, b: 0, c: 0, d:1, tx: translation.x, ty: translation.y)
    }
    
    public static func makeScale(sx: Double, _ sy: Double) -> C4Transform {
        return C4Transform(a: sx, b: 0, c: 0, d:sy, tx: 0, ty: 0)
    }
    
    public static func makeRotation(angle: Double) -> C4Transform {
        return C4Transform(a: cos(angle), b: sin(angle), c: -sin(angle), d:cos(angle), tx:0, ty:0)
    }
    
    public mutating func translate(translation: C4Vector) {
        let t = C4Transform.makeTranslation(translation)
        self = concat(self, t)
    }
    
    public mutating func scale(sx: Double, sy: Double) {
        let s = C4Transform.makeScale(sx, sy)
        self = concat(self, s)
    }
    
    public mutating func rotate(angle: Double) {
        let r = C4Transform.makeRotation(angle)
        self = concat(self, r)
    }
}

public func == (lhs: C4Transform, rhs: C4Transform) -> Bool {
    return lhs.a == rhs.a && lhs.b == rhs.b && lhs.c == rhs.c && lhs.d == rhs.d && lhs.tx == rhs.tx && lhs.ty == rhs.ty
}

/**
  Transform matrix multiplication
 */
public func * (lhs: C4Transform, rhs: C4Transform) -> C4Transform {
    return C4Transform(
        a: lhs.a * rhs.a + lhs.b * rhs.c,
        b: lhs.a * rhs.b + lhs.b * rhs.d,
        c: lhs.c * rhs.a + lhs.d * rhs.c,
        d: lhs.c * rhs.b + lhs.d * rhs.d,
        tx: lhs.a * rhs.tx + lhs.b * rhs.ty + lhs.tx,
        ty: lhs.c * rhs.tx + lhs.d * rhs.ty + lhs.ty)
}

/**
  Transform matrix scalar multiplication
*/
public func * (t: C4Transform, s: Double) -> C4Transform {
    return C4Transform(
        a: t.a * s,
        b: t.b * s,
        c: t.c * s,
        d: t.d * s,
        tx: t.tx * s,
        ty: t.ty * s)
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
public func inverse(t: C4Transform) -> C4Transform {
    let det = t.a * t.d - t.b * t.c;
    if det == 0.0 {
        return t;
    }
    
    let invdet = 1.0 / det
    return C4Transform(a: t.d, b: -t.b, c: -t.c, d: t.a, tx: (t.b * t.ty - t.tx * t.d), ty: (t.c * t.tx - t.a * t.ty)) * invdet
}
