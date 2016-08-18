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

import Foundation

/// Clamp a value to the range [min, max].
///
/// If the value is less than min this function returns min, if the value is greater than max the function returns max,
/// otherwise it returns the value.
///
/// ````
/// clamp(10, 0, 5) = 5
/// clamp(10, 0, 20) = 10
/// clamp(10,20,30) = 20
/// ````
///
/// - parameter val: The value
/// - parameter min: The lower bound
/// - parameter max: The upper bound
///
/// - returns: The clamped value
public func clamp<T: Comparable>(_ val: T, min: T, max: T) -> T {
    assert(min < max, "min has to be less than max")
    if val < min { return min }
    if val > max { return max }
    return val
}

/// Linear interpolation. For any two values a and b return a linear interpolation with parameter `param`.
///
/// ````
/// lerp(0, 100, 0.5) = 50
/// lerp(100, 200, 0.5) = 150
/// lerp(500, 1000, 0.33) = 665
/// ````
///
/// - parameter a:     first value
/// - parameter b:     second value
/// - parameter param: parameter between 0 and 1 for interpolation
///
/// - returns: The interpolated value
public func lerp(_ a: Double, _ b: Double, at: Double) -> Double {
    return a + (b - a) * at
}

/// Linear mapping. Maps a value in the source range [min, max] to a value in the target range [toMin, toMax] using linear interpolation.
///
/// ````
/// map(10, 0, 20, 0, 200) = 100
/// map(10, 0, 100, 200, 300) = 210
/// map(10, 0, 20, 200, 300) = 250
/// ````
///
/// - parameter val:   Source value
/// - parameter min:   Source range lower bound
/// - parameter max:   Source range upper bound
/// - parameter toMin: Target range lower bound
/// - parameter toMax: Target range upper bound
///
/// - returns: The mapped value.
public func map(_ val: Double, min: Double, max: Double, toMin: Double, toMax: Double) -> Double {
    let param = (val - min)/(max -  min)
    return lerp(toMin, toMax, at: param)
}

/// Return a random integer below `below`
///
/// ````
/// let x = random(below: 20)
/// ````
///
/// - parameter below: The upper bound
///
/// - returns: A random value smaller than `below`
public func random(below: Int) -> Int {
    return Int(arc4random_uniform(UInt32(below)))
}

/// Return a random integer greater than or equal to min and less than max.
///
/// ````
/// let x = random(10,20)
/// ````
///
/// - parameter min: The lower bound
/// - parameter max: The upper bound
///
/// - returns: A random value greater than or equal to min and less than max.
public func random(min: Int, max: Int) -> Int {
    assert(min < max, "min must be less than max")
    return min + random(below: max - min)
}

/// Return a random Double in the interval [0, 1)
///
/// ````
/// let x = random01()
/// ````
///
/// - returns: A random Double uniformly distributed between 0 and 1
public func random01() -> Double {
    return Double(arc4random()) / Double(UInt32.max)
}

/// Converts radian values to degrees.
///
/// Uses the following equation: value * 180.0 / PI
///
/// ````
/// radToDeg(M_PI) = 180
/// radToDeg(M_PI_2) = 90
/// ````
///
/// - parameter val: The value in radians.
/// - returns: A double value representation of the radian value in degrees.
public func radToDeg(_ val: Double) -> Double {
    return 180.0 * val / M_PI
}

/// Converts degree values to radians.
///
/// Uses the following equation: value * PI / 180.0
///
/// ````
/// degToRad(270) = 3*M_PI_2 (4.712...)
/// degToRad(360) = 2*PI (6.283...)
/// ````
///
/// - parameter val: The value in degrees.
/// - returns: A double value representation of the degree value in radians.
public func degToRad(_ val: Double) -> Double {
    return M_PI * val / 180.0
}
