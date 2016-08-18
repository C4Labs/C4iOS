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

/// Wedge is a concrete subclass of Shape whose shape is a wedge with a rounded outer edge.
public class Wedge: Shape {

    /// Initializes a new Wedge, with the wedge always taking the shortest distance between start and end.
    ///
    /// This shape differs from Arc in that is adds a point at the "center" of the circle on which the wedge exists.
    ///
    /// ````
    /// let w = Wedge(center: canvas.center, radius: 50, start: M_PI_4 * 3, end: M_PI_4)
    /// canvas.add(w)
    /// ````
    ///
    /// - parameter center: The center of the wedge.
    /// - parameter radius: The radius of the wedge.
    /// - parameter start: The start angle of the wedge.
    /// - parameter end: The end angle of the wedge.
    convenience public init(center: Point, radius: Double, start: Double, end: Double) {
        self.init(center: center, radius: radius, start: start, end: end, clockwise: end > start ? true : false)
    }

    /// Initializes a new Wedge, with the wedge always taking the shortest distance between start and end.
    ///
    /// This shape differs from Arc in that is adds a point at the "center" of the circle on which the wedge exists.
    ///
    /// ````
    /// let w = Wedge(center: canvas.center, radius: 50, start: M_PI_4 * 3, end: M_PI_4, clockwise: true)
    /// canvas.add(w)
    /// ````
    ///
    /// - parameter center:    The center of the wedge.
    /// - parameter radius:    The radius of the wedge.
    /// - parameter start:     The start angle of the wedge.
    /// - parameter end:       The end angle of the wedge.
    /// - parameter clockwise: Whether or not to close the shape in a clockwise fashion.
    public init(center: Point, radius: Double, start: Double, end: Double, clockwise: Bool) {
        super.init()

        let wedge = CGMutablePath()
        wedge.addArc(center: CGPoint(center), radius: CGFloat(radius), startAngle: CGFloat(start), endAngle: CGFloat(end), clockwise: !clockwise)
        wedge.addLine(to: CGPoint(center))
        wedge.closeSubpath()
        path = Path(path: wedge)
        adjustToFitPath()
    }
}
