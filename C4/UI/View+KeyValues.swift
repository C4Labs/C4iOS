// Copyright © 2014 
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

extension View {
    ///  Sets the arbitrary keyed-data for the specified key.
    ///
    ///  - parameter value: The value for the key identified by _key_.
    ///  - parameter key:   The name of one of the receiver's properties.
    public override func setValue(value: AnyObject?, forKey key: String) {
        switch key {
        case "frame":
            let nsvalue = value as! NSValue
            #if os(iOS)
                frame = Rect(nsvalue.CGRectValue())
            #elseif os(OSX)
                frame = Rect(nsvalue.rectValue)
            #endif

        case "bounds":
            let nsvalue = value as! NSValue
            #if os(iOS)
                bounds = Rect(nsvalue.CGRectValue())
            #elseif os(OSX)
                bounds = Rect(nsvalue.rectValue)
            #endif

        case "center":
            let nsvalue = value as! NSValue
            #if os(iOS)
                center = Point(nsvalue.CGPointValue())
            #elseif os(OSX)
                center = Point(nsvalue.pointValue)
            #endif

        case "origin":
            let nsvalue = value as! NSValue
            #if os(iOS)
                origin = Point(nsvalue.CGPointValue())
            #elseif os(OSX)
                origin = Point(nsvalue.pointValue)
            #endif

        case "size":
            let nsvalue = value as! NSValue
            #if os(iOS)
                size = Size(nsvalue.CGSizeValue())
            #elseif os(OSX)
                size = Size(nsvalue.sizeValue)
            #endif

        case "backgroundColor":
            let color = value as! NativeColor
            backgroundColor = Color(color)

        default:
            super.setValue(value, forKey: key)
        }
    }

    ///  Returns the arbitrary keyed-data specified by the given key.
    ///
    ///  - parameter key: The name of one of the receiver's properties.
    ///
    ///  - returns: The value for the data specified by the key.
    public override func valueForKey(key: String) -> AnyObject? {
        switch key {
        case "frame":
            #if os(iOS)
                return NSValue(CGRect: CGRect(frame))
            #elseif os(OSX)
                return NSValue(rect: NSRect(frame))
            #endif

        case "bounds":
            #if os(iOS)
                return NSValue(CGRect: CGRect(bounds))
            #elseif os(OSX)
                return NSValue(rect: NSRect(bounds))
            #endif

        case "center":
            #if os(iOS)
                return NSValue(CGPoint: CGPoint(center))
            #elseif os(OSX)
                return NSValue(point: NSPoint(center))
            #endif

        case "origin":
            #if os(iOS)
                return NSValue(CGPoint: CGPoint(origin))
            #elseif os(OSX)
                return NSValue(point: NSPoint(origin))
            #endif

        case "size":
            #if os(iOS)
                return NSValue(CGSize: CGSize(size))
            #elseif os(OSX)
                return NSValue(size: NSSize(size))
            #endif

        case "backgroundColor":
            if let color = backgroundColor {
                return NativeColor(color)
            } else {
                return nil
            }

        default:
            return super.valueForKey(key)
        }
    }
}
