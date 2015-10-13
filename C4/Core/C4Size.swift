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

/// A structure that contains width and height values. Values stored as Double, otherwise synonymous with CGSize.
public struct C4Size : Equatable, Comparable, CustomStringConvertible {
    ///The width of the size.
    public var width: Double

    ///The height of the size.
    public var height: Double
    
    /// Initializes a new C4Size with the dimensions {0,0}
    ///
    /// ````
    /// let s = C4Size()
    /// ````
    public init() {
        width = 0
        height = 0
    }
    
    /// Initializes a new C4Size with the dimensions {width,height}
    ///
    /// ````
    /// let s = C4Size(5.2,5.2)
    /// ````
    public init(_ width: Double, _ height: Double) {
        self.width = width
        self.height = height
    }
    
    /// Initializes a new C4Size with the dimensions {width,height}, converting Int values to Double
    ///
    /// ````
    /// let s = C4Size(5,5)
    /// ````
    public init(_ width: Int, _ height: Int) {
        self.width = Double(width)
        self.height = Double(height)
    }

    /// Initializes a new C4Size from a CGSize.
    ///
    ///
    public init(_ size: CGSize) {
        width = Double(size.width)
        height = Double(size.height)
    }

    /// Returns true if the dimensions of the receiver are {0,0}
    ///
    /// ````
    /// let s = C4Size()
    /// s.isZero() //-> true
    /// ````
    public func isZero() -> Bool {
        return width == 0 && height == 0
    }
    
    /// A string representation of the size.
    ///
    /// - returns: A string formatted to look like {w,h}
    public var description : String {
        get {
            return "{\(width),\(height)}"
        }
    }
}

/// Returns true if the two source C4Size structs share identical dimensions
///
/// ````
/// let s1 = C4Size()
/// let s2 = C4Size(1,1)
/// s1 == s2 //-> false
/// ````
public func == (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width == rhs.width && lhs.height == rhs.height
}

/// Returns true if the left-hand size is bigger than the right-hand size
///
/// ````
/// let s1 = C4Size(3,4)
/// let s2 = C4Size(4,3)
/// let s3 = C4Size(2,2)
///
/// s1 > s2 //-> false
/// s2 > s3 //-> true
/// ````
public func > (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width * lhs.height > rhs.width * rhs.height
}

/// Returns true if the left-hand size is smaller than the right-hand size
///
/// ````
/// let s1 = C4Size(3,4)
/// let s2 = C4Size(4,3)
/// let s3 = C4Size(2,2)
///
/// s1 < s2 //-> false
/// s2 < s3 //-> false
/// ````
public func < (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width * lhs.height < rhs.width * rhs.height
}

/// Returns true if the left-hand size is greater than or equal to the right-hand size
///
/// ````
/// let s1 = C4Size(3,4)
/// let s2 = C4Size(4,3)
/// let s3 = C4Size(2,2)
///
/// s1 => s2 //-> true
/// s2 => s3 //-> true
/// ````
public func >= (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width * lhs.height >= rhs.width * rhs.height
}

/// Returns true if the left-hand size is smaller than or equal to the right-hand size
///
/// ````
/// let s1 = C4Size(3,4)
/// let s2 = C4Size(4,3)
/// let s3 = C4Size(2,2)
///
/// s1 <= s2 //-> true
/// s2 <= s3 //-> false
/// ````
public func <= (lhs: C4Size, rhs: C4Size) -> Bool {
    return lhs.width * lhs.height <= rhs.width * rhs.height
}

// MARK: - Casting to CGSize
public extension CGSize {
    /// Initializes a new CGSize from a C4Size
    public init(_ size: C4Size) {
        width = CGFloat(size.width)
        height = CGFloat(size.height)
    }
}