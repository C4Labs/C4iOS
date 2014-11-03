//
//  Rect.swift
//  C4iOS
//
//  Created by travis on 2014-10-31.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation
import CoreGraphics

public struct Rect : Equatable {
    public var origin: Point
    public var size: Size
    
    public init(_ x: Double, _ y: Double, _ w: Double, _ h: Double) {
        origin = Point(x, y)
        size = Size(w,h)
    }
    
    public init(_ o: Point, _ s: Size) {
        origin = o
        size = s
    }
    
    //MARK: - Comparing
    public func intersects(r: Rect) -> Bool {
        return CGRectIntersectsRect(CGRect(self), CGRect(r))
    }
    
    //MARK: - Center & Max
    public var center: Point {
        get {
            return Point(origin.x + size.width/2, origin.y + size.height/2)
        }
        set {
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }

    public var max: Point {
        get {
            return Point(origin.x + size.width, origin.y + size.height)
        }
    }

    public func isZero() -> Bool {
        return origin.isZero() && size.isZero()
    }

    //MARK: - Membership
    public func contains(point: Point) -> Bool {
        return CGRectContainsPoint(CGRect(self), CGPoint(point))
    }
    
    public func contains(rect: Rect) -> Bool {
        return CGRectContainsRect(CGRect(self), CGRect(rect))
    }
}

//MARK: - Comparing
public func == (lhs: Rect, rhs: Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
}

//MARK: - Manipulating
public func intersection(rect1: Rect, rect2: Rect) -> Rect {
    return Rect(CGRectIntersection(CGRect(rect1), CGRect(rect2)))
}

public func union(rect1: Rect, rect2: Rect) -> Rect {
    return Rect(CGRectUnion(CGRect(rect1), CGRect(rect2)))
}

public func integral(r: Rect) -> Rect {
    return Rect(CGRectIntegral(CGRect(r)))
}

public func standardize(r: Rect) -> Rect {
    return Rect(CGRectStandardize(CGRect(r)))
}

public func inset(r: Rect, dx: Double, dy: Double) -> Rect {
    return Rect(CGRectInset(CGRect(r), CGFloat(dx), CGFloat(dy)))
}

// MARK: - Casting to and from CGRect

public extension Rect {
    public init(_ rect: CGRect) {
        origin = Point(rect.origin)
        size = Size(rect.size)
    }
}

public extension CGRect {
    public init(_ rect: Rect) {
        origin = CGPoint(rect.origin)
        size = CGSize(rect.size)
    }
}