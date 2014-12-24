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

import Foundation
import C4Core
import UIKit

public class C4View : NSObject, VisibleMediaObject {
    internal var view : UIView = UIView()
    
    convenience public init(frame: C4Rect) {
        self.init()
        self.view.frame = CGRect(frame)
    }
    
    public override init() {
        super.init()
        self.setupObserver()
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Media:Object
    //MARK: - Visible
    public var frame: C4Rect {
        get {
            return C4Rect(self.view.frame)
        }
        set(val) {
            self.view.frame = CGRect(val)
        }
    }
    
    public var bounds: C4Rect {
        get {
            return C4Rect(self.view.bounds)
        }
        set(val) {
            self.view.bounds = CGRect(val)
        }
    }
    
    public var center: C4Point {
        get {
            return C4Point(self.view.center)
        }
        set(val) {
            self.view.center = CGPoint(val)
        }
    }
    
    public var width: Double {
        get {
            return Double(self.view.frame.size.width)
        }
    }
    
    public var height: Double {
        get {
            return Double(self.view.frame.size.height)
        }
    }

    public var origin: C4Point {
        get { return C4Point(self.view.frame.origin)}
        set(val) { self.view.frame = CGRect(C4Rect(val,self.size)) }
    }
    
    public var size: C4Size {
        get { return C4Size(self.view.frame.size) }
        set(val) { self.view.frame = CGRect(C4Rect(origin,val)) }
    }
    
    internal var proportion: Double = 1.0
    public var constrainsProportions: Bool = false {
        didSet {
            proportion = width / height
        }
    }
 
    public var backgroundColor: C4Color = C4Color(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            self.view.backgroundColor = UIColor(backgroundColor)
        }
    }
    
    public var opacity: Double {
        get { return Double(self.view.alpha) }
        set(val) { self.view.alpha = CGFloat(val) }
    }
    
    public var hidden: Bool {
        get {
            return self.view.hidden
        }
        set(val) {
            self.view.hidden = val
        }
    }

    public var border: Border = Border() {
        didSet {
            updateBorder()
        }
    }
    
    internal func updateBorder() {
        layer?.borderWidth = CGFloat(border.width)
        layer?.borderColor = border.color.CGColor
        layer?.cornerRadius = CGFloat(border.radius)
    }
    
    public var shadow: Shadow = Shadow() {
        didSet {
            updateShadow()
        }
    }
    
    internal func updateShadow() {
        layer?.shadowColor = shadow.color.CGColor
        layer?.shadowRadius = CGFloat(shadow.radius)
        layer?.shadowOffset = CGSize(shadow.offset)
        layer?.shadowOpacity = Float(shadow.opacity)
        if shadow.path != nil {
            layer?.shadowPath = shadow.path?.CGPath
        }
    }

    public var rotation: Rotation = Rotation() {
        didSet {
            self.rotation.layer = self.view.layer
        }
    }
    
    public var perspectiveDistance: Double = 0 {
        didSet {
            //set perspective distance on layer
        }
    }
    //MARK: - Animatable
    //nothing yet
    
    //MARK: - EventSource
    public func post(event: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(event, object: self)
    }
    
    public func on(event notificationName: String, run executionBlock: Void -> Void) -> AnyObject {
        return self.on(event: notificationName, from: nil, run: executionBlock)
    }
    
    public func on(event notificationName: String, from objectToObserve: AnyObject?, run executionBlock: Void -> Void) -> AnyObject {
        let nc = NSNotificationCenter.defaultCenter()
        return nc.addObserverForName(notificationName, object: objectToObserve, queue: NSOperationQueue.currentQueue(), usingBlock: { (n: NSNotification!) in
            executionBlock()
        });
    }
    
    public func cancel(observer: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer, name: nil, object: nil)
    }
    
    public func cancel(event: String, observer: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer, name: event, object: nil)
    }
    
    public func cancel(event: String, observer: AnyObject, object: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer, name: event, object: object)
    }
    
    public func watch(property: String, of object: NSObject) {
        //TODO: would be great to simplify Key Value Observing
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
    
    //MARK: - Setup Observer
    internal var observer: NSObjectProtocol = NSObject()
    internal func setupObserver() {
        let nc = NSNotificationCenter.defaultCenter()
        let mq = NSOperationQueue.mainQueue()
        self.observer = nc.addObserverForName("", object: nil, queue: mq) { _ in self.observe() }
    }
    
    internal func observe(){}
    
    deinit { NSNotificationCenter.defaultCenter().removeObserver(self.observer) }
    
    //MARK: - Maskable
    public var mask: Mask? {
        didSet {
            self.view.layer.mask = mask?.layer
        }
    }
    
    public var layer: CALayer? {
        get {
            return self.view.layer
        }
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
        if subview is UIView {
            if let v = subview as? UIView {
                self.addSubview(v)
            }
        } else {
            if let v = subview as? C4View {
                self.addSubview(v.view)
            }
        }
    }
    public func remove<T>(subview: T) {
        if subview is UIView {
            if let v = subview as? UIView {
                v.removeFromSuperview()
            }
        } else {
            if let v = subview as? C4View {
                v.view.removeFromSuperview()
            }
        }
    }
}