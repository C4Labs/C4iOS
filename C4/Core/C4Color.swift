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

import UIKit
import CoreGraphics

/// A C4Color object whose RGB value is 0, 0, 0 and whose alpha value is 1.0.
public let black     = C4Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
/// A C4Color object whose RGB value is 0.33, 0.33, 0.33 and whose alpha value is 1.0.
public let darkGray  = C4Color(red: 1.0/3.0, green: 1.0/3.0, blue: 1.0/3.0, alpha: 1.0)
/// A C4Color object whose RGB value is 0.66, 0.66, 0.66 and whose alpha value is 1.0.
public let lightGray = C4Color(red: 2.0/3.0, green: 2.0/3.0, blue: 2.0/3.0, alpha: 1.0)
/// A C4Color object whose RGB value is 1.0, 1.0, 1.0 and whose alpha value is 1.0.
public let white     = C4Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
/// A C4Color object whose RGB value is 0.5, 0.5, 0.5 and whose alpha value is 1.0.
public let gray      = C4Color(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
/// A C4Color object whose RGB value is 1.0, 0.0, 0.0 and whose alpha value is 1.0.
public let red       = C4Color(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
/// A C4Color object whose RGB value is 0.0, 1.0, 0.0 and whose alpha value is 1.0.
public let green     = C4Color(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
/// A C4Color object whose RGB value is 0.0, 0.0, 1.0 and whose alpha value is 1.0.
public let blue      = C4Color(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
/// A C4Color object whose RGB value is 0.0, 1.0, 1.0 and whose alpha value is 1.0.
public let cyan      = C4Color(red: 0.0, green: 1.0, blue: 1.0, alpha: 1.0)
/// A C4Color object whose RGB value is 1.0, 1.0, 0.0 and whose alpha value is 1.0.
public let yellow    = C4Color(red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
/// A C4Color object whose RGB value is 1.0, 0.0, 1.0 and whose alpha value is 1.0.
public let magenta   = C4Color(red: 1.0, green: 0.0, blue: 1.0, alpha: 1.0)
/// A C4Color object whose RGB value is 1.0, 0.5, 0.0 and whose alpha value is 1.0.
public let orange    = C4Color(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
/// A C4Color object whose RGB value is 0.5, 0.0, 0.5 and whose alpha value is 1.0.
public let purple    = C4Color(red: 0.5, green: 0.0, blue: 0.5, alpha: 1.0)
/// A C4Color object whose RGB value is 0.6, 0.4, 0.2 and whose alpha value is 1.0.
public let brown     = C4Color(red: 0.6, green: 0.4, blue: 0.2, alpha: 1.0)
/// A C4Color object whose RGB value is 0.0, 0.0, 0.0 and whose alpha value is 0.0.
public let clear     = C4Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)

///A C4Color object whose RGB value is 1.0, 0.0, 0.475 and whose alpha value is 1.0.
public let C4Pink    = C4Color(red: 1.0, green: 0.0, blue: 0.475, alpha: 1.0)
///A C4Color object whose RGB value is 0.098, 0.271, 1.0 and whose alpha value is 1.0.
public let C4Blue    = C4Color(red: 0.098, green: 0.271, blue: 1.0, alpha: 1.0)
///A C4Color object whose RGB value is 0.0, 0.0, 0.541 and whose alpha value is 1.0.
public let C4Purple  = C4Color(red: 0.0, green: 0.0, blue: 0.541, alpha: 1.0)
///A C4Color object whose RGB value is 0.98, 0.98, 0.98 and whose alpha value is 1.0.
public let C4Grey    = C4Color(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)

/// This document describes the C4Color object which represents color and sometimes opacity (alpha value). You can use C4Color
/// objects to store color data, and pass them between various C4 objects such as C4Shape, C4Image, etc.
///
/// C4Color internally wraps a CGColorSpaceRef called colorSpace, as well as a CGColorRef. From these two objects C4Color is able to
/// properly maintain color data and convert it to / from other color objects such as UIColor, CIColor, C4Color, etc.
public class C4Color {
    internal var colorSpace: CGColorSpaceRef
    internal var internalColor: CGColorRef
    
    /// Initializes and returns a new color object. Defaults to black with 0 opacity (i.e. clear).
    ///
    /// ````
    /// let c = C4Color()
    /// ````
    public init() {
        colorSpace = CGColorSpaceCreateDeviceRGB()!
        internalColor = CGColorCreate(colorSpace, [0, 0, 0, 0])!
    }
    
    /// Initializes and returns a new C4Color object based on specified color values.
    ///
    /// ````
    /// let c = C4Color(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
    /// ````
    ///
    /// - parameter red:   The red value for the new color [0.0 ... 1.0]
    /// - parameter green: The green value for the new color [0.0 ... 1.0]
    /// - parameter blue:  The blue value for the new color [0.0 ... 1.0]
    /// - parameter alpha: The alpha value for the new color [0.0 ... 1.0]
    public init(red: Double, green: Double, blue: Double, alpha: Double) {
        colorSpace = CGColorSpaceCreateDeviceRGB()!
        internalColor = CGColorCreate(colorSpace, [CGFloat(red), CGFloat(green), CGFloat(blue), CGFloat(alpha)])!
    }
    
    /// Initializes and returns a new C4Color object based on a provided CGColor object.
    ///
    /// ````
    /// let c = C4Color(UIColor.redColor().CGColor)
    /// ````
    ///
    /// - parameter color: A CGColor object that will be used to create a new C4Color.
    public init(_ color: CGColorRef) {
        colorSpace = CGColorSpaceCreateDeviceRGB()!
        internalColor = color
    }
    
    /// Initializes and returns a new C4Color object based on a provided UIColor object.
    ///
    /// ````
    /// let c = C4Color(UIColor.redColor())
    /// ````
    ///
    /// - parameter color: A UIColor object whose components will be extrated to create a new C4Color.
    public convenience init(_ color: UIColor) {
        self.init(color.CGColor)
    }

    ///  Initializes and returns a new C4Color object made up of a repeating pattern based on a specified C4Image.
    ///
    ///  ````
    ///  let p = C4Color("pattern")
    ///  ````
    ///
    ///  - parameter pattern: a String, the name of an image to use as a pattern.
    public convenience init(_ pattern: String) {
        self.init(UIColor(patternImage: UIImage(named: pattern)!))
    }
    
    /// Initializes and returns a new C4Color object based on specified color values.
    ///
    /// ````
    /// let c = C4Color(red: 255, green: 0, blue: 0, alpha: 255)
    /// ````
    ///
    /// - parameter red:   The red value for the new color [0 ... 255]
    /// - parameter green: The green value for the new color [0 ... 255]
    /// - parameter blue:  The blue value for the new color [0 ... 255]
    /// - parameter alpha: The alpha value for the new color [0 ... 255]
    public convenience init(red: Int, green: Int, blue: Int, alpha: Double) {
        self.init(red: Double(red) / 255.0, green: Double(green) / 255.0, blue: Double(blue) / 255.0, alpha: alpha)
    }
    
    /// Initializes and returns a new C4Color object based on a specified hex value.
    ///
    /// Remember to precede with `0x` and include the alpha component at the end (i.e. 7th + 8th characters)
    ///
    /// ````
    /// let c = C4Color(0xFF0000FF)
    /// ````
    ///
    /// - parameter hexValue: A color value expressed in hexadecimal.
    public convenience init(_ hexValue: UInt32) {
        let red   = Int((hexValue & 0xFF000000) >> 12)
        let green = Int((hexValue & 0x00FF0000) >> 8)
        let blue  = Int((hexValue & 0x0000FF00) >> 4)
        let alpha = Double(hexValue & 0x000000FF) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    /// The set of 3 color values + alpha that define the current color.
    ///
    /// - returns: An array of 4 Double values in the range [0.0 ... 1.0]
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
            internalColor = CGColorCreate(colorSpace, floatComponents)!
        }
    }
    
    /// The value of the red component of the current color, [0.0 ... 1.0]
    ///
    /// ````
    /// let c = C4Color()
    /// let redVal = c.red
    /// ````
    ///
    /// - returns: Double value in the range [0.0 ... 1.0]
    public var red: Double {
        get {
            return components[0]
        }
        set {
            components[0] = newValue
        }
    }
    
    /// The value of the green component of the current color
    ///
    /// ````
    /// let c = C4Color()
    ///  let greenVal = c.green
    /// ````
    ///
    /// - returns: Double value in the range [0.0 ... 1.0]
    public var green: Double {
        get {
            return components[1]
        }
        set {
            components[1] = newValue
        }
    }
    
    /// The value of the blue component of the current color
    ///
    /// ````
    /// let c = C4Color()
    /// let blueVal = c.blue
    /// ````
    ///
    /// - returns: Double value in the range [0.0 ... 1.0]
    public var blue: Double {
        get {
            return components[2]
        }
        set {
            components[2] = newValue
        }
    }
    
    /// The value of the alpha component of the current color.
    ///
    /// ````
    /// let c = C4Color()
    /// let alphaVal = c.alpha
    /// ````
    ///
    /// - returns: Double value in the range [0.0 ... 1.0]
    public var alpha: Double {
        get {
            return components[3]
        }
        set {
            components[3] = newValue
        }
    }
    
    /// A CGColor representation of the current color.
    ///
    /// ````
    /// let c = C4Color()
    /// let cg = c.CGColor
    /// ````
    ///
    /// - returns: CGColorRef object that matches the color's `internalColor` property
    public var CGColor: CGColorRef {
        get {
            return internalColor
        }
    }
}

// MARK: - Casting to UIColor and CIColor

public extension UIColor {
    /// Initializes a UIColor object from a C4Color object.
    ///
    /// - returns: A UIColor whose characteristics match the specified C4Color
    public convenience init?(_ color: C4Color) {
        self.init(CGColor: color.CGColor)
    }
}

public extension CIColor {
    /// Initializes a CIColor object from a C4Color object.
    ///
    /// - returns: A CIColor whose characteristics match the specified C4Color.
    public convenience init(_ color: C4Color) {
        self.init(CGColor: color.CGColor)
    }
}
