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
    
    public var gradientLayer: C4GradientLayer {
        get {
            return self.gradientView.gradientLayer
        }
    }
    
    var gradientView: GradientView {
        return self.view as! GradientView
    }

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
    
    public var startPoint : C4Point {
        get {
            return C4Point(gradientLayer.startPoint)
        } set {
            gradientLayer.startPoint = CGPoint(newValue)
        }
    }

    public var endPoint : C4Point {
        get {
            return C4Point(gradientLayer.endPoint)
        } set {
            gradientLayer.endPoint = CGPoint(newValue)
        }
    }

    public convenience init(frame: C4Rect, colors: [C4Color] = [C4Blue, C4Purple], locations: [Double] = [0,1]) {
        assert(colors.count == locations.count, "colors and locations need to have the same number of elements")
        self.init()
        self.view = GradientView(frame: CGRect(frame))
        self.colors = colors
        self.locations = locations
    }
}