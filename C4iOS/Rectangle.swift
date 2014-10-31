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

import Foundation
import CoreGraphics

public struct Rectangle : Equatable {
    public var origin: Point
    public var size: Size
    public var width: Double
    public var height: Double
    
    public var center: Point {
        get {
            return Point(x: origin.x + width/2, y: origin.y + height/2)
        }
        set {
            origin.x = newValue.x - width/2
            origin.y = newValue.y - height/2
        }
    }
    
    public func isZero() -> Bool {
        return origin.isZero() && size.isZero()
    }
    
    public func contains(point: Point) -> Bool {
        return CGRectContainsPoint(CGRect(self), CGPoint(point))
    }
}

public func == (lhs: Rectangle, rhs: Rectangle) -> Bool {
    return lhs.origin == rhs.origin && lhs.width == rhs.width && lhs.height == rhs.height
}


// MARK: - Casting to and from CGRect

public extension Rectangle {
    public init(_ rect: CGRect) {
        origin = Point(rect.origin)
        width = Double(rect.size.width)
        height = Double(rect.size.height)
        size = Size(rect.size)
    }
}

public extension CGRect {
    public init(_ rect: Rectangle) {
        origin = CGPoint(rect.origin)
        size = CGSize(rect.size)
    }
}
