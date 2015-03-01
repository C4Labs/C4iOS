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

import C4Core
import UIKit

public class C4View : NSObject {
    internal var view : UIView = UIView()
    
    public override init() {
    }
    
    /**
    Initializes a new C4View from a UIView.
    
    :param: view A UIView.
    */
    public init(view: UIView) {
        self.view = view;
    }
    
    /**
    Initializes a new C4View with the specifed frame.
    
    :param: frame A C4Rect, which describes the view’s location and size in its superview’s coordinate system.
    */
    convenience public init(frame: C4Rect) {
        self.init()
        self.view.frame = CGRect(frame)
    }
    
    /**
    Returns the receiver's layer.
    */
    public var layer: CALayer? {
        get {
            return view.layer
        }
    }
    
    /**
    Returns the receiver's frame. Animatable.
    */
    public var frame: C4Rect {
        get {
            return C4Rect(view.frame)
        }
        set {
            view.frame = CGRect(newValue)
        }
    }
    
    /**
    Returns the receiver's bounds. Animatable.
    */
    public var bounds: C4Rect {
        get {
            return C4Rect(view.bounds)
        }
        set {
            view.bounds = CGRect(newValue)
        }
    }
    
    /**
    Returns the receiver's center point. Animatable.
    */
    public var center: C4Point {
        get {
            return C4Point(view.center)
        }
        set {
            view.center = CGPoint(newValue)
        }
    }

    /**
    Returns the receiver's origin. Animatable.
    */
    public var origin: C4Point {
        get {
            return frame.origin
        }
        set {
            frame = C4Rect(newValue, self.size)
        }
    }
    
    /**
    Returns the receiver's frame size. Animatable.
    */
    public var size: C4Size {
        get {
            return bounds.size
        }
        set {
            bounds = C4Rect(origin, newValue)
        }
    }
    
    /**
    Returns the receiver's frame width. Animatable.
    */
    public var width: Double {
        get {
            return Double(bounds.size.width)
        }
    }
    
    /**
    Returns the receiver's frame height. Animatable.
    */
   public var height: Double {
        get {
            return Double(bounds.size.height)
        }
    }
 
    /**
    Returns the receiver's background color. Animatable.
    */
    public var backgroundColor: C4Color? {
        get {
            if let color = view.backgroundColor {
                return C4Color(color)
            } else {
                return nil
            }
        }
        set {
            if let color = newValue {
                view.backgroundColor = UIColor(color)
            } else {
                view.backgroundColor = nil
            }
        }
    }
    
    /**
    Returns the receiver's opacity. Animatable.
    */
    public var opacity: Double {
        get {
            return Double(view.alpha)
        }
        set {
            view.alpha = CGFloat(newValue)
        }
    }
    
    /**
    Returns true if the receiver is hidden, false if visible.
    */
    public var hidden: Bool {
        get {
            return view.hidden
        }
        set {
            view.hidden = newValue
        }
    }
    
    /**
    Returns the receiver's current transform.
    */
    public var transform: C4Transform {
        get {
            return C4Transform(view.layer.transform)
        }
        set {
            view.layer.transform = newValue.transform3D
        }
    }
    
    //MARK: - EventSource
    
    internal func post(event: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(event, object: self)
    }
    
    public func on(event notificationName: String, run executionBlock: Void -> Void) -> AnyObject {
        let nc = NSNotificationCenter.defaultCenter()
        return nc.addObserverForName(notificationName, object: self, queue: NSOperationQueue.currentQueue(), usingBlock: { notification in
            executionBlock()
        });
    }
    
    public func cancel(observer: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer)
    }
    

    //MARK: - Touchable
    /**
    Returns true if the receiver accepts touch events.
    */
    public var interactionEnabled: Bool = true {
        didSet {
            self.view.userInteractionEnabled = interactionEnabled
        }
    }
    
    /**
    Adds a tap gesture recognizer to the receiver's view.
    
    :param: action A block of code to be executed when the receiver recognizes a tap gesture.
    :returns: A UITapGestureRecognizer that can be customized.
    */
    public func addTapGestureRecognizer(action: TapAction) -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /**
    Adds a pan gesture recognizer to the receiver's view.
    
    :param: action A block of code to be executed when the receiver recognizes a pan gesture.
    :returns: A UIPanGestureRecognizer that can be customized.
    */
    public func addPanGestureRecognizer(action: PanAction) -> UIPanGestureRecognizer {
        let gestureRecognizer = UIPanGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /**
    Adds a pinch gesture recognizer to the receiver's view.
    
    :param: action A block of code to be executed when the receiver recognizes a pinch gesture.
    :returns: A UIPinchGestureRecognizer that can be customized.
    */
    public func addPinchGestureRecognizer(action: PinchAction) -> UIPinchGestureRecognizer {
        let gestureRecognizer = UIPinchGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /**
    Adds a rotation gesture recognizer to the receiver's view.
    
    :param: action A block of code to be executed when the receiver recognizes a rotation gesture.
    :returns: A UIRotationGestureRecognizer that can be customized.
    */
    public func addRotationGestureRecognizer(action: RotationAction) -> UIRotationGestureRecognizer {
        let gestureRecognizer = UIRotationGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /**
    Adds a longpress gesture recognizer to the receiver's view.
    
    :param: action A block of code to be executed when the receiver recognizes a longpress gesture.
    :returns: A UILongPressGestureRecognizer that can be customized.
    */
    public func addLongPressGestureRecognizer(action: LongPressAction) -> UILongPressGestureRecognizer {
        let gestureRecognizer = UILongPressGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /**
    Adds a swipe gesture recognizer to the receiver's view.
    
    :param: action A block of code to be executed when the receiver recognizes a swipe gesture.
    :returns: A UISwipeGestureRecognizer that can be customized.
    */
    public func addSwipeGestureRecognizer(action: SwipeAction) -> UISwipeGestureRecognizer {
        let gestureRecognizer = UISwipeGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /**
    Adds a screen edge pan gesture recognizer to the receiver's view.
    
    :param: action A block of code to be executed when the receiver recognizes a screen edge pan gesture.
    :returns: A UIScreenEdgePanGestureRecognizer that can be customized.
    */
    public func addScreenEdgePanGestureRecognizer(action: ScreenEdgePanAction) -> UIScreenEdgePanGestureRecognizer {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    //MARK: - AddRemoveSubview
    /**
    Adds a view to the end of the receiver’s list of subviews.

    When working with C4, use this method to add views because it handles the addition of both UIView and C4View.
    :param: view	The view to be added.
    */
    public func add<T>(subview: T) {
        if let v = subview as? UIView {
            view.addSubview(v)
        }
        else if let v = subview as? C4View {
            view.addSubview(v.view)
        }
    }

    /**
    Unlinks the view from the receiver and its window, and removes it from the responder chain.
    
    Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the subtree of the view you are removing.
    
    When working with C4, use this method to add views because it handles the removal of both UIView and C4View.
    
    :param: view	The view to be removed.
    */
    public func remove<T>(subview: T) {
        if let v = subview as? UIView {
            v.removeFromSuperview()
        }
        else if let v = subview as? C4View {
            v.view.removeFromSuperview()
        }
    }
    
    /**
    Unlinks the view from its superview and its window, and removes it from the responder chain.
    
    If the view’s superview is not nil, the superview releases the view.

    Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the subtree of the view you are removing.
    */
    public func removeFromSuperview() {
        self.view.removeFromSuperview()
    }
    
    //MARK: - HitTest
    
    /**
    Returns whether a specified point is contained within the frame of the receiver.

    :param: point	The point to examine.
    */
    public func hitTest(point: C4Point) -> Bool {
        return CGRectContainsPoint(CGRect(bounds), CGPoint(point))
    }
}

/**
Extension to UIView that adds handling addition and removal of C4View objects.
*/
extension UIView {
    /**
    Adds a view to the end of the receiver’s list of subviews.
    
    When working with C4, use this method to add views because it handles the addition of both UIView and C4View.
    :param: view	The view to be added.
    */
    public func add<T>(subview: T) {
        if let v = subview as? UIView {
            self.addSubview(v)
        } else if let v = subview as? C4View {
            self.addSubview(v.view)
        }
    }
    
    /**
    Unlinks the view from the receiver and its window, and removes it from the responder chain.
    
    Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the subtree of the view you are removing.
    
    When working with C4, use this method to add views because it handles the removal of both UIView and C4View.
    
    :param: view	The view to be removed.
    */
    public func remove<T>(subview: T) {
        if let v = subview as? UIView {
            v.removeFromSuperview()
        } else if let v = subview as? C4View {
            v.view.removeFromSuperview()
        }
    }
}
