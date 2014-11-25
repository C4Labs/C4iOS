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

public struct C4Rect : Equatable {
    public var origin: C4Point
    public var size: C4Size
    
    public init(_ x: Double, _ y: Double, _ w: Double, _ h: Double) {
        origin = C4Point(x, y)
        size = C4Size(w, h)
    }
    
    public init(_ x: Int, _ y: Int, _ w: Int, _ h: Int) {
        origin = C4Point(x, y)
        size = C4Size(w, h)
    }
    
    public init(_ o: C4Point, _ s: C4Size) {
        origin = o
        size = s
    }
    
    public init(_ points:[C4Point]) {
        let count = points.count
        assert(count >= 2, "To create a Polygon you need to specify an array of at least 2 points")
        var cgPoints = [CGPoint]()
        for i in 0..<count {
            cgPoints.append(CGPoint(points[i]))
        }
        let r = CGRectMakeFromPoints(cgPoints)
        let f = C4Rect(r)
        self.init(f.origin,f.size)
    }
    
    //MARK: - Comparing
    public func intersects(r: C4Rect) -> Bool {
        return CGRectIntersectsRect(CGRect(self), CGRect(r))
    }
    
    //MARK: - Center & Max
    public var center: C4Point {
        get {
            return C4Point(origin.x + size.width/2, origin.y + size.height/2)
        }
        set {
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }

    public var max: C4Point {
        get {
            return C4Point(origin.x + size.width, origin.y + size.height)
        }
    }

    public func isZero() -> Bool {
        return origin.isZero() && size.isZero()
    }

    //MARK: - Membership
    public func contains(point: C4Point) -> Bool {
        return CGRectContainsPoint(CGRect(self), CGPoint(point))
    }
    
    public func contains(rect: C4Rect) -> Bool {
        return CGRectContainsRect(CGRect(self), CGRect(rect))
    }
}

//MARK: - Comparing
public func == (lhs: C4Rect, rhs: C4Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
}

//MARK: - Manipulating
public func intersection(rect1: C4Rect, rect2: C4Rect) -> C4Rect {
    return C4Rect(CGRectIntersection(CGRect(rect1), CGRect(rect2)))
}

public func union(rect1: C4Rect, rect2: C4Rect) -> C4Rect {
    return C4Rect(CGRectUnion(CGRect(rect1), CGRect(rect2)))
}

public func integral(r: C4Rect) -> C4Rect {
    return C4Rect(CGRectIntegral(CGRect(r)))
}

public func standardize(r: C4Rect) -> C4Rect {
    return C4Rect(CGRectStandardize(CGRect(r)))
}

public func inset(r: C4Rect, dx: Double, dy: Double) -> C4Rect {
    return C4Rect(CGRectInset(CGRect(r), CGFloat(dx), CGFloat(dy)))
}

// MARK: - Casting to and from CGRect

public extension C4Rect {
    public init(_ rect: CGRect) {
        origin = C4Point(rect.origin)
        size = C4Size(rect.size)
    }
}

public extension CGRect {
    public init(_ rect: C4Rect) {
        origin = CGPoint(rect.origin)
        size = CGSize(rect.size)
    }
}