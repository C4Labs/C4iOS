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

public protocol Touchable: UIGestureRecognizerDelegate {
    var interactionEnabled: Bool { get set }
    
    func onTap(run: TapAction)
    func onPan(run: PanAction)
    func onPinch(run: PinchAction)
    func onRotate(run: RotationAction)
    func onLongPress(run: LongPressAction)
    func onSwipe(run: SwipeAction)
    
    var pan: Pan { get }
    var tap: Tap { get }
}

public struct Tap {
    weak public var gesture: UITapGestureRecognizer?
    
    public init(_ recognizer: UITapGestureRecognizer) {
        gesture = recognizer
        numberOfTouchesRequired = 1
        numberOfTapsRequired = 1
    }
    
    public var numberOfTapsRequired : Int {
        didSet {
            self.gesture?.numberOfTapsRequired = numberOfTapsRequired
        }
    }
    
    public var numberOfTouchesRequired : Int {
        didSet {
            self.gesture?.numberOfTouchesRequired = numberOfTouchesRequired
        }
    }
}

public struct Pan {
    weak public var gesture: UIPanGestureRecognizer?
    
    public init(_ recognizer: UIPanGestureRecognizer) {
        gesture = recognizer
        minimumNumberOfTouches = 1
        maximumNumberOfTouches = 1
    }
    
    public var minimumNumberOfTouches : Int {
        didSet {
            self.gesture?.minimumNumberOfTouches = minimumNumberOfTouches
        }
    }
    
    public var maximumNumberOfTouches : Int {
        didSet {
            self.gesture?.maximumNumberOfTouches = maximumNumberOfTouches
        }
    }
}


public enum RectEdges  {
    case None
    case Top
    case Left
    case Bottom
    case Right
    case All
    
    public init() {
        self = Left
    }
    
    public init(_ edges: UIRectEdge) {
        switch edges {
        case UIRectEdge.Top:
            self = Top
        case UIRectEdge.Left:
            self = Left
        case UIRectEdge.Right:
            self = Right
        case UIRectEdge.Bottom:
            self = Bottom
        case UIRectEdge.All:
            self = All
        default:
            self = None
        }
    }
}

public struct EdgePan {
    weak public var gesture: UIScreenEdgePanGestureRecognizer?
    
    public init(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        gesture = recognizer
        
    }
    
}

public enum SwipeDirection {
    case Left
    case Right
    case Up
    case Down
    
    public init() {
        self = Left
    }
    
    public init(_ direction: UISwipeGestureRecognizerDirection) {
        switch direction {
            case UISwipeGestureRecognizerDirection.Left:
                self = Left
            case UISwipeGestureRecognizerDirection.Right:
                self = Right
            case UISwipeGestureRecognizerDirection.Up:
                self = Up
            default:
                self = Down
        }
    }
}

public struct Swipe {
    weak public var gesture: UISwipeGestureRecognizer?
    
    public init(_ recognizer: UISwipeGestureRecognizer) {
        gesture = recognizer
        direction = .Left
        numberOfTouchesRequired = 1
    }

    public var direction : SwipeDirection {
        didSet {
            switch direction {
            case .Left:
                gesture?.direction = .Left
            case .Right:
                gesture?.direction = .Right
            case .Up:
                gesture?.direction = .Up
            case .Down:
                gesture?.direction = .Down
            }
        }
    }
    
    public var numberOfTouchesRequired: Int {
        didSet {
            gesture?.numberOfTouchesRequired = numberOfTouchesRequired
        }
    }
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