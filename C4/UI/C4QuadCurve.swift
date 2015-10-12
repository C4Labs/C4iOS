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

///  C4QuadCurve is a concrete subclass of C4Curve that modifies it shape based on a single point rather than 2 used by its parent class.
public class C4QuadCurve : C4Curve {

    /// A C4Point used to calculate the shape of the quadratic curve.
    public var controlPoint = C4Point() {
        didSet {
            self.controlPoints = (controlPoint,controlPoint)
        }
    }
    
    /// Initializes a new C4QuadCurve.
    ///
    /// ````
    /// let curve = C4QuadCurve(a: C4Point(), b: C4Point(50,50), c: C4Point(100,0))
    /// canvas.add(curve)
    /// ````
    ///
    /// - parameter a: The beginning point of the curve.
    /// - parameter b: A single C4Point used to calculate the shape of the curve.
    /// - parameter c: The end point of the curve.
    convenience public init(begin: C4Point, control: C4Point, end: C4Point) {
        self.init(begin: begin, control0: control, control1: control, end: end)
    }
}
