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

///  Arc is a concrete subclass of Shape that has a special initialzer that creates an arc whose shape is defined by rotating around a specified point.
public class Arc: Shape {

    /// Creates an arc, whose edge is always drawn on the shorter circumference.
    ///
    /// ````
    /// let a = Arc(center: canvas.center,radius: 50, start: M_PI, end: 2*M_PI)
    /// ````
    ///
    /// - parameter center: The center-point of the arc
    /// - parameter radius: The radius of the arc
    /// - parameter start:  The angle (in radians) that determines the starting point of the arc, measured from the x-axis in the current user space.
    /// - parameter end:    The angle (in radians) that determines the ending point of the arc, measured from the x-axis in the current user space.
    public convenience init(center: Point, radius: Double, start: Double, end: Double) {
        self.init(center: center, radius: radius, start: start, end: end, clockwise: end>start ? true : false)
    }

    ///     Creates an arc, whose edge is drawn based on the input for `clockwise`.
    ///
    /// ````
    /// let a = Arc(center: canvas.center,radius: 50, start: M_PI, end: 2*M_PI, clockwise: clockwise: false)
    /// ````
    ///
    /// - parameter center:    The center-point of the arc
    /// - parameter radius:    The radius of the arc
    /// - parameter start:     The angle (in radians) that determines the starting point of the arc, measured from the x-axis in the current user space.
    /// - parameter end:       The angle (in radians) that determines the ending point of the arc, measured from the x-axis in the current user space.    ///
    /// - parameter clockwise: If true, the arc draws clockwise from start to end (counter clockwise if false)
    public init(center: Point, radius: Double, start: Double, end: Double, clockwise: Bool) {
        super.init()

        let arc = CGMutablePath()
        arc.addArc(center: CGPoint(center), radius: CGFloat(radius), startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: !clockwise)
        path = Path(path: arc)
        adjustToFitPath()
    }
}
