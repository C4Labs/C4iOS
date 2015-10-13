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

///  C4Curve is a concrete subclass of C4Shape that has a special initialzer that creates an bezier whose shape is defined by its end points and two control points.
public class C4Curve : C4Shape {
    
    /// The beginning and end points of the receiver. Animatable.
    public var endPoints = (C4Point(), C4Point()) {
        didSet {
            updatePath()
        }
    }
    
    /// The control points of the receiver. Animatable.
    public var controlPoints = (C4Point(), C4Point()) {
        didSet {
            updatePath()
        }
    }

    /// The center of the curve's view.
    public override var center : C4Point {
        get {
            return C4Point(view.center)
        }
        set {
            let diff = newValue - center
            batchUpdates() {
                self.endPoints.0 += diff
                self.endPoints.1 += diff
                self.controlPoints.0 += diff
                self.controlPoints.1 += diff
            }
        }
    }
    
    /// The origin of the curve's view.
    public override var origin : C4Point {
        get {
            return C4Point(view.frame.origin)
        }
        set {
            let diff = newValue - origin
            batchUpdates() {
                self.endPoints.0 += diff
                self.endPoints.1 += diff
                self.controlPoints.0 += diff
                self.controlPoints.1 += diff
            }
        }
    }
    
    /// Creates a bezier curve.
    ///
    /// ````
    /// let crv = C4Curve(a: C4Point(), b: C4Point(0,50), c: C4Point(100,50), d: C4Point(100,0))
    /// ````
    ///
    /// - parameter a: The beginning point of the curve.
    /// - parameter b: The first control point used to define the shape of the curve.
    /// - parameter c: The second control point used to define the shape of the curve.
    /// - parameter d: The end point of the curve.
    convenience public init(begin: C4Point, control0: C4Point, control1: C4Point, end: C4Point) {
        self.init()
        endPoints = (begin, end)
        controlPoints = (control0, control1)
        updatePath()
    }
    
    private var pauseUpdates = false
    func batchUpdates(updates: Void -> Void) {
        pauseUpdates = true
        updates()
        pauseUpdates = false
        updatePath()
    }
    
    override func updatePath() {
        if pauseUpdates {
            return
        }
        
        let curve = CGPathCreateMutable()
        CGPathMoveToPoint(curve, nil,
            CGFloat(endPoints.0.x), CGFloat(endPoints.0.y))
        CGPathAddCurveToPoint(curve, nil,
            CGFloat(controlPoints.0.x), CGFloat(controlPoints.0.y),
            CGFloat(controlPoints.1.x), CGFloat(controlPoints.1.y),
            CGFloat(endPoints.1.x), CGFloat(endPoints.1.y))
        
        self.frame = C4Rect(CGPathGetBoundingBox(curve))
        self.path = C4Path(path: curve)
        adjustToFitPath()
    }
}
