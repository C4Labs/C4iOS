//
//  MediaObject.swift
//  C4iOS
//
//  Created by travis on 2014-11-06.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation
//import C4Animation
import C4iOS

protocol MediaObject: Animatable, EventSource, NSObjectProtocol {
    
}

protocol Animatable {}

typealias TapAction = (location: C4Point) -> ()
typealias PanAction = (location: C4Point, translation: C4Point, velocity: C4Point) -> ()
typealias PinchAction = (location: C4Point, scale: Double, velocity: Double) -> ()
typealias RotationAction = (location: C4Point, rotation: Double, velocity: Double) -> ()
typealias LongPressAction = (location: C4Point) -> ()
typealias SwipeAction = (location: C4Point) -> ()

protocol Touchable {
    var interactionEnabled: Bool { get set }
    
    func onTap(run: TapAction)
    func onPan(run: PanAction)
    func onPinch(run: PinchAction)
    func onRotate(run: RotationAction)
    func onLongPress(run: LongPressAction)
    func onSwipe(run: SwipeAction)
}

public protocol Visible {
    var frame: C4Rect { get set }
    var bounds: C4Rect { get }
    var center: C4Point { get set }
    var size: C4Size { get }
    var constrainsProportions: Bool { get set }
    
    var backgroundColor: C4Color { get set }
    var opacity: Double { get set }
    var hidden: Bool { get set }
    
    var border: Border { get set }
    var shadow: Shadow { get set }
    var rotation: Rotation { get set }
//    
//    var borderWidth: Double { get set }
//    var borderHeight: Double { get set }
//    var borderColor: C4Color { get set }
//    var cornerRadius: Double { get set }
//    //potential idea: struct border > .width, .height, .color, .radius
//    
//    var shadowRadius: Double { get set }
//    var shadowColor: C4Color { get set }
//    var shadowOffset: C4Point { get set }
//    var shadowOpacity: Double { get set }
//    var shadowPath: C4Path { get set }
//    //potential idea: struct shadow > ... (see above)
//    
//    var rotation: Double { get set }
//    var rotationX: Double { get set }
//    var rotationZ: Double { get set }
//    //idea: struct rotation > .z, .x, .y
    var perspectiveDistance: Double { get set }
}

protocol Mask {}

protocol Maskable {
    var mask: Mask { get set }
}

protocol Styleable {
    class var defaultStyle: Style { get set }
    var style: Style { get set }
}

public struct Border {
    public init() {
        self.layer = CALayer()
    }
    
    public init(_ layer: CALayer) {
        self.init()
        self.layer = layer
    }
    
    public var layer: CALayer {
        didSet {
            update()
        }
    }
    
    public var color: C4Color = C4Color(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            layer.borderColor = color.CGColor
        }
    }
    
    public var radius: Double = 0 {
        didSet {
            layer.cornerRadius = CGFloat(radius)
        }
    }
    
    public var width: Double = 0 {
        didSet {
            layer.borderWidth = CGFloat(width)
        }
    }
    
    internal func update() {
        layer.borderColor = color.CGColor
        layer.cornerRadius = CGFloat(radius)
        layer.borderWidth = CGFloat(width)
    }
}

public struct Shadow {
    public init() {
        self.layer = CALayer()
    }
    
    public init(_ layer: CALayer) {
        self.init()
        self.layer = layer
    }
    
    public var layer: CALayer {
        didSet {
            update()
        }
    }
    
    public var radius: Double = 0 {
        didSet {
            layer.shadowRadius = CGFloat(radius)
        }
    }
    public var color: C4Color = C4Color(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            layer.shadowColor = color.CGColor
        }
    }
    public var offset: C4Size = C4Size() {
        didSet {
            layer.shadowOffset = CGSize(offset)
        }
    }
    public var opacity: Double = 0 {
        didSet {
            layer.shadowOpacity = Float(opacity)
        }
    }
    public var shadowPath: C4Path = C4Path() {
        didSet {
            layer.shadowPath = shadowPath.CGPath
        }
    }
    
    internal func update() {
        layer.shadowRadius = CGFloat(radius)
        layer.shadowColor = color.CGColor
        layer.shadowOffset = CGSize(offset)
        layer.shadowOpacity = Float(opacity)
    }
}

public struct Rotation {
    public init() {
        self.layer = CALayer()
    }
    
    public init(_ layer: CALayer) {
        self.init()
        self.layer = layer
    }
    
    public var layer: CALayer {
        didSet {
            update()
        }
    }
    
    public var x: Double = 0 {
        didSet {
            //trigger x rotation for layer
        }
    }
    
    public var y: Double = 0 {
        didSet {
            //trigger y rotation for layer
        }
    }
    
    public var z: Double = 0 {
        didSet {
            //trigger z rotation for layer
        }
    }
    
    internal func update() {
        //trigger x rotation for layer
        //trigger y rotation for layer
        //trigger z rotation for layer
    }
}