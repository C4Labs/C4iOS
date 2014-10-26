//
//  Math.swift
//  C4Swift
//
//  Created by travis on 2014-10-25.
//  Copyright (c) 2014 C4. All rights reserved.
//

protocol NumericType {
    func +(lhs: Self, rhs: Self) -> Self
    func -(lhs: Self, rhs: Self) -> Self
    func *(lhs: Self, rhs: Self) -> Self
    func /(lhs: Self, rhs: Self) -> Self
    func %(lhs: Self, rhs: Self) -> Self
    init(_ v: Double)
    init(_ v: Float)
    init(_ v: Int)
    init(_ v: Int8)
    init(_ v: Int16)
    init(_ v: Int32)
    init(_ v: Int64)
    init(_ v: UInt)
    init(_ v: UInt8)
    init(_ v: UInt16)
    init(_ v: UInt32)
    init(_ v: UInt64)
}

extension Double : NumericType {}
extension Float  : NumericType {}
extension Int    : NumericType {}
extension Int8   : NumericType {}
extension Int16  : NumericType {}
extension Int32  : NumericType {}
extension Int64  : NumericType {}
extension UInt   : NumericType {}
extension UInt8  : NumericType {}
extension UInt16 : NumericType {}
extension UInt32 : NumericType {}
extension UInt64 : NumericType {}
extension CGFloat: NumericType {}

import UIKit

func clamp<T : SignedNumberType>(val: T, min: T, max: T) -> T {
    assert(min < max, "min cannot be less than max")
    if(val < min) { return min }
    if val > max { return max }
    return val
}

func lerp<T : NumericType>(a: T, b: T, amount: Double) -> T {
    return a + (b-a) * T(amount)
}

func map<T : NumericType>(val: T, min: T, max: T, toMin: T, toMax: T) -> T {
    //hey al, is this proper?
    //writing a generic function in this way so that it handles
    //(float, float, float, float)
    //(double, double, double, double)
    //AND
    //(int, int, int, int)?
    if let intVal = val as? Int {
        let intMin = min as? Int
        let intMax = max as? Int
        let intToMin = toMin as? Int
        let intToMax = toMax as? Int
        
        let dvm = Double(intVal-intMin!)
        let dmm = Double(intMax!-intMin!)
        let dtt = Double(intToMax!-intToMin!)
        let dtm = Double(intToMin!)
        let returnValue = dvm / dmm * dtt + dtm
        
        return T(returnValue)
    }
    
    return ((val-min)/(max-min) * (toMax-toMin) + toMin) //this doesn't work without the <T: NumericType>
}
//using SignedNumberType when we need > or <
func max<T : SignedNumberType>(a: T, b: T) -> T {
    return a > b ? a : b
}

func min<T : SignedNumberType>(a: T, b: T) -> T {
    return a > b ? a : b
}

func random<T : NumericType>(val: T) -> T {
    srandomdev()
    return T(random())%val
}

func random<T: NumericType>(min: T, max: T) -> T {
    var val = random(max-min)
    return val + min
}

func radToDeg<T: NumericType>(val: T) -> T {
    if let intVal = val as? Int {
        var dblVal = Double(intVal)
        return T(dblVal / M_PI * 180.0)
    }
    var norm = val / T(M_PI)
    return norm * T(180.0)
}

func degToRad<T: NumericType>(val: T) -> T {
    var norm = val / T(180.0)
    return norm * T(M_PI)
}

func rgbToFloat<T: NumericType>(val: T) -> T {
    return val / T(255.0)
}

func rgbFromFloat<T: NumericType>(val: T) -> T {
    return val * T(255.0)
}