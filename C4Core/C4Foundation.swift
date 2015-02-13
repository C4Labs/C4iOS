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

/**
Prints a string to the console. Replacement for the noisy NSlog.

:param: string A formatted string that will print to the console
*/
public func C4Log(string: String) {
    println("[C4Log] \(string)")
}

/**
Returns a rectangle that contains all of the specified coordinates in an array.

:param: points An array of CGPoint coordinates
*/
public func CGRectMakeFromPoints(points: [CGPoint]) -> CGRect {
    var path = CGPathCreateMutable()
    CGPathMoveToPoint(path, nil, points[0].x, points[0].y)
    for i in 1..<points.count {
        CGPathAddLineToPoint(path, nil, points[i].x, points[i].y)
    }
    return CGPathGetBoundingBox(path)
}

/**
Returns a bounding rectangle with the specified values for building an arc.

:param: center The center coordinate around which the arc will be drawn
:param: radius The radius of the arc
:param: startAngle The start angle of the arc
:param: endAngle The end angle of the arc
:param: clockwise The direction to draw the arc
*/
public func CGRectMakeFromArc(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> CGRect {
    var path = CGPathCreateMutable()
    CGPathAddArc(path, nil, center.x, center.y, radius, startAngle, endAngle, clockwise)
    return CGPathGetBoundingBox(path)
}

/**
Returns a bounding rectangle with the specified values for building an wedge (includes the centerpoint when calculating the shape).

:param: center The center coordinate around which the wedge will be drawn
:param: radius The radius of the wedge
:param: startAngle The start angle of the wedge
:param: endAngle The end angle of the wedge
:param: clockwise The direction to draw the wedge
*/
public func CGRectMakeFromWedge(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool) -> CGRect {
    var path = CGPathCreateMutable()
    CGPathAddArc(path, nil, center.x, center.y, radius, startAngle, endAngle, clockwise)
    CGPathAddLineToPoint(path, nil, center.x, center.y)
    return CGPathGetBoundingBox(path)
}

/**
Delays the execution of a block of code.

:param: time The amount of time in seconds to wait before executing the block of code.
*/
public func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}
