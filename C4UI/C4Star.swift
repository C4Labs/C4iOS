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
import C4Core

public class C4Star: C4Polygon {
    
    /**
    Initializes a new C4Star shape.
    
    :param: center The center of the star
    :param: pointCount The number of points on the star
    :param: innerRadius The radial distance from the center of the star to the inner points
    :param: outerRadius The radial distance from the center of the start to the outer points
    */
    convenience public init(center: C4Point, pointCount: Int, innerRadius: Double, outerRadius: Double) {
        let wedgeAngle = 2.0 * M_PI / Double(pointCount)
        let length = 2.0 * innerRadius * sin(wedgeAngle)
        var angle = M_PI_2
        
        var pointArray = [C4Point]()
        
        for i in 0..<pointCount * 2 {
            angle += wedgeAngle / 2.0
            if i % 2 != 0 {
                pointArray.append(C4Point(center.x + innerRadius * cos(angle), center.y + innerRadius * sin(angle)))
            } else {
                pointArray.append(C4Point(center.x + outerRadius * cos(angle), center.y + outerRadius * sin(angle)))
            }
        }
        
        self.init(pointArray)
    }
}