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


/// Extension for Shape that provides functionality for adding elements to a receiver's path.
extension Shape {
    /// Appends a circle to the end of the receiver's path.
    ///
    /// ````
    /// var l = Line([Point(),Point(100,100)])
    /// l.addCircle(center: l.path!.currentPoint, radius: 20)
    /// canvas.add(l)
    /// ````
    ///
    /// - parameter center: The center of the new circle
    /// - parameter radius: The radius of the new circle
    public func addCircle(center: Point, radius: Double) {
        var newPath = path
        if newPath == nil {
            newPath = Path()
        }

        let r = Rect(center.x - radius, center.y - radius, radius*2, radius*2)
        newPath!.addEllipse(r)
        path = newPath
        adjustToFitPath()
    }

    /// Appends a polygon to the end of the receiver's path.
    ///
    /// ````
    /// var l = Line([Point(),Point(100,100)])
    /// var points = [Point]()
    /// for i in 0...10 {
    ///     let x = random01()*100.0
    ///     let y = random01()*100.0
    ///     points.append(Point(x,y))
    /// }
    /// l.addPolygon(points: points, closed: true)
    /// canvas.add(l)
    /// ````
    ///
    /// - parameter points: An array of Point structs that defines the new polygon
    /// - parameter closed: If true then the polygon will have an additional line between its first and last points
    public func addPolygon(points: [Point], closed: Bool = true) {
        var newPath = path
        if newPath == nil {
            newPath = Path()
        }

        if let firstPoint = points.first {
            newPath!.moveToPoint(firstPoint)
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

    /// Appends a line segment to the end of the receiver's path.
    ///
    /// ````
    /// var l = Line([Point(),Point(100,100)])
    /// l.addLine([Point(100,100),Point(100,0)])
    /// canvas.add(l)
    /// ````
    ///
    /// - parameter points: An array of Point structs that defines the new line
    public func addLine(_ points: [Point]) {
        let newPath = path
        if path == nil {
            path = Path()
        }

        if newPath!.currentPoint != points.first! {
            newPath!.moveToPoint(points.first!)
        }
        newPath!.addLineToPoint(points[1])
        path = newPath
        adjustToFitPath()
    }

    /// Appends a bezier curve to the end of the receiver's path.
    ///
    /// ````
    /// var l = Line([Point(),Point(100,100)])
    /// let pts = [Point(100,100),Point(100,0)]
    /// let ctrls = [Point(150,100),Point(150,0)]
    /// l.addCurve(points: pts, controls: ctrls)
    /// canvas.add(l)
    /// ````
    ///
    /// - parameter points: An array of Point structs that defines the beginning and end points of the curve
    /// - parameter controls: An array of Point structs used to define the shape of the curve
    public func addCurve(points: [Point], controls: [Point]) {
        let newPath = path
        if path == nil {
            path = Path()
        }

        if newPath!.currentPoint != points.first! {
            newPath!.moveToPoint(points.first!)
        }
        newPath!.addCurveToPoint(points[1], control1: controls.first!, control2: controls[1])
        path = newPath
        adjustToFitPath()
    }
}
