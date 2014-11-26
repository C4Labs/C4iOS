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
        var cgpoints = [CGPoint]()
        for p in points {
            cgpoints.append(CGPoint(p))
        }
        self.init(frame: CGRectMakeFromPoints(cgpoints))
        for i in 0..<points.count {
            linePoints.append(points[i])
        }
        
        updatePath()
    }
    
    internal override func updatePath() {
        if linePoints.count > 1 {
        let p = C4Path()
            p.moveToPoint(linePoints[0])
            
            for i in 1..<linePoints.count {
                p.addLineToPoint(linePoints[i])
            }
            
//            var transform = CGAffineTransformMakeTranslation(-frame.origin.x,-frame.origin.y)
//            shapeLayer.path = CGPathCreateCopyByTransformingPath(path.CGPath, &transform)
            animateKeyPath("path", toValue: p.CGPath)
        }
    }
    
    func animation() -> CABasicAnimation {
        var anim = CABasicAnimation()
        anim.duration = 0.25
        anim.beginTime = CACurrentMediaTime()
        anim.autoreverses = false
        anim.repeatCount = 0
        anim.removedOnCompletion = false
        anim.fillMode = kCAFillModeBoth
        return anim
    }
    
    func animateKeyPath(keyPath: String, toValue: AnyObject) {
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            self.shapeLayer.path = toValue as CGPath
            self.adjustToFitPath()
        })
        var anim = animation()
        anim.keyPath = "path"
        anim.fromValue = layer.presentationLayer()?.valueForKeyPath("path")
        anim.toValue = toValue
        layer.addAnimation(anim, forKey:"animatePath")
        CATransaction.commit()
    }
}
