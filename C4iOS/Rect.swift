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
    public var width: Double
    public var height: Double
    
    public init(_ x: Double, _ y: Double, _ width: Double, _ height: Double) {
        origin = Point(x: x, y: y)
        self.width = width
        self.height = height
    }

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
        return origin.isZero() && width == 0 && height == 0
    }

    public func contains(point: Point) -> Bool {
        return CGRectContainsPoint(CGRect(self), CGPoint(point))
    }
}

public func == (lhs: Rect, rhs: Rect) -> Bool {
    return lhs.origin == rhs.origin && lhs.width == rhs.width && lhs.height == rhs.height
}


// MARK: - Casting to and from CGRect


public extension Rect {
    public init(_ rect: CGRect) {
        origin = Point(rect.origin)
        width = Double(rect.size.width)
        height = Double(rect.size.height)
    }
}

public extension CGRect {
    public init(_ rect: Rect) {
        origin = CGPoint(rect.origin)
        size = CGSizeMake(CGFloat(rect.width), CGFloat(rect.height))
    }
}