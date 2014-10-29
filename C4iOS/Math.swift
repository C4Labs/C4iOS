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

public protocol NumericType : Comparable, Equatable {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    func %(lhs: Self, rhs: Self) -> Self
    init(_ v: Double)
    init(_ v: Float)
    init(_ v: Int)
    init(_ v: Int8)
    init(_ v: Int16)
    init(_ v: Int32)
    init(_ v: Int64)
    init(_ v: UInt)
    init(_ v: UInt8)
    init(_ v: UInt16)
    init(_ v: UInt32)
    init(_ v: UInt64)

    func doubleValue() -> Double;
}

extension Int    : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}
extension Int8   : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}
extension Int16  : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}
extension Int32  : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}
extension Int64  : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}
extension UInt   : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}
extension UInt8  : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}
extension UInt16 : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}
extension UInt32 : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}
extension UInt64 : NumericType {
    public func doubleValue() -> Double { return Double(self) }
}

public protocol FloatType : NumericType {}

extension Double : FloatType {
    public func doubleValue() -> Double { return self }
}
extension Float  : FloatType {
    public func doubleValue() -> Double { return Double(self) }
}
extension CGFloat: FloatType {
    public func doubleValue() -> Double { return Double(self) }
}


/**
Clamp a value to the range [min, max].

:param: val The value
:param: min The lower bound
:param: max The upper bound

:returns: The clamped value
*/
public func clamp<T : Comparable>(val: T, min: T, max: T) -> T {
    assert(min < max, "min has to be less than max")
    if val < min { return min }
    if val > max { return max }
    return val
}

/**
Linear interpolation. For any two values a and b return a linear interpolation with parameter `param`.

:param: a     first value
:param: b     second value
:param: param parameter between 0 and 1 for interpolation

:returns: The interpolated value
*/
public func lerp<T : NumericType>(a: T, b: T, param: Double) -> T {
    assert(a < b, "a must be less than b")
    return a + T((b - a).doubleValue() * param)
}

/**
Linear mapping. Maps a value in the source range [min, max] to a value in the target range [toMin, toMax] using linear interpolation.

:param: val   Source value
:param: min   Source range lower bound
:param: max   Source range upper bound
:param: toMin Target range lower bound
:param: toMax Target range upper bound

:returns: The mapped value.
*/
public func map<T: NumericType>(val: T, min: T, max: T, toMin: T, toMax: T) -> T {
    assert(min < max, "min has to be less than max")
    var param = val.doubleValue() / (max - min).doubleValue() - min.doubleValue()
    return lerp(toMin, toMax, param)
}

/**
Return a random integer below `below`

:param: below The upper bound

:returns: A random value smaller than `below`
*/
public func random(#below: Int) -> Int {
    return Int(arc4random_uniform(UInt32(below)))
}

/**
Return a random integer greater than or equal to min and less than max.

:param: min The lower bound
:param: max The upper bound

:returns: A random value greater than or equal to min and less than max.
*/
public func random(min: Int, max: Int) -> Int {
    assert(min < max, "min must be less than max")
    return min + random(below: max - min)
}

/**
Return a random Double in the interval [0, 1)

:returns: A random Double uniformly distributed between 0 and 1
*/
func random01() -> Double {
    return Double(arc4random()) / Double(UInt32.max)
}

public func radToDeg<T: FloatType>(val: T) -> T {
    return T(180) * val / T(M_PI)
}

public func degToRad<T: FloatType>(val: T) -> T {
    return T(M_PI) * val / T(180)
}

public func rgbToFloat<T: FloatType>(val: T) -> Double {
    return val.doubleValue()/255.0
}

public func floatToRGB<T: FloatType>(val: T) -> Double {
    return val.doubleValue() * 255.0
}