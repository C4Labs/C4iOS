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

public class Color {
    internal var colorSpace: CGColorSpaceRef
    internal var internalColor: CGColorRef
    
    public init() {
        colorSpace = CGColorSpaceCreateDeviceRGB()
        internalColor = CGColorCreate(colorSpace, [0, 0, 0, 0])
    }
    
    public init(red: Double, green: Double, blue: Double, alpha: Double) {
        colorSpace = CGColorSpaceCreateDeviceRGB()
        internalColor = CGColorCreate(colorSpace, [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha)])
    }
    
    public convenience init(red: Int, green: Int, blue: Int, alpha: Double) {
        self.init(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0, alpha: alpha)
    }
    
    public convenience init(hexValue: UInt32) {
        let red   = Int((hexValue & 0xFF000000) >> 12)
        let green = Int((hexValue & 0x00FF0000) >> 8)
        let blue  = Int((hexValue & 0x0000FF00) >> 4)
        let alpha = Double(hexValue & 0x000000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public var components: [Double] {
        get {
            let floatComponents = CGColorGetComponents(internalColor)
            return [
                Double(floatComponents[0]),
                Double(floatComponents[1]),
                Double(floatComponents[2]),
                Double(floatComponents[3])
            ]
        }
        set {
            let floatComponents = [
                CGFloat(newValue[0]),
                CGFloat(newValue[1]),
                CGFloat(newValue[2]),
                CGFloat(newValue[3]),
            ]
            internalColor = CGColorCreate(colorSpace, floatComponents)
        }
    }
    
    public var red: Double {
        get {
            return components[0]
        }
        set {
            components[0] = newValue
        }
    }
    
    public var green: Double {
        get {
            return components[1]
        }
        set {
            components[1] = newValue
        }
    }
    
    public var blue: Double {
        get {
            return components[2]
        }
        set {
            components[2] = newValue
        }
    }
    
    public var alpha: Double {
        get {
            return components[3]
        }
        set {
            components[3] = newValue
        }
    }
}


// MARK: - Casting to UIColor

public extension UIColor {
    public convenience init(_ color: Color) {
        self.init(CGColor: color.internalColor)
    }
}
