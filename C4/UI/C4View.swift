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

import UIKit

extension NSValue {
    ///  Initializes an NSValue with a C4Point
    ///
    ///  - parameter point: a C4Point
    convenience init(C4Point point: C4Point) {
        self.init(CGPoint: CGPoint(point))
    }
}

/// The C4View class defines a rectangular area on the screen and the interfaces for managing visual content in that area. The C4View class itself provides basic behavior for filling its rectangular area with a background color. More sophisticated content can be presented by subclassing UIView and implementing the necessary drawing and event-handling code yourself. The C4 framework also includes a set of standard subclasses that range from simple shapes to movies and images that can be used as-is.
public class C4View : NSObject {
    /// A UIView. Internally, C4View wraps and provides access to an internal UIView.
    public var view : UIView = UIView()

    ///  Initializes a C4View.
    public override init() {
    }
    
    /// Initializes a new C4View from a UIView.
    ///
    /// - parameter view: A UIView.
    public init(view: UIView) {
        self.view = view;
    }
    
    /// Initializes a new C4View with the specifed frame.
    ///
    /// ````
    /// let f = C4Rect(0,0,100,100)
    /// let v = C4View(frame: f)
    /// canvas.add(v)
    /// ````
    ///
    /// - parameter frame: A C4Rect, which describes the view’s location and size in its superview’s coordinate system.
    convenience public init(frame: C4Rect) {
        self.init()
        self.view.frame = CGRect(frame)
    }
    
    /// Returns the receiver's layer.
    public dynamic var layer: CALayer? {
        get {
            return view.layer
        }
    }
    
    /// Returns the receiver's frame. Animatable.
    public var frame: C4Rect {
        get {
            return C4Rect(view.frame)
        }
        set {
            view.frame = CGRect(newValue)
        }
    }
    
    /// Returns the receiver's bounds. Animatable.
    public var bounds: C4Rect {
        get {
            return C4Rect(view.bounds)
        }
        set {
            view.bounds = CGRect(newValue)
        }
    }
    
    /// Returns the receiver's center point. Animatable.
    public var center: C4Point {
        get {
            return C4Point(view.center)
        }
        set {
            view.center = CGPoint(newValue)
        }
    }
    
    /// Returns the receiver's origin. Animatable.
    public var origin: C4Point {
        get {
            return frame.origin
        }
        set {
            frame = C4Rect(newValue, self.size)
        }
    }
    
    /// Returns the receiver's frame size. Animatable.
    public var size: C4Size {
        get {
            return bounds.size
        }
        set {
            bounds = C4Rect(origin, newValue)
        }
    }
    
    /// Returns the receiver's frame width. Animatable.
    public dynamic var width: Double {
        get {
            return Double(bounds.size.width)
        }
    }
    
    /// Returns the receiver's frame height. Animatable.
   public dynamic var height: Double {
        get {
            return Double(bounds.size.height)
        }
    }
 
    /// Returns the receiver's background color. Animatable.
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
    
    /// Returns the receiver's opacity. Animatable.
    public dynamic var opacity: Double {
        get {
            return Double(view.alpha)
        }
        set {
            view.alpha = CGFloat(newValue)
        }
    }
    
    /// Returns true if the receiver is hidden, false if visible.
    public var hidden: Bool {
        get {
            return view.hidden
        }
        set {
            view.hidden = newValue
        }
    }
    
    /// Returns the receiver's current transform.
    public var transform: C4Transform {
        get {
            return C4Transform(view.layer.transform)
        }
        set {
            view.layer.transform = newValue.transform3D
        }
    }
    
    /// Defines the anchor point of the layer's bounds rect, as a point in
    /// normalized layer coordinates - '(0, 0)' is the bottom left corner of
    /// the bounds rect, '(1, 1)' is the top right corner. Defaults to
    /// '(0.5, 0.5)', i.e. the center of the bounds rect. Animatable.
    public var anchorPoint: C4Point {
        get {
            return C4Point(view.layer.anchorPoint)
        }
        set(val) {
            let oldFrame = view.frame
            view.layer.anchorPoint = CGPoint(val)
            view.frame = oldFrame
        }
    }

    ///  The layer’s position on the z axis. Animatable.
    ///
    ///  The default value of this property is 0. Changing the value of this property changes the the front-to-back ordering of layers onscreen. This can affect the visibility of layers whose frame rectangles overlap.
    ///  The value of this property is measured in points.
    public dynamic var zPosition : Double {
        get {
            return Double(self.layer!.zPosition)
        } set {
            self.layer!.zPosition = CGFloat(newValue)
        }
    }

    ///  An optional view whose alpha channel is used to mask the receiver's content.
    ///
    ///  The mask view's alpha channel determines how much of the receiver's content and background shows through. Fully or partially opaque pixels allow the underlying content to show through but fully transparent pixels block that content.
    ///  The default value of this property is nil. When configuring a mask, remember to set the size and position of the mask layer to ensure it is aligned properly with the layer it masks.
    ///  The layer you assign to this property must not have a superlayer. If it does, the behavior is undefined.
    public var mask: C4View? {
        didSet {
            if let mask = mask, let _ = mask.view.superview {
                print("Invalid Mask. The view you are using as a mask has already been added to another view.")
                self.mask = nil
            } else {
                self.layer?.mask = mask?.layer
            }
        }
    }

    //MARK: - Touchable
    
    /// Returns true if the receiver accepts touch events.
    public var interactionEnabled: Bool = true {
        didSet {
            self.view.userInteractionEnabled = interactionEnabled
        }
    }
    
    /// Adds a tap gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = C4Rect(0,0,100,100)
    /// let v = C4View(frame: f)
    /// v.addTapGestureRecognizer { location, state in
    ///     println("tapped")
    /// }
    /// ````
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a tap gesture.
    ///
    /// - returns: A UITapGestureRecognizer that can be customized.
    public func addTapGestureRecognizer(action: TapAction) -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /// Adds a pan gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = C4Rect(0,0,100,100)
    /// let v = C4View(frame: f)
    /// v.addPanGestureRecognizer { location, translation, velocity, state in
    ///     println("panned")
    /// }
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a pan gesture.
    ///
    /// - returns: A UIPanGestureRecognizer that can be customized.
    public func addPanGestureRecognizer(action: PanAction) -> UIPanGestureRecognizer {
        let gestureRecognizer = UIPanGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /// Adds a pinch gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = C4Rect(0,0,100,100)
    /// let v = C4View(frame: f)
    /// v.addPinchGestureRecognizer { scale, velocity, state in
    ///     println("pinched")
    /// }
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a pinch gesture.
    ///
    /// - returns: A UIPinchGestureRecognizer that can be customized.
    public func addPinchGestureRecognizer(action: PinchAction) -> UIPinchGestureRecognizer {
        let gestureRecognizer = UIPinchGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /// Adds a rotation gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = C4Rect(0,0,100,100)
    /// let v = C4View(frame: f)
    /// v.addRotationGestureRecognizer { rotation, velocity, state in
    ///     println("rotated")
    /// }
    /// ````
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a rotation gesture.
    ///
    /// - returns: A UIRotationGestureRecognizer that can be customized.
    public func addRotationGestureRecognizer(action: RotationAction) -> UIRotationGestureRecognizer {
        let gestureRecognizer = UIRotationGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /// Adds a longpress gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = C4Rect(0,0,100,100)
    /// let v = C4View(frame: f)
    /// v.addLongPressGestureRecognizer { location, state in
    ///     println("longpress")
    /// }
    /// ````
    /// - parameter action: A block of code to be executed when the receiver recognizes a longpress gesture.
    ///
    /// - returns: A UILongPressGestureRecognizer that can be customized.
    public func addLongPressGestureRecognizer(action: LongPressAction) -> UILongPressGestureRecognizer {
        let gestureRecognizer = UILongPressGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /// Adds a swipe gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let f = C4Rect(0,0,100,100)
    /// let v = C4View(frame: f)
    /// v.addSwipeGestureRecognizer { location, state in
    ///     println("swiped")
    /// }
    /// ````
    ///
    /// - parameter action: A block of code to be executed when the receiver recognizes a swipe gesture.
    ///
    /// - returns: A UISwipeGestureRecognizer that can be customized.
    public func addSwipeGestureRecognizer(action: SwipeAction) -> UISwipeGestureRecognizer {
        let gestureRecognizer = UISwipeGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    /// Adds a screen edge pan gesture recognizer to the receiver's view.
    ///
    /// ````
    /// let v = C4View(frame: canvas.bounds)
    /// v.addSwipeGestureRecognizer { location, state in
    /// println("edge pan")
    /// }
    /// ````
    /// - parameter action: A block of code to be executed when the receiver recognizes a screen edge pan gesture.
    ///
    /// - returns: A UIScreenEdgePanGestureRecognizer that can be customized.
    public func addScreenEdgePanGestureRecognizer(action: ScreenEdgePanAction) -> UIScreenEdgePanGestureRecognizer {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }
    
    //MARK: - AddRemoveSubview
    
    /// Adds a view to the end of the receiver’s list of subviews.
    ///
    /// When working with C4, use this method to add views because it handles the addition of both UIView and C4View.
    ///
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// let subv = C4View(frame: C4Rect(25,25,50,50))
    /// v.add(subv)
    /// ````
    /// - parameter view:	The view to be added.
    public func add<T>(subview: T?) {
        if let v = subview as? UIView {
            view.addSubview(v)
        } else if let v = subview as? C4View {
            view.addSubview(v.view)
        } else {
            fatalError("Can't add subview of class `\(subview.dynamicType)`")
        }
    }
    
    //MARK: - AddRemoveSubview
    
    /// Adds an array of views to the end of the receiver’s list of subviews.
    ///
    /// When working with C4, use this method to add views because it handles the addition of both UIView and C4View.
    ///
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// let subv1 = C4View(frame: C4Rect(25,25,50,50))
    /// let subv2 = C4View(frame: C4Rect(100,25,50,50))
    /// v.add([subv1,subv2])
    /// ````
    ///
    /// - parameter view:	The view to be added.
    public func add<T>(subviews: [T?]) {
        for subv in subviews {
            self.add(subv)
        }
    }
    
    /// Unlinks the view from the receiver and its window, and removes it from the responder chain.
    ///
    /// Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the
    /// subtree of the view you are removing.
    ///
    /// When working with C4, use this method to add views because it handles the removal of both UIView and C4View.
    ///
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// let subv = C4View(frame: C4Rect(25,25,50,50))
    /// v.add(subv)
    /// v.remove(subv)
    /// ````
    ///
    /// - parameter view:	The view to be removed.
    public func remove<T>(subview: T?) {
        if let v = subview as? UIView {
            v.removeFromSuperview()
        } else if let v = subview as? C4View {
            v.view.removeFromSuperview()
        } else {
            fatalError("Can't remove subview of class `\(subview.dynamicType)`")
        }
    }
    
    /// Unlinks the view from its superview and its window, and removes it from the responder chain.
    ///
    /// If the view’s superview is not nil, the superview releases the view.
    ///
    /// Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the
    /// subtree of the view you are removing.
    ///
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// let subv = C4View(frame: C4Rect(25,25,50,50))
    /// v.add(subv)
    /// subv.removeFromSuperview()
    /// ````
    public func removeFromSuperview() {
        self.view.removeFromSuperview()
    }
    
    /// Moves the specified subview so that it appears behind its siblings.
    ///
    /// - parameter view: The subview to move to the back.
    public func sendToBack<T>(subview: T?) {
        if let v = subview as? UIView {
            view.sendSubviewToBack(v)
        } else if let v = subview as? C4View {
            view.sendSubviewToBack(v.view)
        } else {
            fatalError("Can't operate on subview of class `\(subview.dynamicType)`")
        }
    }
    
    /// Moves the specified subview so that it appears on top of its siblings.
    ///
    /// - parameter view: The subview to move to the front.
    public func bringToFront<T>(subview: T?) {
        if let v = subview as? UIView {
            view.bringSubviewToFront(v)
        } else if let v = subview as? C4View {
            view.bringSubviewToFront(v.view)
        } else {
            fatalError("Can't operate on subview of class `\(subview.dynamicType)`")
        }
    }
    
    //MARK: - HitTest
    
    /// Checks if a specified point falls within the bounds of the current object.
    ///
    /// - note:
    /// Because each view has its own coordinates, if you want to check if a point from anywhere on screen falls within a
    /// specific view you should use `hitTest(point, from: canvas)`.
    ///
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// v.hitTest(C4Point(50,50)) //-> true
    /// v.hitTest(C4Point(50, 101)) //-> false
    /// ````
    ///
    /// - parameter point: A `C4Point` to examine
    ///
    /// - returns: `true` if the point is within the object's frame, otherwise `false`.
    public func hitTest(point: C4Point) -> Bool {
        return CGRectContainsPoint(CGRect(bounds), CGPoint(point))
    }
    
    /// Checks if a specified point, from another view, falls within the frame of the receiver.
    ///
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// canvas.add(v)
    ///
    /// canvas.addTapGestureRecognizer() { location, state in
    ///     if v.hitTest(location, from: self.canvas) {
    ///         println("C4")
    ///     }
    /// }
    /// ````
    ///
    /// - returns: `true` if the point is within the object's frame, otherwise `false`.
    public func hitTest(point: C4Point, from: C4View) -> Bool {
        let p = convert(point, from:from)
        return hitTest(p)
    }
    
    //MARK: – Convert
    
    /// Converts a specified point from a given view's coordinate system to that of the receiver.
    ///
    /// ````
    /// let p = C4Point()
    /// let cp = aView.convert(p, from:canvas)
    /// ````
    ///
    /// - returns: A `C4Point` whose values have been translated into the receiver's coordinate system.
    public func convert(point: C4Point, from: C4View) -> C4Point {
        return C4Point(view.convertPoint(CGPoint(point), fromCoordinateSpace: from.view))
    }
    
}


/// Extension to UIView that adds handling addition and removal of C4View objects.
extension UIView {
    
    /// Adds a view to the end of the receiver’s list of subviews.
    ///
    /// When working with C4, use this method to add views because it handles the addition of both UIView and C4View.
    ///
    /// - parameter view:	The view to be added.
    public func add<T>(subview: T?) {
        if let v = subview as? UIView {
            self.addSubview(v)
        } else if let v = subview as? C4View {
            self.addSubview(v.view)
        } else {
            fatalError("Can't add subview of class `\(subview.dynamicType)`")
        }
    }
    
    //MARK: - AddRemoveSubview
    
    /// Adds an array of views to the end of the receiver’s list of subviews.
    ///
    /// When working with C4, use this method to add views because it handles the addition of both UIView and C4View.
    ///
    /// ````
    /// let v = C4View(frame: C4Rect(0,0,100,100))
    /// let subv1 = C4View(frame: C4Rect(25,25,50,50))
    /// let subv2 = C4View(frame: C4Rect(100,25,50,50))
    /// v.add([subv1,subv2])
    /// ````
    ///
    /// - parameter view:	The view to be added.
    public func add<T>(subviews: [T?]) {
        for subv in subviews {
            self.add(subv)
        }
    }
    
    /// Unlinks the view from the receiver and its window, and removes it from the responder chain.
    ///
    /// Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the
    /// subtree of the view you are removing.
    ///
    /// When working with C4, use this method to remove views because it handles the removal of both UIView and C4View.
    ///
    /// - parameter view:	The view to be removed.
    public func remove<T>(subview: T?) {
        if let v = subview as? UIView {
            v.removeFromSuperview()
        } else if let v = subview as? C4View {
            v.view.removeFromSuperview()
        } else {
            fatalError("Can't remove subview of class `\(subview.dynamicType)`")
        }
    }
    
    /// Moves the specified subview so that it appears behind its siblings.
    ///
    /// When working with C4, use this method because it handles both UIView and C4View.
    ///
    /// - parameter view: The subview to move to the back.
    public func sendToBack<T>(subview: T?) {
        if let v = subview as? UIView {
            self.sendSubviewToBack(v)
        } else if let v = subview as? C4View {
            self.sendSubviewToBack(v.view)
        } else {
            fatalError("Can't operate on subview of class `\(subview.dynamicType)`")
        }
    }
    
    /// Moves the specified subview so that it appears on top of its siblings.
    ///
    /// When working with C4, use this method because it handles both UIView and C4View.
    ///
    /// - parameter view: The subview to move to the front.
    public func bringToFront<T>(subview: T?) {
        if let v = subview as? UIView {
            self.bringSubviewToFront(v)
        } else if let v = subview as? C4View {
            self.bringSubviewToFront(v.view)
        } else {
            fatalError("Can't operate on subview of class `\(subview.dynamicType)`")
        }
    }
}
