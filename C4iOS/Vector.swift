//
//  Vector.swift
//  C4iOS
//
//  Created by travis on 2014-10-26.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation

public func CGPointDistanceBetween(a: CGPoint, b: CGPoint) -> Double {
    let va = Vector(a)
    let vb = Vector(b)
    return va.distanceTo(vb)
}

public func CGPointAngleBetween(a: CGPoint, b: CGPoint) -> Double {
    let va = Vector(a)
    let vb = Vector(b)
    return va.angleTo(vb)
}

public func == (lhs: Vector, rhs: Vector) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

public func += (inout lhs: Vector, rhs: Vector) {
    &lhs.x += rhs.x
    &lhs.y += rhs.y
    &lhs.z += rhs.z
}

public func -= (inout lhs: Vector, rhs: Vector) {
    &lhs.x -= rhs.x
    &lhs.y -= rhs.y
    &lhs.z -= rhs.z
}

public func *= (inout lhs: Vector, rhs: Vector) {
    &lhs.x *= rhs.x
    &lhs.y *= rhs.y
    &lhs.z *= rhs.z
}

public func /= (inout lhs: Vector, rhs: Vector) {
    &lhs.x /= rhs.x
    &lhs.y /= rhs.y
    &lhs.z /= rhs.z
}

public func %= (inout lhs: Vector, rhs: Vector) {
    &lhs.x %= rhs.x
    &lhs.y %= rhs.y
    &lhs.z %= rhs.z
}

public func += (inout lhs: Vector, rhs: Double) {
    &lhs.x += rhs
    &lhs.y += rhs
    &lhs.z += rhs
}

public func -= (inout lhs: Vector, rhs: Double) {
    &lhs.x -= rhs
    &lhs.y -= rhs
    &lhs.z -= rhs
}

public func *= (inout lhs: Vector, rhs: Double) {
    &lhs.x *= rhs
    &lhs.y *= rhs
    &lhs.z *= rhs
}

public func /= (inout lhs: Vector, rhs: Double) {
    &lhs.x /= rhs
    &lhs.y /= rhs
    &lhs.z /= rhs
}

public func %= (inout lhs: Vector, rhs: Double) {
    &lhs.x %= rhs
    &lhs.y %= rhs
    &lhs.z %= rhs
}

public func + (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x+rhs.x,lhs.y+rhs.y,lhs.z+rhs.z)
}

public func + (lhs: Vector, rhs: Double) -> Vector {
    return Vector(lhs.x+rhs,lhs.y+rhs,lhs.z+rhs)
}

public func - (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x-rhs.x,lhs.y-rhs.y,lhs.z-rhs.z)
}

public func - (lhs: Vector, rhs: Double) -> Vector {
    return Vector(lhs.x-rhs,lhs.y-rhs,lhs.z-rhs)
}

public func / (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x/rhs.x,lhs.y/rhs.y,lhs.z/rhs.z)
}

public func / (lhs: Vector, rhs: Double) -> Vector {
    return Vector(lhs.x/rhs,lhs.y/rhs,lhs.z/rhs)
}

public func * (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x*rhs.x,lhs.y*rhs.y,lhs.z*rhs.z)
}

public func * (lhs: Vector, rhs: Double) -> Vector {
    return Vector(lhs.x*rhs,lhs.y*rhs,lhs.z*rhs)
}

public func % (lhs: Vector, rhs: Vector) -> Vector {
    return Vector(lhs.x%rhs.x,lhs.y%rhs.y,lhs.z%rhs.z)
}

public func % (lhs: Vector, rhs: Double) -> Vector {
    return Vector(lhs.x%rhs,lhs.y%rhs,lhs.z%rhs)
}

public class Vector : NSObject, Equatable {
    public var x: Double = 0.0, y: Double = 0.0, z: Double = 0.0
    
    public init(_ x: Double, _ y: Double, _ z: Double) {
        super.init()
        self.x = x
        self.y = y
        self.z = z
    }
    
    public convenience init(_ point: CGPoint) {
        self.init(Double(point.x), Double(point.y), 0.0)
    }
    
    public var magnitude: Double {
        return sqrt(x * x + y * y + z * z)
    }
    
    public var heading : Double {
        return atan2(y, x);
    }
    
    public func heading(basedOnPoint point: CGPoint) -> Double {
        return atan2(y-Double(point.y), x-Double(point.x))
    }
    
    public func headingv( vec: Vector) -> Double {
        return atan2(y-vec.y, x-vec.x)
    }
    
    public var GGPoint : CGPoint {
        return CGPointMake(CGFloat(x), CGFloat(y))
    }
    
    public func distanceTo(vec: Vector) -> Double {
        let dx = vec.x - x
        let dy = vec.y - y
        let dz = vec.z - z
        return sqrt(dx*dx + dy*dy + dz*dz)
    }
    
    public func angleTo(vec: Vector) -> Double {
        return acos(dot(vec)/(self.magnitude * vec.magnitude))
    }
    
    public func dot(vec: Vector) -> Double {
        return x * vec.x + y * vec.y + z * vec.z
    }
    
    public func cross(vec: Vector) {
        var temp = Vector(0,0,0)
        temp.x = y * vec.z - z * vec.y
        temp.y = z * vec.x - x * vec.z
        temp.z = x * vec.y - y * vec.x
        x = temp.x
        y = temp.y
        z = temp.z
    }
    
    public func normalize() {
        let mag = self.magnitude
        x /= mag
        y /= mag
        z /= mag
    }
}
