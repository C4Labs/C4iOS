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

///The C4Gradient class draws a color gradient over its background color, filling the shape of the view (including rounded corners).
public class C4Gradient : C4View {
    class GradientView : UIView {
        var gradientLayer: C4GradientLayer {
            get {
                return self.layer as! C4GradientLayer
            }
        }
        
        override class func layerClass() -> AnyClass {
            return C4GradientLayer.self
        }
    }

    ///The background layer of the receiver.
    public var gradientLayer: C4GradientLayer {
        get {
            return self.gradientView.gradientLayer
        }
    }

    var gradientView: GradientView {
        return self.view as! GradientView
    }

    ///An array of C4Color objects defining the color of each gradient stop. Animatable.
    public var colors : [C4Color] {
        get {
            if let cgcolors = gradientLayer.colors as? [CGColorRef] {
                var array = [C4Color]()
                for c in cgcolors {
                    array.append(C4Color(c))
                }
                return array
            }
            return [C4Blue,C4Pink]
        } set {
            assert(newValue.count >= 2, "colors must have at least 2 elements")
            var cgcolors = [CGColorRef]()
            for c in newValue {
                cgcolors.append(c.CGColor)
            }
            self.gradientLayer.colors = cgcolors
        }
    }

    ///An optional array of Double values defining the location of each gradient stop. Animatable.
    ///
    ///Defaults to [0,1]
    public var locations : [Double] {
        get {
            return gradientLayer.locations as! [Double]
        } set {
            var numbers = [NSNumber]()
            for n in newValue {
                numbers.append(n)
            }
            gradientLayer.locations = numbers
        }
    }

    ///The start point of the gradient when drawn in the layer’s coordinate space. Animatable.
    ///
    ///Defaults to the top-left corner of the frame {0.0,0.0}
    public var startPoint : C4Point {
        get {
            return C4Point(gradientLayer.startPoint)
        } set {
            gradientLayer.startPoint = CGPoint(newValue)
        }
    }

    ///The end point of the gradient when drawn in the layer’s coordinate space. Animatable.
    ///
    ///Defaults to the top-right corner of the frame {1.0,0.0}
    public var endPoint : C4Point {
        get {
            return C4Point(gradientLayer.endPoint)
        } set {
            gradientLayer.endPoint = CGPoint(newValue)
        }
    }

    ///  Initializes a new C4Gradient.
    ///
    ///  - parameter frame:     A C4Rect that defines the frame for the gradient's view.
    ///  - parameter colors:    An array of C4Color objects that define the gradient's colors. Defaults to [C4Blue, C4Purple].
    ///  - parameter locations: An array of Double values that define the location of each gradient stop. Defaults to [0,1]
    public convenience init(frame: C4Rect, colors: [C4Color] = [C4Blue, C4Purple], locations: [Double] = [0,1]) {
        assert(colors.count == locations.count, "colors and locations need to have the same number of elements")
        self.init()
        self.view = GradientView(frame: CGRect(frame))
        self.colors = colors
        self.locations = locations
        self.startPoint = C4Point()
        self.endPoint = C4Point(1,0)
    }
}