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
    public var a: C4Point {
        get {
            return points[0]
        } set(val) {
            points[0] = val
            updatePath()
        }
    }

    /**
    The end point of the receiver. Animatable.
    Assigning a new value to this variable will cause the end of the line to move to a new position.

        var l = C4Line([C4Point(), C4Point(100,100)])
        l.b = C4Point(100,200)
    */
    public var b: C4Point {
        get {
            return points[1]
        } set(val) {
            points[1] = val
            updatePath()
        }
    }
    
    override func updatePath() {
        if points.count > 1 {
            let p = C4Path()
            p.moveToPoint(points[0])
            p.addLineToPoint(points[1])
            path = p
            adjustToFitPath()
        }
    }


    /**
    Initializes a new C4Polygon using the specified array of points.

    Protects against trying to create a polygon with only 1 point (i.e. requires 2 points).
    Trims point array if count > 2.

    let a = C4Point(100,100)
    let b = C4Point(200,200)

    let l = C4Line([a,b])

    - parameter points: An array of C4Point structs.
    */
    convenience public init(var _ points: [C4Point]) {

        if points.count > 2 {
            repeat {
                points.removeLast()
            } while points.count > 2
        }

        self.init(frame: C4Rect(points))
        let path = C4Path()
        self.points = points
        path.moveToPoint(points[0])
        for i in 1..<points.count {
            path.addLineToPoint(points[i])
        }
        self.path = path
        adjustToFitPath()
    }

}
