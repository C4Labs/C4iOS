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

public class C4Arc : C4Shape {
    /**
    Creates an arc.

    :param: center The center-point of the arc
    :param: radius The radius of the arc
    :param: startAngle	The angle (in radians) that determines the starting point of the arc, measured from the x-axis in the current user space.
    :param: endAngle	The angle (in radians) that determines the ending point of the arc, measured from the x-axis in the current user space.
    */
    convenience public init(center: C4Point, radius: Double, start: Double, end: Double) {
        let arcRect = CGRectMakeFromArc(CGPoint(center),CGFloat(radius),CGFloat(start),CGFloat(end), end > start ? false : true);
        self.init(frame: C4Rect(arcRect))
        let arc = CGPathCreateMutable()
        CGPathAddArc(arc, nil, CGFloat(center.x), CGFloat(center.y), CGFloat(radius), CGFloat(start), CGFloat(end), end > start ? false : true)
        self.path = C4Path(path: arc)
        adjustToFitPath()
    }
}