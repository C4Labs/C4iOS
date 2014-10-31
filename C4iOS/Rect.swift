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

    public var center: Point {
        get {
            return Point(origin.x + size.width/2, origin.y + size.height/2)
        }
        set {
            origin.x = newValue.x - size.width/2
            origin.y = newValue.y - size.height/2
        }
    }

    public func isZero() -> Bool {
        return origin.isZero() && size.isZero()
    }

    public func contains(point: Point) -> Bool {
        return CGRectContainsPoint(CGRect(self), CGPoint(point))
    }
}

public func == (lhs: Rect, rhs: Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.size == rhs.size
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
