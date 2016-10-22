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

import CoreGraphics

/// Defines a structure representing the border of a View.
public struct Border {

    /// Returns the color of the border.
    public var color: Color?

    /// Returns the corner radius of the border.
    public var radius: Double

    /// Returns the width of the border.
    public var width: Double

    /// Initializes a new border struct with the following defaults:
    ///
    /// radius = 0.0
    /// color = black
    /// width = 0.0
    public init() {
        color = Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        radius = 0.0
        width = 0.0
    }
}

/// Extension to View that adds a border property.
public extension View {
    /// Returns a struct that represents the current visible state of the receiver's border. Animatable.
    ///
    /// ````
    /// let v = View(frame: Rect(25,25,100,100))
    /// var b = Border()
    /// b.width = 10.0
    /// b.color = C4Purple
    /// v.border = b
    /// canvas.add(v)
    /// ````
    ///
    /// Assigning a new value to this will change the `borderWidth`, `borderColor` and `cornderRadius` of the receiver's layer.
    public var border: Border {
        get {
            var border = Border()
            if let layer = layer {
                if let borderColor = layer.borderColor {
                    border.color = Color(borderColor)
                }
                border.radius = Double(layer.cornerRadius)
                border.width = Double(layer.borderWidth)
            }
            return border
        }
        set {
            if let layer = layer {
                layer.borderWidth = CGFloat(newValue.width)
                if let color = newValue.color {
                    layer.borderColor = color.cgColor
                }
                layer.cornerRadius = CGFloat(newValue.radius)
            }
        }
    }
}
