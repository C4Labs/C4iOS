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


/// Prints a string to the console. Replacement for the noisy NSlog.
///
/// ````
/// C4Log("A message")
/// C4Log(0)
/// ````
///
/// - parameter value: An object to print to the console
public func C4Log<T>(_ value: T) {
    print("[C4Log] \(value)")
}


/// Returns a rectangle that contains all of the specified coordinates in an array.
///
/// ````
/// let points = [CGPointZero,CGPointMake(10,10)]
/// let cgrect = CGRectMakeFromPoints(points)
/// ````
///
/// - parameter points: An array of CGPoint coordinates
/// - returns: The smallest CGRect that contains all of the points in the specified array
public func CGRectMakeFromPoints(_ points: [CGPoint]) -> CGRect {
    let path = CGMutablePath()
    path.move(to: points[0])
    for i in 1..<points.count {
        path.addLine(to: points[i])
    }
    return path.boundingBox
}

/// Sets a time to wait before executing of a block of code.
///
/// ````
/// wait(0.25) {
///     //code to execute
/// }
/// ````
///
/// - parameter delay:  The amount of time in seconds to wait before executing the block of code.
/// - parameter action: A block of code to perform after the delay.
public func wait(_ seconds: Double, action: @escaping ()->()) {
    DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + seconds, execute: action)
}
