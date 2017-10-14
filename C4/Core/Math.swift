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
public func lerp<T: FloatingPoint>(_ a: T, _ b: T, at: T) -> T {
    return a + (b - a) * at
}

/// Linear mapping. Maps a value in the source range [min, max) to a value in the target range [toMin, toMax) using linear interpolation.
///
/// ````
/// map(10, 0..<20, 0..<200) = 100
/// map(10, 0..<100, 200..<300) = 210
/// map(10, 0..<20, 200..<300) = 250
/// ````
///
/// - parameter val:   Source value
/// - parameter min:   Source range lower bound
/// - parameter max:   Source range upper bound
/// - parameter toMin: Target range lower bound
/// - parameter toMax: Target range upper bound
///
/// - returns: The mapped value.
public func map<T: FloatingPoint>(_ val: T, from: Range<T>, to: Range<T>) -> T {
    let param = (val - from.lowerBound)/(from.upperBound -  from.lowerBound)
    return lerp(to.lowerBound, to.upperBound, at: param)
}

/// Linear mapping. Maps a value in the source range [min, max] to a value in the target range [toMin, toMax] using linear interpolation.
///
/// ````
/// map(10, 0...20, 0...200) = 100
/// map(10, 0...100, 200...300) = 210
/// map(10, 0...20, 200...300) = 250
/// ````
///
/// - parameter val:   Source value
/// - parameter min:   Source range lower bound
/// - parameter max:   Source range upper bound
/// - parameter toMin: Target range lower bound
/// - parameter toMax: Target range upper bound
///
/// - returns: The mapped value.
public func map<T: FloatingPoint>(_ val: T, from: ClosedRange<T>, to: ClosedRange<T>) -> T {
    let param = (val - from.lowerBound) / (from.upperBound - from.lowerBound)
    return lerp(to.lowerBound, to.upperBound, at: param)
}

/// Returns a random `Int`.
///
/// ````
/// let x = random()
/// ````
///
/// - returns: Random `Int`.
public func random() -> Int {
    var r = 0
    withUnsafeMutableBytes(of: &r) { bufferPointer in
        arc4random_buf(bufferPointer.baseAddress, MemoryLayout<Int>.size)
    }
    return r
}

/// Return a random integer below `below`
///
/// ````
/// let x = random(below: 20)
/// ````
///
/// - parameter below: The upper bound
///
/// - returns: A random value in the range `0 ..< below`
public func random(below: Int) -> Int {
    return abs(random()) % below
}

/// Return a random integer in the given range.
///
/// ````
/// let x = random(in: 10..<20)
/// ````
///
/// - parameter range: range of values
///
/// - returns: A random value greater than or equal to min and less than max.
public func random(in range: Range<Int>) -> Int {
    return range.lowerBound + random(below: range.upperBound - range.lowerBound)
}

/// Return a random Double in the given range.
///
/// ````
/// let x = random(in: 0..<1)
/// ````
///
/// - parameter range: range of values
/// - returns: A random Double uniformly distributed between 0 and 1
public func random(in range: Range<Double>) -> Double {
    let intRange: Range<Double> = Double(-Int.max) ..< Double(Int.max) + 1
    let r = Double(random())
    return map(r, from: intRange, to: range)
}

/// Converts radian values to degrees.
///
/// Uses the following equation: value * 180.0 / PI
///
/// ````
/// radToDeg(Double.pi) = 180
/// radToDeg(Double.pi / 2.0) = 90
/// ````
///
/// - parameter val: The value in radians.
/// - returns: A double value representation of the radian value in degrees.
public func radToDeg(_ val: Double) -> Double {
    return 180.0 * val / Double.pi
}

/// Converts degree values to radians.
///
/// Uses the following equation: value * PI / 180.0
///
/// ````
/// degToRad(270) = 3*Double.pi / 2.0 (4.712...)
/// degToRad(360) = 2*PI (6.283...)
/// ````
///
/// - parameter val: The value in degrees.
/// - returns: A double value representation of the degree value in radians.
public func degToRad(_ val: Double) -> Double {
    return Double.pi * val / 180.0
}
