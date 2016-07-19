// Copyright © 2014 C4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

#if os(iOS)
    import UIKit
    public typealias NativeGestureRecognizerState = UIGestureRecognizerState
    public typealias NativeTapGestureRecognizer = UITapGestureRecognizer
    public typealias NativeClickGestureRecognizer = UITapGestureRecognizer
    public typealias NativePanGestureRecognizer = UIPanGestureRecognizer
    public typealias NativePinchGestureRecognizer = UIPinchGestureRecognizer
    public typealias NativeRotationGestureRecognizer = UIRotationGestureRecognizer
    public typealias NativePressGestureRecognizer = UILongPressGestureRecognizer
#elseif os(OSX)
    import AppKit
    public typealias NativeGestureRecognizerState = NSGestureRecognizerState
    public typealias NativeTapGestureRecognizer = NSClickGestureRecognizer
    public typealias NativeClickGestureRecognizer = NSClickGestureRecognizer
    public typealias NativePanGestureRecognizer = NSPanGestureRecognizer
    public typealias NativePinchGestureRecognizer = NSMagnificationGestureRecognizer
    public typealias NativeRotationGestureRecognizer = NSRotationGestureRecognizer
    public typealias NativePressGestureRecognizer = NSPressGestureRecognizer

#endif

private var handlerAssociationKey: UInt8 = 0
private var viewAssociationKey: UInt8 = 0

extension NativeGestureRecognizer {
    
    /// The current location of the gesture in the reference view.
    public var location: Point {
        get {
            return Point(locationInView(referenceView))
        }
    }
    
    internal var referenceView: NativeView? {
        get {
            let weakViewWrapper: WeakViewWrapper? = objc_getAssociatedObject(self, &viewAssociationKey) as? WeakViewWrapper
            return weakViewWrapper?.view
        }
        set {
            var weakViewWrapper: WeakViewWrapper? = objc_getAssociatedObject(self, &viewAssociationKey) as? WeakViewWrapper
            if weakViewWrapper == nil {
                weakViewWrapper = WeakViewWrapper(newValue)
                objc_setAssociatedObject(self, &viewAssociationKey, weakViewWrapper, .OBJC_ASSOCIATION_RETAIN)
            } else {
                weakViewWrapper!.view = newValue
            }
        }
    }
    
    internal var actionHandler: AnyObject? {
        get {
            return objc_getAssociatedObject(self, &handlerAssociationKey)
        }
        set(newValue) {
            objc_setAssociatedObject(self, &handlerAssociationKey, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    internal convenience init(view: NativeView) {
        self.init()
        self.referenceView = view
    }
    
    /// Keeps a weak reference to a view. Used to work around the limitation that extensions cannot have stored
    /// properties and objc_setAssociatedObject does not support zeroing weak references. See
    /// [on Stack Overflow](http://stackoverflow.com/questions/27632867/how-do-i-create-a-weak-stored-property-in-a-swift-extension)
    internal class WeakViewWrapper : NSObject {
        weak var view : NativeView?
        
        init(_ view: NativeView?) {
            self.view = view
        }
    }
}


public typealias TapAction = (location: Point, state: NativeGestureRecognizerState) -> ()

extension NativeTapGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var tapAction: TapAction? {
        get {
            return (actionHandler as? TapGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                #if os(iOS)
                    removeTarget(handler, action: "handleGesture:")
                #elseif os(OSX)
                    target = nil
                    action = nil
                #endif
            }
            
            if let newAction = newValue {
                actionHandler = TapGestureHandler(newAction)
                #if os(iOS)
                    addTarget(actionHandler!, action: "handleGesture:")
                #elseif os(OSX)
                    target = actionHandler
                    action = #selector(TapGestureHandler.handleGesture(_:))
                #endif
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: NativeView, action: TapAction) {
        self.init()
        self.referenceView = view
        self.tapAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class TapGestureHandler : NSObject {
        let action: TapAction
        
        init(_ action: TapAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: NativePanGestureRecognizer) {
            action(location: gestureRecognizer.location, state: gestureRecognizer.state)
        }
    }
}


public typealias PanAction = (location: Point, translation: Vector, velocity: Vector, state: NativeGestureRecognizerState) -> ()

extension NativePanGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var panAction: PanAction? {
        get {
            return (actionHandler as? PanGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                #if os(iOS)
                    removeTarget(handler, action: "handleGesture:")
                #elseif os(OSX)
                    target = nil
                    action = nil
                #endif
            }
            
            if let newAction = newValue {
                actionHandler = PanGestureHandler(newAction)
                #if os(iOS)
                    addTarget(actionHandler!, action: "handleGesture:")
                #elseif os(OSX)
                    target = actionHandler
                    action = #selector(PanGestureHandler.handleGesture(_:))
                #endif
            } else {
                actionHandler = nil
            }
        }
    }

    /// The translation of the pan gesture in the coordinate system of the specified view.
    ///
    /// The x and y values report the total translation over time. They are not delta values from the last time that the translation was reported. Apply the translation value to the state of the view when the gesture is first recognized—do not concatenate the value each time the handler is called.
    public var translation: Vector {
        get {
            if let view = referenceView {
                return Vector(translationInView(view))
            }
            return Vector()
        }
    }

    /// The velocity of the pan gesture in the coordinate system of the specified view.
    ///
    /// The velocity of the pan gesture, which is expressed in points per second. The velocity is broken into horizontal and vertical components.
    public var velocity: Vector {
        get {
            return Vector(velocityInView(view))
        }
        
    }
    
    internal convenience init(view: NativeView, action: PanAction) {
        self.init()
        self.referenceView = view
        self.panAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class PanGestureHandler : NSObject {
        let action: PanAction
        
        init(_ action: PanAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: NativePanGestureRecognizer) {
            action(location: gestureRecognizer.location, translation: gestureRecognizer.translation, velocity: gestureRecognizer.velocity, state: gestureRecognizer.state)
        }
    }
}


public typealias PinchAction = (scale: Double, state: NativeGestureRecognizerState) -> ()

extension NativePinchGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var pinchAction: PinchAction? {
        get {
            return (actionHandler as? PinchGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                #if os(iOS)
                    removeTarget(handler, action: "handleGesture:")
                #elseif os(OSX)
                    target = nil
                    action = nil
                #endif
            }
            
            if let newAction = newValue {
                actionHandler = PinchGestureHandler(newAction)
                #if os(iOS)
                    addTarget(actionHandler!, action: "handleGesture:")
                #elseif os(OSX)
                    target = actionHandler
                    action = #selector(PinchGestureHandler.handleGesture(_:))
                #endif
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: NativeView, action: PinchAction) {
        self.init()
        self.referenceView = view
        self.pinchAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class PinchGestureHandler : NSObject {
        let action: PinchAction
        
        init(_ action: PinchAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: NativePinchGestureRecognizer) {
            #if os(iOS)
                let scale = gestureRecognizer.scale
            #elseif os(OSX)
                let scale = gestureRecognizer.magnification
            #endif
            action(scale: Double(scale), state: gestureRecognizer.state)
        }
    }
}


public typealias RotationAction = (rotation: Double, state: NativeGestureRecognizerState) -> ()

extension NativeRotationGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var rotationAction: RotationAction? {
        get {
            return (actionHandler as? RotationGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                #if os(iOS)
                    removeTarget(handler, action: "handleGesture:")
                #elseif os(OSX)
                    target = nil
                    action = nil
                #endif
            }
            
            if let newAction = newValue {
                actionHandler = RotationGestureHandler(newAction)
                #if os(iOS)
                    addTarget(actionHandler!, action: "handleGesture:")
                #elseif os(OSX)
                    target = actionHandler
                    action = #selector(RotationGestureHandler.handleGesture(_:))
                #endif
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: NativeView, action: RotationAction) {
        self.init()
        self.referenceView = view
        self.rotationAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class RotationGestureHandler : NSObject {
        let action: RotationAction
        
        init(_ action: RotationAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: NativeRotationGestureRecognizer) {
            action(rotation: Double(gestureRecognizer.rotation), state: gestureRecognizer.state)
        }
    }
}


public typealias LongPressAction = (location: Point, state: NativeGestureRecognizerState) -> ()

extension NativePressGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var longPressAction: LongPressAction? {
        get {
            return (actionHandler as? LongPressGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                #if os(iOS)
                    removeTarget(handler, action: "handleGesture:")
                #elseif os(OSX)
                    target = nil
                    action = nil
                #endif
            }
            
            if let newAction = newValue {
                actionHandler = LongPressGestureHandler(newAction)
                #if os(iOS)
                    addTarget(actionHandler!, action: "handleGesture:")
                #elseif os(OSX)
                    target = actionHandler
                    action = #selector(LongPressGestureHandler
                        .handleGesture(_:))
                #endif
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: NativeView, action: LongPressAction) {
        self.init()
        self.referenceView = view
        self.longPressAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class LongPressGestureHandler : NSObject {
        let action: LongPressAction
        
        init(_ action: LongPressAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: NativePressGestureRecognizer) {
            action(location: gestureRecognizer.location, state: gestureRecognizer.state)
        }
    }
}


#if os(iOS)
public typealias SwipeAction = (location: Point, state: NativeGestureRecognizerState, direction: UISwipeGestureRecognizerDirection) -> ()

extension UISwipeGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var swipeAction: SwipeAction? {
        get {
            return (actionHandler as? SwipeGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                removeTarget(handler, action: "handleGesture:")
            }
            
            if let action = newValue {
                actionHandler = SwipeGestureHandler(action)
                addTarget(actionHandler!, action: "handleGesture:")
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: NativeView, action: SwipeAction) {
        self.init()
        self.referenceView = view
        self.swipeAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class SwipeGestureHandler : NSObject {
        let action: SwipeAction
        
        init(_ action: SwipeAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: UISwipeGestureRecognizer) {
            action(location: gestureRecognizer.location, state: gestureRecognizer.state, direction: gestureRecognizer.direction)
        }
    }
}
#endif

#if os(iOS)
public typealias ScreenEdgePanAction = (location: Point, state: NativeGestureRecognizerState) -> ()

extension UIScreenEdgePanGestureRecognizer {
    
    /// The closure to call when there is a gesture event.
    public var screenEdgePanAction: ScreenEdgePanAction? {
        get {
            return (actionHandler as? ScreenEdgePanGestureHandler)?.action
        }
        set {
            if let handler: AnyObject = actionHandler {
                removeTarget(handler, action: "handleGesture:")
            }
            
            if let action = newValue {
                actionHandler = ScreenEdgePanGestureHandler(action)
                addTarget(actionHandler!, action: "handleGesture:")
            } else {
                actionHandler = nil
            }
        }
    }
    
    internal convenience init(view: NativeView, action: ScreenEdgePanAction) {
        self.init()
        self.referenceView = view
        self.screenEdgePanAction = action
    }
    
    /// This class is used as the target of the gesture recognizer action. It forwards the method call to the closure.
    internal class ScreenEdgePanGestureHandler : NSObject {
        let action: ScreenEdgePanAction
        
        init(_ action: ScreenEdgePanAction) {
            self.action = action
        }
        
        func handleGesture(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
            action(location: gestureRecognizer.location, state: gestureRecognizer.state)
        }
    }
}
#endif
