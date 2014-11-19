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

public class Line: Polygon {
    lazy public var a: C4Point = C4Point()
    lazy public var b: C4Point = C4Point()
    convenience public init(_ points: [C4Point]) {
        assert(points.count >= 2, "To create a line you need to specify an array of at least 2 points")
        var cgPoints = [CGPoint(points[0]),CGPoint(points[1])]
        self.init(frame: CGRectMakeFromPoints(cgPoints))
        a = points[0]
        b = points[1]
        linePoints.append(a)
        linePoints.append(b)
        
        updatePath()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
}