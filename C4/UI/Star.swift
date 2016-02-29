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
import CoreGraphics

/// Star is a concrete subclass of Polygon that defines a star shape.
public class Star: Polygon {

    /// Initializes a new Star shape.
    ///
    /// ````
    /// let star = Star(
    ///         center: canvas.center,
    ///     pointCount: 5,
    ///    innerRadius: 50,
    ///    outerRadius: 100)
    /// canvas.add(star)
    /// ````
    ///
    /// - parameter center: The center of the star
    /// - parameter pointCount: The number of points on the star
    /// - parameter innerRadius: The radial distance from the center of the star to the inner points
    /// - parameter outerRadius: The radial distance from the center of the start to the outer points
    convenience public init(center: Point, pointCount: Int, innerRadius: Double, outerRadius: Double) {
        let wedgeAngle = 2.0 * M_PI / Double(pointCount)
        var angle = M_PI/Double(pointCount)-M_PI_2

        var pointArray = [Point]()

        for i in 0..<pointCount * 2 {
            angle += wedgeAngle / 2.0
            if i % 2 != 0 {
                pointArray.append(Point(innerRadius * cos(angle), innerRadius * sin(angle)))
            } else {
                pointArray.append(Point(outerRadius * cos(angle), outerRadius * sin(angle)))
            }
        }

        self.init(pointArray)
        self.close()
        self.fillColor = C4Blue
        self.center = center
    }
}
