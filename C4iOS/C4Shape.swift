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
    internal var shapeLayer: CAShapeLayer
    
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
    
    /**
    The path defining the shape to be rendered. If the path extends outside the layer bounds it will not automatically
    be clipped to the layer. Defaults to nil. Animatable.
    */
    internal var path: C4Path? {
        didSet {
            shapeLayer.path = path?.CGPath
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
        anim.duration = 0.0
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
    
    /**
    The line width used when stroking the path. Defaults to 1.0. Animatable.
    */
    @IBInspectable
    public var lineWidth: Double {
        get { return Double(shapeLayer.lineWidth) }
        set(width) { shapeLayer.lineWidth = CGFloat(width); updatePath(); }
    }
    
    /**
    The color to stroke the path, or nil for no fill. Defaults to opaque black. Animatable.
    */
    public var strokeColor: C4Color? {
        get { return C4Color(CGColor: shapeLayer.strokeColor) }
        set(color) { shapeLayer.strokeColor = color?.CGColor }
    }
    
    /**
    The color to fill the path, or nil for no fill. Defaults to opaque black. Animatable.
    */
    public var fillColor: C4Color? {
        get { return C4Color(CGColor: shapeLayer.fillColor) }
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

    /**
    The miter limit used when stroking the path. Defaults to ten. Animatable. */
    @IBInspectable
    public var miterLimit: Double {
        get { return Double(shapeLayer.miterLimit) }
        set(miterLimit) { shapeLayer.miterLimit = CGFloat(miterLimit) }
    }
    
    /**
    The cap style used when stroking the path. Defaults to `Butt`.
    */
    public var lineCap: LineCap  {
        get {
            switch shapeLayer.lineCap {
            case kCALineCapButt:
                return .Butt
            case kCALineCapRound:
                return .Round;
            case kCALineCapSquare:
                return .Square;
            default:
                return .Butt
            }
        }
        set(lineCap) {
            switch lineCap {
            case .Butt:
                shapeLayer.lineCap = kCALineCapButt;
            case .Round:
                shapeLayer.lineCap = kCALineCapRound;
            case .Square:
                shapeLayer.lineCap = kCALineCapSquare;
            }
        }
    }

    /**
    The join style used when stroking the path. Defaults to `Miter`.
    */
    public var lineJoin: LineJoin {
        get {
            switch shapeLayer.lineJoin {
            case kCALineJoinMiter:
                return .Miter
            case kCALineJoinRound:
                return .Round;
            case kCALineJoinBevel:
                return .Bevel;
            default:
                return .Miter;
            }
        }
        set(lineJoin) {
            switch lineJoin {
            case .Miter:
                shapeLayer.lineJoin = kCALineJoinMiter
            case .Round:
                shapeLayer.lineJoin = kCALineJoinRound
            case .Bevel:
                shapeLayer.lineJoin = kCALineJoinBevel
            }
        }
    }
    
    /**
    The phase of the dashing pattern applied when creating the stroke. Defaults to zero. Animatable.
    */
    public var lineDashPhase: Double {
        get { return Double(shapeLayer.lineDashPhase) }
        set(phase) { shapeLayer.lineDashPhase = CGFloat(phase) }
    }
    
    /**
    The dash pattern applied when creating the stroked version of the path. Defaults to nil.
    */
    public var lineDashPattern: [NSNumber]? {
        get { return shapeLayer.lineDashPattern as [NSNumber]? }
        set(pattern) { shapeLayer.lineDashPattern = pattern }
    }

    public func intrinsicContentSize() -> CGSize {
        if let path = path {
            let boundingBox = path.boundingBox()
            return CGSize(width: boundingBox.max.x + lineWidth/2, height: boundingBox.max.y + lineWidth/2)
        } else {
            return CGSizeZero
        }
    }

    /// Determine whether the shape's path is empty
    public func isEmpty() -> Bool {
        return path == nil || path!.isEmpty()
    }

    public enum LineJoin {
        /// Specifies a miter line shape of the joints between connected segments of a stroked path.
        case Miter
        
        /// Specifies a round line shape of the joints between connected segments of a stroked path.
        case Round
        
        /// Specifies a bevel line shape of the joints between connected segments of a stroked path.
        case Bevel
    }
    
    public enum LineCap {
        /// Specifies a butt line cap style for endpoints for an open path when stroked.
        case Butt
        
        /// Specifies a round line cap style for endpoints for an open path when stroked.
        case Round
        
        /// Specifies a square line cap style for endpoints for an open path when stroked.
        case Square
    }
}