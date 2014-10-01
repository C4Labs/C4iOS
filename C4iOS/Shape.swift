//  Created by Alejandro Isaza on 2014-09-30.
//  Copyright (c) 2014 C4. All rights reserved.

import QuartzCore
import UIKit

@IBDesignable
class Shape: UIView {

    var shapeLayer: CAShapeLayer { get { return layer as CAShapeLayer } }

    /**
      The path defining the shape to be rendered. If the path extends outside the layer bounds it will not
      automatically be clipped to the layer. Defaults to nil. Animatable.
    */
    var path: CGPath? {
        get { return shapeLayer.path }
        set(path) { shapeLayer.path = path }
    }

    /**
      The color to fill the path, or nil for no fill. Defaults to opaque black. Animatable.
    */
    @IBInspectable
    var fillColor: UIColor? {
        get { return UIColor(CGColor: shapeLayer.fillColor) }
        set(color) { shapeLayer.fillColor = color?.CGColor }
    }

    /**
      The fill rule used when filling the path. Defaults to `NonZero`.
    */
    var fillRule: FillRule {
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
      The color to fill the path's stroked outline, or nil for no stroking. Defaults to nil. Animatable.
    */
    @IBInspectable
    var strokeColor: UIColor? {
        get { return UIColor(CGColor: shapeLayer.strokeColor) }
        set(color) { shapeLayer.strokeColor = color?.CGColor }
    }

    /**
      This value defines the start of the path used to draw the stroked outline. The value must be in the range [0,1]
      with zero representing the start of the path and one the end. Values in between zero and one are interpolated
      linearly along the path length. Defaults to zero. Animatable.
    */
    @IBInspectable
    var strokeStart: CGFloat {
        get { return shapeLayer.strokeStart }
        set(start) { shapeLayer.strokeStart = start; }
    }

    /**
      This value defines the end of the path used to draw the stroked outline. The value must be in the range [0,1]
      with zero representing the start of the path and one the end. Values in between zero and one are interpolated
      linearly along the path length. Defaults to one. Animatable.
    */
    @IBInspectable
    var strokeEnd: CGFloat {
        get { return shapeLayer.strokeEnd }
        set(end) { shapeLayer.strokeEnd = end; }
    }

    /**
      The line width used when stroking the path. Defaults to one. Animatable.
    */
    @IBInspectable
    var lineWidth: CGFloat {
        get { return shapeLayer.lineWidth }
        set(width) { shapeLayer.lineWidth = width }
    }

    /**
      The miter limit used when stroking the path. Defaults to ten. Animatable. */
    @IBInspectable
    var miterLimit: CGFloat {
        get { return shapeLayer.miterLimit }
        set(miterLimit) { shapeLayer.miterLimit = miterLimit }
    }

    /**
      The cap style used when stroking the path. Defaults to `Butt`.
    */
    var lineCap: LineCap  {
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
    var lineJoin: LineJoin {
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
    var lineDashPhase: CGFloat {
        get { return shapeLayer.lineDashPhase }
        set(phase) { shapeLayer.lineDashPhase = phase }
    }

    /**
      The dash pattern applied when creating the stroked version of the path. Defaults to nil.
    */
    var lineDashPattern: [NSNumber]? {
        get { return shapeLayer.lineDashPattern as [NSNumber]? }
        set(pattern) { shapeLayer.lineDashPattern = pattern }
    }

    override class func layerClass() -> AnyClass {
        return CAShapeLayer.self;
    }


    enum FillRule {
        /**
        Specifies the non-zero winding rule. Count each left-to-right path as +1 and each right-to-left path as -1.
        If the sum of all crossings is 0, the point is outside the path. If the sum is nonzero, the point is inside
        the path and the region containing it is filled.
        */
        case NonZero

        /**
        Specifies the even-odd winding rule. Count the total number of path crossings. If the number of crossings is
        even, the point is outside the path. If the number of crossings is odd, the point is inside the path and the
        region containing it should be filled.
        */
        case EvenOdd
    }

    enum LineJoin {
        /// Specifies a miter line shape of the joints between connected segments of a stroked path.
        case Miter

        /// Specifies a round line shape of the joints between connected segments of a stroked path.
        case Round

        /// Specifies a bevel line shape of the joints between connected segments of a stroked path.
        case Bevel
    }

    enum LineCap {
        /// Specifies a butt line cap style for endpoints for an open path when stroked.
        case Butt

        /// Specifies a round line cap style for endpoints for an open path when stroked.
        case Round

        /// Specifies a square line cap style for endpoints for an open path when stroked.
        case Square
    }
}
