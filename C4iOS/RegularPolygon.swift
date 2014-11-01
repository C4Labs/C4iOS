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

public class RegularPolygonShape: Shape {
    override public init(frame: CGRect) {
        super.init(frame: frame)
        updatePath()
    }

    required public init(coder: NSCoder) {
        super.init(coder: coder)
        updatePath()
    }
    
    override public var bounds: CGRect {
        didSet {
            updatePath();
        }
    }
    
    override public var frame: CGRect {
        didSet {
            updatePath();
        }
    }
    
    @IBInspectable
    override public var lineWidth: CGFloat {
        didSet {
            updatePath()
        }
    }
    
    @IBInspectable
    public var sides: Int = 3 {
        didSet {
            updatePath()
        }
    }
    
    @IBInspectable
    public var phase: CGFloat = 0 {
        didSet {
            updatePath()
        }
    }
    
    internal func updatePath() {
        let rect = CGRectInset(bounds, lineWidth, lineWidth)
        let rx = rect.size.width / 2.0
        let ry = rect.size.height / 2.0
        if sides == 0 || rx <= 0 || ry <= 0 {
            // Don't try to generate invalid polygons, we'll get undefined behaviour
            return
        }
        
        let center = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect))
        let delta = CGFloat(2.0*M_PI) / CGFloat(sides)
        let path = Path()
        
        for i in 0..<sides {
            let angle = phase + delta*CGFloat(i)
            let point = CGPoint(x: center.x + rx*CGFloat(cos(angle)), y: center.y + ry*CGFloat(sin(angle)))
            if i == 0 {
                path.moveToPoint(point)
            } else {
                path.addLineToPoint(point)
            }
        }
        path.closeSubpath()
        shapeLayer.path = path.internalPath
    }
}
