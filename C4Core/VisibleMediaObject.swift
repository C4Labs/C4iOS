//
//  VisibleMediaObject.swift
//  C4iOS
//
//  Created by travis on 2014-11-08.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation

public protocol VisibleMediaObject: MediaObject, Visible, Touchable, Maskable, AddRemoveSubview {
    
}
public typealias TapAction = (location: C4Point) -> ()
public typealias PanAction = (location: C4Point, translation: C4Point, velocity: C4Point) -> ()
public typealias PinchAction = (location: C4Point, scale: Double, velocity: Double) -> ()
public typealias RotationAction = (location: C4Point, rotation: Double, velocity: Double) -> ()
public typealias LongPressAction = (location: C4Point) -> ()
public typealias SwipeAction = (location: C4Point) -> ()

public protocol Touchable {
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

extension CALayer: Mask {
    
}

public protocol Mask {
}

public protocol Maskable {
    var mask: Mask { get set }
}

public protocol AddRemoveSubview {
    func add<T: AddRemoveSubview>(subview: T)
    func remove<T: AddRemoveSubview>(subview: T)
    func removeFromSuperview()
}