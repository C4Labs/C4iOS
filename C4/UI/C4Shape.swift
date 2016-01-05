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

/// C4Shape is a concrete subclass of C4View that draws a bezier path in its coordinate space.
public class C4Shape: C4View {
    
    internal class ShapeView : UIView {
        var shapeLayer: C4ShapeLayer {
            get {
                return self.layer as! C4ShapeLayer
            }
        }
        
        override class func layerClass() -> AnyClass {
            return C4ShapeLayer.self
        }
    }

    /// C4Shape's contents are drawn on a C4ShapeLayer.
    public var shapeLayer: C4ShapeLayer {
        get {
            return self.shapeView.shapeLayer
        }
    }
    
    internal var shapeView: ShapeView {
        return self.view as! ShapeView
    }

    ///  Initializes an empty C4Shape.
    override init() {
        super.init()

        self.view = ShapeView()
        strokeColor = C4Purple
        fillColor = C4Blue
        lineWidth = 1
        lineCap = .Round
        lineJoin = .Round
    }
    
    /// Initializest a new C4Shape from a specified C4Path.
    ///
    /// - parameter path: A C4Path around which the new shape is created with the frame of the new shape fitting the path on
    /// screen.
    public convenience init(_ path: C4Path) {
        self.init()

        self.path = path
        shapeLayer.path = path.CGPath

        updatePath()
        adjustToFitPath()
    }
    
    /// The path defining the shape to be rendered. If the path extends outside the layer bounds it will not automatically
    /// be clipped to the layer. Defaults to nil. Animatable.
    public var path: C4Path? {
        didSet {
            shapeLayer.path = path?.CGPath
        }
    }
    
    internal func updatePath() {}
    
    func adjustToFitPath() {
        if shapeLayer.path == nil {
            return
        }
        view.bounds = CGPathGetPathBoundingBox(shapeLayer.path)
        view.frame = view.bounds
    }
    
    /// Returns the receiver's frame. Animatable.
    public override var frame: C4Rect {
        get {
            return C4Rect(view.frame)
        }
        set {
            view.frame = CGRect(newValue)
            updatePath()
        }
    }
    
    /// The line width used when stroking the path. Defaults to 1.0. Animatable.
    @IBInspectable
    public var lineWidth: Double {
        get { return Double(shapeLayer.lineWidth) }
        set(width) { shapeLayer.lineWidth = CGFloat(width) }
    }
    
    /// The color to stroke the path, or nil for no fill. Defaults to opaque black. Animatable.
    public var strokeColor: C4Color? {
        get {
            if let color = shapeLayer.strokeColor {
                return C4Color(color)
            } else {
                return nil
            }
        }
        set(color) {
            shapeLayer.strokeColor = color?.CGColor
        }
    }
    
    /// The color to fill the path, or nil for no fill. Defaults to opaque black. Animatable.
    public var fillColor: C4Color? {
        get {
            if let color = shapeLayer.fillColor {
                return C4Color(color)
            } else {
                return nil
            }
        }
        set(color) {
            shapeLayer.fillColor = color?.CGColor
        }
    }
    
    /// The fill rule used when filling the path. Defaults to `NonZero`.
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
    
    /// This value defines the start of the path used to draw the stroked outline. The value must be in the range [0,1]
    /// with zero representing the start of the path and one the end. Values in between zero and one are interpolated
    /// linearly along the path length. Defaults to zero. Animatable.
    public var strokeStart: Double {
        get { return Double(shapeLayer.strokeStart) }
        set(start) { shapeLayer.strokeStart = CGFloat(start); }
    }
    
    
    /// This value defines the end of the path used to draw the stroked outline. The value must be in the range [0,1]
    /// with zero representing the start of the path and one the end. Values in between zero and one are interpolated
    /// linearly along the path length. Defaults to 1.0. Animatable.
    public var strokeEnd: Double {
        get { return Double(shapeLayer.strokeEnd) }
        set(end) { shapeLayer.strokeEnd = CGFloat(end); }
    }
    
    
    /// The miter limit used when stroking the path. Defaults to ten. Animatable.
    @IBInspectable
    public var miterLimit: Double {
        get { return Double(shapeLayer.miterLimit) }
        set(miterLimit) { shapeLayer.miterLimit = CGFloat(miterLimit) }
    }
    
    /// The cap style used when stroking the path. Defaults to `Butt`.
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
    
    /// The join style used when stroking the path. Defaults to `Miter`.
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
    
    /// The phase of the dashing pattern applied when creating the stroke. Defaults to zero. Animatable.
    public var lineDashPhase: Double {
        get { return Double(shapeLayer.lineDashPhase) }
        set(phase) { shapeLayer.lineDashPhase = CGFloat(phase) }
    }
    
    /// The dash pattern applied when creating the stroked version of the path. Defaults to nil.
    public var lineDashPattern: [NSNumber]? {
        get { return shapeLayer.lineDashPattern as [NSNumber]? }
        set(pattern) { shapeLayer.lineDashPattern = pattern }
    }
    
    /// The size of the receiver including the width of its stroke.
    public func intrinsicContentSize() -> CGSize {
        if let path = path {
            let boundingBox = path.boundingBox()
            return CGSize(width: boundingBox.max.x + lineWidth/2, height: boundingBox.max.y + lineWidth/2)
        } else {
            return CGSizeZero
        }
    }
    
    
    /// Returns true if there is no path.
    public func isEmpty() -> Bool {
        return path == nil || path!.isEmpty()
    }
    
    /// The join style for joints on the shape's path.
    public enum LineJoin {
        /// Specifies a miter line shape of the joints between connected segments of a stroked path.
        case Miter
        
        /// Specifies a round line shape of the joints between connected segments of a stroked path.
        case Round
        
        /// Specifies a bevel line shape of the joints between connected segments of a stroked path.
        case Bevel
    }
    
    /// The cap style for the ends of the shape's path.
    public enum LineCap {
        /// Specifies a butt line cap style for endpoints for an open path when stroked.
        case Butt
        
        /// Specifies a round line cap style for endpoints for an open path when stroked.
        case Round
        
        /// Specifies a square line cap style for endpoints for an open path when stroked.
        case Square
    }
}