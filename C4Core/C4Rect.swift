//
//  C4Rect.swift
//  C4iOS
//
//  Created by travis on 2014-10-31.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation
import CoreGraphics

public struct C4Rect : Equatable {
    public var origin: C4Point
    public var size: C4Size
    
    public init(_ x: Double, _ y: Double, _ w: Double, _ h: Double) {
        origin = C4Point(x, y)
        size = C4Size(w,h)
    }
    
    public init(_ o: C4Point, _ s: C4Size) {
        origin = o
        size = s
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