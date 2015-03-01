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
    
    /**
    Initializes a new C4Rect with the origin {0,0} and the size {0,0}
    */
    public init() {
        self.init(0,0,0,0)
    }
    
    /**
    Initializes a new C4Rect with the origin {x,y} and the size {w,h}
    */
    public init(_ x: Double, _ y: Double, _ w: Double, _ h: Double) {
        origin = C4Point(x, y)
        size = C4Size(w, h)
    }
    
    /**
    Initializes a new C4Rect with the origin {x,y} and the size {w,h}, converting values from Int to Double
    */
    public init(_ x: Int, _ y: Int, _ w: Int, _ h: Int) {
        origin = C4Point(x, y)
        size = C4Size(w, h)
    }
    
    /**
    Initializes a new C4Rect with the origin {o.x,o.y} and the size {s.w,s.h}
    */
    public init(_ o: C4Point, _ s: C4Size) {
        origin = o
        size = s
    }
    
    /**
    Returns a rectangle that contains all of the specified coordinates in an array.

    :param: points An array of C4Point coordinates
    */
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
    /**
    Returns whether two rectangles intersect.

    :param: rect1	The first rectangle to examine.
    :param: rect2	The second rectangle to examine.
    :returns:	true if the two specified rectangles intersect; otherwise, false.
    */
    public func intersects(r: C4Rect) -> Bool {
        return CGRectIntersectsRect(CGRect(self), CGRect(r))
    }
    
    //MARK: - Center & Max
    
    /**
    The center point of the receiver.
    */
    public var center: C4Point {
        get {
            return C4Point(origin.x + size.width/2, origin.y + size.height/2)
        }
        set {
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }

    /**
    The bottom-right point of the receiver.
    */
    public var max: C4Point {
        get {
            return C4Point(origin.x + size.width, origin.y + size.height)
        }
    }
    
    /**
    Checks to see if the receiver has zero size and position
    
    :returns: true if origin = {0,0} and size = {0,0}
    */
    public func isZero() -> Bool {
        return origin.isZero() && size.isZero()
    }

    //MARK: - Membership
    /**
    Returns whether a rectangle contains a specified point.
    
    :param: rect	The rectangle to examine.
    :param: point	The point to examine.
    :returns: true if the rectangle is not null or empty and the point is located within the rectangle; otherwise, false.
    */
    public func contains(point: C4Point) -> Bool {
        return CGRectContainsPoint(CGRect(self), CGPoint(point))
    }
    
    /**
    Returns whether the first rectangle contains the second rectangle.
    
    :param: rect1	The rectangle to examine for containment of the rectangle passed in rect2.
    :param: rect2	The rectangle to examine for being contained in the rectangle passed in rect1.
    :param:	true if the rectangle specified by rect2 is contained in the rectangle passed in rect1; otherwise, false.
    */
    public func contains(rect: C4Rect) -> Bool {
        return CGRectContainsRect(CGRect(self), CGRect(rect))
    }
}

//MARK: - Comparing
/**
Checks to see if two C4Rects share identical origin and size
*/
public func == (lhs: C4Rect, rhs: C4Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
}

//MARK: - Manipulating
/**
Returns the intersection of two rectangles.

:param: rect1	The first source rectangle.
:param: rect2	The second source rectangle.
:returns: A rectangle that represents the intersection of the two specified rectangles.
*/
public func intersection(rect1: C4Rect, rect2: C4Rect) -> C4Rect {
    return C4Rect(CGRectIntersection(CGRect(rect1), CGRect(rect2)))
}

/**
Returns the smallest rectangle that contains the two source rectangles.

:param: r1	The first source rectangle.
:param: r2	The second source rectangle.
:returns:	The smallest rectangle that completely contains both of the source rectangles.
*/public func union(rect1: C4Rect, rect2: C4Rect) -> C4Rect {
    return C4Rect(CGRectUnion(CGRect(rect1), CGRect(rect2)))
}

/**
Returns the smallest rectangle that results from converting the source rectangle values to integers.

:param: rect	The source rectangle.
:returns: A rectangle with the smallest integer values for its origin and size that contains the source rectangle.
*/
public func integral(r: C4Rect) -> C4Rect {
    return C4Rect(CGRectIntegral(CGRect(r)))
}

/**
Returns a rectangle with a positive width and height.

:param: rect	The source rectangle.
:returns:	A rectangle that represents the source rectangle, but with positive width and height values.
*/
public func standardize(r: C4Rect) -> C4Rect {
    return C4Rect(CGRectStandardize(CGRect(r)))
}

/**
Returns a rectangle that is smaller or larger than the source rectangle, with the same center point.

:param: rect	The source C4Rect structure.
:param: dx	The x-coordinate value to use for adjusting the source rectangle.
:param: dy	The y-coordinate value to use for adjusting the source rectangle.
:returns:	A rectangle.
*/
public func inset(r: C4Rect, dx: Double, dy: Double) -> C4Rect {
    return C4Rect(CGRectInset(CGRect(r), CGFloat(dx), CGFloat(dy)))
}

// MARK: - Casting to and from CGRect

/**
Initializes a C4Rect from a CGRect
*/
public extension C4Rect {
    public init(_ rect: CGRect) {
        origin = C4Point(rect.origin)
        size = C4Size(rect.size)
    }
}

/**
Initializes a CGRect from a C4Rect
*/
public extension CGRect {
    public init(_ rect: C4Rect) {
        origin = CGPoint(rect.origin)
        size = CGSize(rect.size)
    }
}