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
    internal class GradientView : UIView {
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
    
    internal var gradientView: GradientView {
        return self.view as! GradientView
    }
    public var colors : [C4Color] {
        get {
            if let cgcolors = gradientLayer.colors as? [CGColorRef] {
                return [C4Color(cgcolors[0]),C4Color(cgcolors[1])]
            }
            return [C4Blue,C4Pink]
        } set {
            assert(newValue.count == 2)
            if let c1 : C4Color = newValue.first,
                let c2 : C4Color = newValue.last {
                    self.gradientLayer.colors = [c1.CGColor,c2.CGColor]
            }
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
}