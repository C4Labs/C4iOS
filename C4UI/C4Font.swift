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
import C4Core

public class C4Font : C4EventSource {
    internal var internalFont: UIFont?
    
    public var uiifont : UIFont {
        get {
            return internalFont!;
        }
    }
    
    convenience public init(name: String, size: Double) {
        self.init()
        internalFont = UIFont(name: name, size: CGFloat(size))
    }
    
    convenience public init(name: String) {
        self.init(name: name, size: 12.0)
    }

    convenience public init(font: UIFont) {
        self.init()
        internalFont = font
    }
    
    public var font: UIFont {
        get {
            return internalFont!
        }
    }
    
    class func familyNames() -> [AnyObject] {
        return UIFont.familyNames()
    }
    
    class func fontNames(familyName: String) -> [AnyObject] {
        return UIFont.fontNamesForFamilyName(familyName)
    }
    
    class func systemFont(size: Double) -> C4Font {
        return C4Font(font: UIFont.systemFontOfSize(CGFloat(size)))
    }
    
    class func boldSystemFont(size: Double) -> C4Font {
        return C4Font(font: UIFont.boldSystemFontOfSize(CGFloat(size)))
    }
    class func italicSystemFont(size: Double) -> C4Font {
        return C4Font(font: UIFont.italicSystemFontOfSize(CGFloat(size)))
    }
    
    public func font(size: Double) -> C4Font {
        return C4Font(font: internalFont!.fontWithSize(CGFloat(size)))
    }
    
    public var familyName : String {
        get {
            return internalFont!.familyName
        }
    }
    public var fontName : String {
        get {
            return internalFont!.fontName
        }
    }
    public var pointSize : Double {
        get {
            return Double(internalFont!.pointSize)
        }
    }
    
    public var ascender : Double {
        get {
            return Double(internalFont!.ascender)
        }
    }
    
    public var descender : Double {
        get {
            return Double(internalFont!.descender)
        }
    }
    
    public var capHeight : Double {
        get {
            return Double(internalFont!.capHeight)
        }
    }
    
    public var xHeight : Double {
        get {
            return Double(internalFont!.xHeight)
        }
    }
    
    public var lineHeight : Double {
        get {
            return Double(internalFont!.lineHeight)
        }
    }
    
    public var leading : Double {
        get {
            return Double(internalFont!.leading)
        }
    }
    
    public var labelFontSize : Double {
        get {
            return Double(UIFont.labelFontSize())
        }
    }

    public var buttonFontSize : Double {
        get {
            return Double(UIFont.buttonFontSize())
        }
    }

    public var systemFontSize : Double {
        get {
            return Double(UIFont.systemFontSize())
        }
    }

    public var smallSystemFontSize : Double {
        get {
            return Double(UIFont.smallSystemFontSize())
        }
    }
    
    public var CGFont : CGFontRef {
        get {
            return CGFontCreateWithFontName(fontName as NSString)
        }
    }
    
    public var CTFont : CTFontRef {
        get {
            return CTFontCreateWithNameAndOptions(fontName as CFString!, CGFloat(pointSize), nil, nil)
        }
    }
}