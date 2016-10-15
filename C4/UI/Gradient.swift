// Copyright © 2015 C4
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

import UIKit

///The Gradient class draws a color gradient over its background color, filling the shape of the view (including rounded corners).
public class Gradient: View {
    class GradientView: UIView {
        var gradientLayer: GradientLayer {
            return self.layer as! GradientLayer // swiftlint:disable:this force_cast
        }

        override class var layerClass: AnyClass {
            return GradientLayer.self
        }
    }

    ///The background layer of the receiver.
    public var gradientLayer: GradientLayer {
        return gradientView.gradientLayer
    }

    internal var gradientView: GradientView {
        return view as! GradientView // swiftlint:disable:this force_cast
    }

    ///An array of Color objects defining the color of each gradient stop. Animatable.
    public var colors: [Color] {
        get {
            if let cgcolors = gradientLayer.colors as? [CGColor] {
                return cgcolors.map({ Color($0) })
            }
            return [C4Blue, C4Pink]
        } set {
            assert(newValue.count >= 2, "colors must have at least 2 elements")

            let cgcolors = newValue.map({ $0.cgColor })
            self.gradientLayer.colors = cgcolors
        }
    }

    ///An optional array of Double values defining the location of each gradient stop. Animatable.
    ///
    ///Defaults to [0,1]
    public var locations: [Double] {
        get {
            if let locations = gradientLayer.locations as? [Double] {
                return locations
            }
            return []
        } set {
            let numbers = newValue.map({ NSNumber(value: $0) })
            gradientLayer.locations = numbers
        }
    }

    ///The start point of the gradient when drawn in the layer’s coordinate space. Animatable.
    ///
    ///Defaults to the top-left corner of the frame {0.0,0.0}
    public var startPoint: Point {
        get {
            return Point(gradientLayer.startPoint)
        } set {
            gradientLayer.startPoint = CGPoint(newValue)
        }
    }

    ///The end point of the gradient when drawn in the layer’s coordinate space. Animatable.
    ///
    ///Defaults to the top-right corner of the frame {1.0,0.0}
    public var endPoint: Point {
        get {
            return Point(gradientLayer.endPoint)
        } set {
            gradientLayer.endPoint = CGPoint(newValue)
        }
    }

    /// The current rotation value of the view. Animatable.
    /// - returns: A Double value representing the cumulative rotation of the view, measured in Radians.
    public override var rotation: Double {
        get {
            if let number = gradientLayer.value(forKeyPath: Layer.rotationKey) as? NSNumber {
                return number.doubleValue
            }
            return  0.0
        }
        set {
            gradientLayer.setValue(newValue, forKeyPath: Layer.rotationKey)
        }
    }

    ///  Initializes a new Gradient.
    ///
    /// - parameter frame:     A Rect that defines the frame for the gradient's view.
    /// - parameter colors:    An array of Color objects that define the gradient's colors. Defaults to [C4Blue, C4Purple].
    /// - parameter locations: An array of Double values that define the location of each gradient stop. Defaults to [0,1]
    public convenience override init(frame: Rect) {
        self.init()
        self.view = GradientView(frame: CGRect(frame))
        self.colors = [C4Pink, C4Purple]
        self.locations = [0, 1]
        self.startPoint = Point()
        self.endPoint = Point(0, 1)
    }

    public convenience init(copy original: Gradient) {
        self.init(frame: original.frame)
        self.colors = original.colors
        self.locations = original.locations
        copyViewStyle(original)
    }
}
