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
import C4Core

public class C4Curve : C4Shape {
    /**
    Creates a bezier curve.
    
    :param: points The beginning and end points	of the curve.
    :param: controls The control points used to define the shape of the curve.
    */
    convenience public init(points: [C4Point], controls: [C4Point]) {
        let p0 = CGPoint(points[0])
        let p1 = CGPoint(points[1])
        let c0 = CGPoint(controls[0])
        let c1 = CGPoint(controls[1])
        
        let curve = CGPathCreateMutable()
        CGPathMoveToPoint(curve, nil, p0.x, p0.y)
        CGPathAddCurveToPoint(curve, nil, c0.x,c0.y,c1.x,c1.y,p1.x,p1.y)
        let curveRect = CGPathGetBoundingBox(curve)
        
        self.init(frame: C4Rect(curveRect))
        self.path = C4Path(path:curve)
        adjustToFitPath()
    }
}