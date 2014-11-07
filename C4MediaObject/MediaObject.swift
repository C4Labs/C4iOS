//
//  MediaObject.swift
//  C4iOS
//
//  Created by travis on 2014-11-06.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation
//import C4Animation
import C4Core
import C4iOS

protocol MediaObject: Animatable, EventSource, NSObjectProtocol {
    
}

protocol Animatable {}

typealias EventToken = AnyObject
protocol EventSource {
    
    func post(event: String)
    func on(event: String, run: Void -> Void) -> EventToken
    func cancel(token: EventToken)
}

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