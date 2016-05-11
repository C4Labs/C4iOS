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

import QuartzCore
import UIKit

///  QuadCurve is a concrete subclass of Curve that modifies it shape based on a single point rather than 2 used by its parent class.
public class QuadCurve: Curve {

    /// A Point used to calculate the shape of the quadratic curve.
    public var controlPoint: Point {
        get {
            return controlPoints.0
        } set {
            self.controlPoints = (newValue, newValue)
        }
    }

    /// Initializes a new QuadCurve.
    ///
    /// ````
    /// let curve = QuadCurve(a: Point(), b: Point(50,50), c: Point(100,0))
    /// canvas.add(curve)
    /// ````
    ///
    /// - parameter begin: The beginning point of the curve.
    /// - parameter control: A single Point used to calculate the shape of the curve.
    /// - parameter end: The end point of the curve.
    convenience public init(begin: Point, control: Point, end: Point) {
        self.init(begin: begin, control0: control, control1: control, end: end)
    }
}
