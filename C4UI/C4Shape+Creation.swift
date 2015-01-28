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

extension C4Shape {
    public func addCircle(#center: C4Point, radius: Double) {
        var newPath = path
        if newPath == nil {
            newPath = C4Path()
        }

        let r = C4Rect(center.x - radius, center.y - radius, radius*2, radius*2)
        newPath!.addEllipse(r)
        path = newPath
        adjustToFitPath()
    }

    public func addPolygon(#points: [C4Point], closed: Bool = true) {
        var newPath = path
        if newPath == nil {
            newPath = C4Path()
        }

        if !points.isEmpty {
            newPath!.moveToPoint(points[0])
        }
        for point in points {
            newPath!.addLineToPoint(point)
        }
        if closed {
            newPath!.closeSubpath()
        }
        path = newPath
        adjustToFitPath()
    }

    public func addLine(points:[C4Point]) {
        var newPath = path
        if path == nil {
            path = C4Path()
        }
        
        if newPath!.currentPoint != points[0] {
            newPath!.moveToPoint(points[0])
        }
        newPath!.addLineToPoint(points[1])
        path = newPath
        adjustToFitPath()
    }
    
    public func addCurve(#points:[C4Point], controls:[C4Point]) {
        var newPath = path
        if path == nil {
            path = C4Path()
        }
    
        if newPath!.currentPoint != points[0] {
            newPath!.moveToPoint(points[0])
        }
        newPath!.addCurveToPoint(controls[0], control2: controls[1], point: points[1]);
        path = newPath
        adjustToFitPath()
    }
}
