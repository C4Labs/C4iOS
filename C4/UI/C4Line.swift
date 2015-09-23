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

public class C4Line: C4Polygon {
    /**
    The beginning point of the receiver. Animatable.
    Assigning a new value to this variable will cause the head of the line to move to a new position.
    
        var l = C4Line([C4Point(), C4Point(100,100)])
        l.a = C4Point(0,100)
    */
    public var endPoints = (C4Point(), C4Point()) {
        didSet {
            updatePath()
        }
    }

    /**
    The end point of the receiver. Animatable.
    Assigning a new value to this variable will cause the end of the line to move to a new position.

        var l = C4Line([C4Point(), C4Point(100,100)])
        l.b = C4Point(100,200)
    */
    convenience public init(begin: C4Point, end: C4Point) {
        let points = (begin,end)
        self.init(frame: C4Rect(points))
        self.endPoints = points

        let p = C4Path()
        p.moveToPoint(endPoints.0)
        p.addLineToPoint(endPoints.1)
        path = p
        adjustToFitPath()
    }
    
    override func updatePath() {
        if pauseUpdates {
            return
        }

        if points.count > 1 {
            let p = C4Path()
            p.moveToPoint(endPoints.0)
            p.addLineToPoint(endPoints.1)
            path = p
            adjustToFitPath()
        }
    }

    public override var center : C4Point {
        get {
            return C4Point(view.center)
        }
        set {
            let diff = newValue - center
            batchUpdates() {
                self.endPoints.0 += diff
                self.endPoints.1 += diff
            }
        }
    }


    public override var origin : C4Point {
        get {
            return C4Point(view.frame.origin)
        }
        set {
            let diff = newValue - origin
            batchUpdates() {
                self.endPoints.0 += diff
                self.endPoints.1 += diff
            }
        }
    }

    private var pauseUpdates = false
    func batchUpdates(updates: Void -> Void) {
        pauseUpdates = true
        updates()
        pauseUpdates = false
        updatePath()
    }

}
