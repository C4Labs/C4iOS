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

import C4Core

public struct Shadow {
    public var radius: Double
    public var color: C4Color
    public var offset: C4Size
    public var opacity: Double
    public var path: C4Path?
    
    public init() {
        radius = 5.0
        color = C4Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        offset = C4Size(5,5)
        opacity = 0.0
    }
}

public extension C4View {
    
    
    public var shadow: Shadow {
        get {
            var shadow = Shadow()
            if let layer = layer {
                shadow.radius = Double(layer.shadowRadius)
                shadow.color = C4Color(layer.shadowColor)
                shadow.offset = C4Size(layer.shadowOffset)
                shadow.opacity = Double(layer.shadowOpacity)
                shadow.path = C4Path(path: layer.shadowPath)
            }
            return shadow
        }
        set {
            if let layer = layer {
                layer.shadowColor = newValue.color.CGColor
                layer.shadowRadius = CGFloat(newValue.radius)
                layer.shadowOffset = CGSize(newValue.offset)
                layer.shadowOpacity = Float(newValue.opacity)
                layer.shadowPath = newValue.path?.CGPath
            }
        }
    }
}
