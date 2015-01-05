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
    
    convenience public init(frame: C4Rect) {
        self.init()
        self.view.frame = CGRect(frame)
    }
    
    public var layer: CALayer? {
        get {
            return view.layer
        }
    }
    
    public var frame: C4Rect {
        get {
            return C4Rect(view.frame)
        }
        set {
            view.frame = CGRect(newValue)
        }
    }
    
    public var bounds: C4Rect {
        get {
            return C4Rect(view.bounds)
        }
        set {
            view.bounds = CGRect(newValue)
        }
    }
    
    public var center: C4Point {
        get {
            return C4Point(view.center)
        }
        set {
            view.center = CGPoint(newValue)
        }
    }

    public var origin: C4Point {
        get {
            return frame.origin
        }
        set {
            frame = C4Rect(newValue, self.size)
        }
    }
    
    public var size: C4Size {
        get {
            return bounds.size
        }
        set {
            bounds = C4Rect(origin, newValue)
        }
    }
    
    public var width: Double {
        get {
            return Double(bounds.size.width)
        }
    }
    
    public var height: Double {
        get {
            return Double(bounds.size.height)
        }
    }
 
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
    
    public var opacity: Double {
        get {
            return Double(view.alpha)
        }
        set {
            view.alpha = CGFloat(newValue)
        }
    }
    
    public var hidden: Bool {
        get {
            return view.hidden
        }
        set {
            view.hidden = newValue
        }
    }
    
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
        return nc.addObserverForName(notificationName, object: nil, queue: NSOperationQueue.currentQueue(), usingBlock: { notification in
            executionBlock()
        });
    }
    
    public func on(event notificationName: String, from object: AnyObject, run executionBlock: Void -> Void) -> AnyObject {
        let nc = NSNotificationCenter.defaultCenter()
        return nc.addObserverForName(notificationName, object: object, queue: NSOperationQueue.currentQueue(), usingBlock: { notification in
            executionBlock()
        });
    }
    
    public func cancel(observer: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer)
    }
    

    //MARK: - Touchable
    
    public var interactionEnabled: Bool = true {
        didSet {
            self.view.userInteractionEnabled = interactionEnabled
        }
    }
    
    public func addTapGestureRecognizer(action: TapAction) -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    public func addPanGestureRecognizer(action: PanAction) -> UIPanGestureRecognizer {
        let gestureRecognizer = UIPanGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    public func addPinchGestureRecognizer(action: PinchAction) -> UIPinchGestureRecognizer {
        let gestureRecognizer = UIPinchGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    public func addRotationGestureRecognizer(action: RotationAction) -> UIRotationGestureRecognizer {
        let gestureRecognizer = UIRotationGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    public func addLongPressGestureRecognizer(action: LongPressAction) -> UILongPressGestureRecognizer {
        let gestureRecognizer = UILongPressGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    public func addSwipeGestureRecognizer(action: SwipeAction) -> UISwipeGestureRecognizer {
        let gestureRecognizer = UISwipeGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    public func addScreenEdgePanGestureRecognizer(action: ScreenEdgePanAction) -> UIScreenEdgePanGestureRecognizer {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    
    //MARK: - AddRemoveSubview
    
    public func add<T>(subview: T) {
        if let v = subview as? UIView {
            view.addSubview(v)
        }
        else if let v = subview as? C4View {
            view.addSubview(v.view)
        }
    }
    public func remove<T>(subview: T) {
        if let v = subview as? UIView {
            v.removeFromSuperview()
        }
        else if let v = subview as? C4View {
            v.view.removeFromSuperview()
        }
    }
    public func removeFromSuperview() {
        self.view.removeFromSuperview()
    }
}

extension UIView {
    public func add<T>(subview: T) {
        if let v = subview as? UIView {
            self.addSubview(v)
        } else if let v = subview as? C4View {
            self.addSubview(v.view)
        }
    }
    
    public func remove<T>(subview: T) {
        if let v = subview as? UIView {
            v.removeFromSuperview()
        } else if let v = subview as? C4View {
            v.view.removeFromSuperview()
        }
    }
}
