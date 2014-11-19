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

public struct C4Size : Equatable, Comparable {
    public var width: Double
    public var height: Double
    
    public init() {
        width = 0
        height = 0
    }
    
    public init(_ width: Double, _ height: Double) {
        self.width = width
        self.height = height
    }
    
    public init(_ width: Int, _ height: Int) {
        self.width = Double(width)
        self.height = Double(height)
    }
    
    public func isZero() -> Bool {
        return width == 0 && height == 0
    }
}

public func == (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

public func > (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width * lhs.height > rhs.width * rhs.height
}

public func < (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width * lhs.height < rhs.width * rhs.height
}

public func >= (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width * lhs.height >= rhs.width * rhs.height
}

public func <= (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width * lhs.height <= rhs.width * rhs.height
}


// MARK: - Casting to and from CGSize
public extension C4Size {
    public init(_ size: CGSize) {
        width = Double(size.width)
        height = Double(size.height)
    }
}

public extension CGSize {
    public init(_ size: C4Size) {
        width = CGFloat(size.width)
        height = CGFloat(size.height)
    }
}