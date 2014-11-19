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

public class Polygon: Shape {
    lazy internal var linePoints = [C4Point]()
    convenience public init(points: [C4Point]) {
        let count = points.count
        assert(count >= 2, "To create a Polygon you need to specify an array of at least 2 points")
        var cgPoints = [CGPoint]()
        for i in 0..<count {
            cgPoints.append(CGPoint(points[i]))
        }
        self.init(frame: CGRectMakeFromPoints(cgPoints))
        for i in 0..<points.count {
            linePoints.append(points[i])
        }
        
        updatePath()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    internal override func updatePath() {
        if linePoints.count > 1 {
        let path = C4Path()
            path.moveToPoint(linePoints[0])
            
            for i in 1..<linePoints.count {
                path.addLineToPoint(linePoints[i])
            }
            
            var transform = CGAffineTransformMakeTranslation(-frame.origin.x,-frame.origin.y)
            shapeLayer.path = CGPathCreateCopyByTransformingPath(path.CGPath, &transform)
        }
    }
}
