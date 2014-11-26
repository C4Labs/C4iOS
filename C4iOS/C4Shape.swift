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

public class C4Shape: C4View {
    public var shapeLayer: CAShapeLayer
    
    convenience public init(_ path: C4Path) {
        self.init(frame: path.boundingBox())
        self.path = path
        updatePath()
        adjustToFitPath()
    }
    
    convenience public init(frame: C4Rect) {
        self.init()
        self.view.frame = CGRect(frame)
        view.layer.addSublayer(shapeLayer)
    }
    
    public override init() {
        shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.greenColor().CGColor
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal var path: C4Path? {
        get {
            return C4Path(path: shapeLayer.path)
        }
        set(val) {
            shapeLayer.path = val?.CGPath
        }
    }
    
    internal func updatePath() {}
    
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
        anim.duration = 0.2
        anim.keyPath = keyPath
        anim.fromValue = view.layer.presentationLayer()?.valueForKeyPath(keyPath)
        anim.toValue = toValue
        shapeLayer.addAnimation(anim, forKey:"animate"+keyPath)
        CATransaction.commit()
    }
    
    func adjustToFitPath() {
        if shapeLayer.path == nil {
            return
        }
        var f = CGPathGetPathBoundingBox(shapeLayer.path)
        var t = CGAffineTransformMakeTranslation(0,0)
        let p = CGPathCreateCopyByTransformingPath(shapeLayer.path, &t)
        
        self.shapeLayer.path = p
        view.bounds = CGPathGetPathBoundingBox(shapeLayer.path)
        view.frame = f
    }

    public func intrinsicContentSize() -> CGSize {
        return view.intrinsicContentSize()
    }
    
    /**
    The width of the stroke. Defaults to 1.0. Animatable.
    */
    public var lineWidth: Double {
        get {
            return Double(shapeLayer.lineWidth)
        } set(val) {
            shapeLayer.lineWidth = CGFloat(val)
        }
    }
    
    /**
    The color to stroke the path, or nil for no fill. Defaults to opaque black. Animatable.
    */
    public var strokeColor: UIColor? {
        get { return UIColor(CGColor: shapeLayer.strokeColor) }
        set(color) { shapeLayer.strokeColor = color?.CGColor }
    }
    
    /**
    The color to fill the path, or nil for no fill. Defaults to opaque black. Animatable.
    */
    public var fillColor: UIColor? {
        get { return UIColor(CGColor: shapeLayer.fillColor) }
        set(color) { shapeLayer.fillColor = color?.CGColor }
    }
    
    /**
    The fill rule used when filling the path. Defaults to `NonZero`.
    */
    public var fillRule: FillRule {
        get {
            switch (shapeLayer.fillRule) {
            case kCAFillRuleNonZero:
                return .NonZero
            case kCAFillRuleEvenOdd:
                return .EvenOdd
            default:
                return .NonZero
            }
        }
        set(fillRule) {
            switch (fillRule) {
            case .NonZero:
                shapeLayer.fillRule = kCAFillRuleNonZero
            case .EvenOdd:
                shapeLayer.fillRule = kCAFillRuleEvenOdd
            }
        }
    }
    
    /**
    This value defines the start of the path used to draw the stroked outline. The value must be in the range [0,1]
    with zero representing the start of the path and one the end. Values in between zero and one are interpolated
    linearly along the path length. Defaults to zero. Animatable.
    */
    public var strokeStart: Double {
        get { return Double(shapeLayer.strokeStart) }
        set(start) { shapeLayer.strokeStart = CGFloat(start); }
    }

    /**
    This value defines the end of the path used to draw the stroked outline. The value must be in the range [0,1]
    with zero representing the start of the path and one the end. Values in between zero and one are interpolated
    linearly along the path length. Defaults to 1.0. Animatable.
    */
    public var strokeEnd: Double {
        get { return Double(shapeLayer.strokeEnd) }
        set(end) { shapeLayer.strokeEnd = CGFloat(end); }
    }

}

public class C4Polygon: C4Shape {
    public var points: [C4Point] {
        didSet {
            updatePath()
        }
    }
    convenience public init(_ points: [C4Point]) {
        assert(points.count >= 2, "You need to specify at least 2 points for a polygon")
        self.init(frame: C4Rect(points))
        var path = C4Path()
        self.points = points
        path.moveToPoint(points[0])
        for i in 1..<points.count {
            path.addLineToPoint(points[i])
        }
        self.path = path
        adjustToFitPath()
    }
    
    public override init() {
        self.points = [C4Point]()
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal override func updatePath() {
        if points.count > 1 {
            let p = C4Path()
            p.moveToPoint(points[0])
            
            for i in 1..<points.count {
                p.addLineToPoint(points[i])
            }

            animateKeyPath("path", toValue: p.CGPath)
        }
    }
}

public class C4Line: C4Polygon {
    public var a: C4Point {
        get {
            return points[0]
        } set(val) {
            points[0] = val
            updatePath()
        }
    }
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
            
            animateKeyPath("path", toValue: p.CGPath)
        }
    }
}