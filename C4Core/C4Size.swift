//
//  C4Size.swift
//  C4iOS
//
//  Created by travis on 2014-10-31.
//  Copyright (c) 2014 C4. All rights reserved.
//

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