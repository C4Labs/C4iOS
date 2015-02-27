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

public class C4Line: C4Polygon {
    /**
    The beginning point of the receiver. Animatable.
    Assigning a new value to this variable will cause the head of the line to move to a new position.
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
        }
    }
}