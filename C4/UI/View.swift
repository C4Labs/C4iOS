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
    /// Initializes an NSValue with a Point
    /// - parameter point: a Point
    convenience init(Point point: Point) {
        self.init(cgPoint: CGPoint(point))
    }
}

/// The View class defines a rectangular area on the screen and the interfaces for managing visual content in that area. The View class itself provides basic behavior for filling its rectangular area with a background color. More sophisticated content can be presented by subclassing UIView and implementing the necessary drawing and event-handling code yourself. The C4 framework also includes a set of standard subclasses that range from simple shapes to movies and images that can be used as-is.
public class View: NSObject {
    /// A UIView. Internally, View wraps and provides access to an internal UIView.
    public var view: UIView = LayerView()

    /// The current rotation value of the view. Animatable.
    /// - returns: A Double value representing the cumulative rotation of the view, measured in Radians.
    public var rotation: Double {
        get {
            if let number = animatableLayer.value(forKeyPath: Layer.rotationKey) as? NSNumber {
                return number.doubleValue
            }
            return  0.0
        }
        set {
            animatableLayer.setValue(newValue, forKeyPath: Layer.rotationKey)
        }
    }

    /// The view that contains the receiver's animatable layer.
    internal var layerView: LayerView {
        return self.view as! LayerView // swiftlint:disable:this force_cast
    }

    internal class LayerView: UIView {
        var animatableLayer: Layer {
            return self.layer as! Layer // swiftlint:disable:this force_cast
        }

        override class var layerClass: AnyClass {
            return Layer.self
        }
    }

    /// The view's primary layer.
    /// - returns: A Layer, whose properties are animatable (e.g. rotation)
    public var animatableLayer: Layer {
        return self.layerView.animatableLayer
    }

    ///  Initializes a View.
    public override init() {
    }

    /// Initializes a new View from a UIView.
    /// - parameter view: A UIView.
    public init(view: UIView) {
        self.view = view
    }

    public init(copyView: View) {
        //If there is a scale transform we need to undo that
        let t = copyView.view.transform.inverted()
        let x = sqrt(t.a * t.a + t.c * t.c)
        let y = sqrt(t.b * t.b + t.d * t.d)
        let s = CGAffineTransform(scaleX: x, y: y)
        let frame = Rect(copyView.view.frame.applying(s))
        super.init()
        view.frame = CGRect(frame)
        copyViewStyle(copyView)
    }

    public func copyViewStyle(_ viewToCopy: View) {
        ShapeLayer.disableActions = true
        anchorPoint = viewToCopy.anchorPoint
        shadow = viewToCopy.shadow
        border = viewToCopy.border
        rotation = viewToCopy.rotation
        interactionEnabled = viewToCopy.interactionEnabled
        backgroundColor = viewToCopy.backgroundColor
        opacity = viewToCopy.opacity

        if let maskToCopy = viewToCopy.mask {
            if viewToCopy.mask is Shape {
                mask = Shape(copy: viewToCopy.mask as! Shape) // swiftlint:disable:this force_cast
            } else if viewToCopy.mask is Image {
                mask = Image(copy: viewToCopy.mask as! Image) // swiftlint:disable:this force_cast
            } else {
                mask = View(copyView: maskToCopy)
            }
            mask?.center = maskToCopy.center
        }

        transform = viewToCopy.transform
        ShapeLayer.disableActions = false
    }

    /// Initializes a new View with the specifed frame.
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// canvas.add(v)
    /// ````
    /// - parameter frame: A Rect, which describes the view’s location and size in its superview’s coordinate system.
    public init(frame: Rect) {
        super.init()
        self.view.frame = CGRect(frame)
    }

    /// Returns the receiver's layer.
    public dynamic var layer: CALayer? {
        return view.layer
    }

    /// Returns the receiver's frame. Animatable.
    public var frame: Rect {
        get {
            return Rect(view.frame)
        }
        set {
            view.frame = CGRect(newValue)
        }
    }

    /// Returns the receiver's bounds. Animatable.
    public var bounds: Rect {
        get {
            return Rect(view.bounds)
        }
        set {
            view.bounds = CGRect(newValue)
        }
    }

    /// A Boolean indicating whether subviews, and layers are clipped to the object’s bounds. Animatable.
    public var masksToBounds: Bool {
        get {
            return layer!.masksToBounds
        }
        set {
            layer?.masksToBounds = newValue
        }
    }

    /// Returns the receiver's center point. Animatable.
    public var center: Point {
        get {
            return Point(view.center)
        }
        set {
            view.center = CGPoint(newValue)
        }
    }

    /// Returns the receiver's origin. Animatable.
    public var origin: Point {
        get {
            return center - Vector(x: size.width/2, y: size.height/2)
        }
        set {
            center = newValue + Vector(x: size.width/2, y: size.height/2)
        }
    }

    /// Returns the receiver's frame size. Animatable.
    public var size: Size {
        get {
            return bounds.size
        }
        set {
            bounds = Rect(origin, newValue)
        }
    }

    /// Returns the receiver's frame width. Animatable.
    public dynamic var width: Double {
        return Double(bounds.size.width)
    }

    /// Returns the receiver's frame height. Animatable.
    public dynamic var height: Double {
        return Double(bounds.size.height)
    }

    /// Returns the receiver's background color. Animatable.
    public var backgroundColor: Color? {
        get {
            if let color = view.backgroundColor {
                return Color(color)
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
            return view.isHidden
        }
        set {
            view.isHidden = newValue
        }
    }

    /// Returns the receiver's current transform.
    public var transform: Transform {
        get {
            return Transform(view.layer.transform)
        }
        set {
            view.layer.transform = newValue.transform3D
        }
    }

    /// Defines the anchor point of the layer's bounds rect, as a point in
    /// normalized layer coordinates - '(0, 0)' is the bottom left corner of
    /// the bounds rect, '(1, 1)' is the top right corner. Defaults to
    /// '(0.5, 0.5)', i.e. the center of the bounds rect. Animatable.
    public var anchorPoint: Point {
        get {
            return Point(view.layer.anchorPoint)
        }
        set(val) {
            let oldFrame = view.frame
            view.layer.anchorPoint = CGPoint(val)
            view.frame = oldFrame
        }
    }

    ///  The layer’s position on the z axis. Animatable.
    ///  The default value of this property is 0. Changing the value of this property changes the the front-to-back ordering of layers onscreen. This can affect the visibility of layers whose frame rectangles overlap.
    ///  The value of this property is measured in points.
    public dynamic var zPosition: Double {
        get {
            return Double(self.layer!.zPosition)
        } set {
            self.layer!.zPosition = CGFloat(newValue)
        }
    }

    ///  An optional view whose alpha channel is used to mask the receiver's content.
    ///  The mask view's alpha channel determines how much of the receiver's content and background shows through. Fully or partially opaque pixels allow the underlying content to show through but fully transparent pixels block that content.
    ///  The default value of this property is nil. When configuring a mask, remember to set the size and position of the mask layer to ensure it is aligned properly with the layer it masks.
    ///  The layer you assign to this property must not have a superlayer. If it does, the behavior is undefined.
    public var mask: View? {
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
            self.view.isUserInteractionEnabled = interactionEnabled
        }
    }

    /// Adds a tap gesture recognizer to the receiver's view.
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addTapGestureRecognizer { location, state in
    ///     println("tapped")
    /// }
    /// ````
    /// - parameter action: A block of code to be executed when the receiver recognizes a tap gesture.
    /// - returns: A UITapGestureRecognizer that can be customized.
    public func addTapGestureRecognizer(_ action: @escaping TapAction) -> UITapGestureRecognizer {
        let gestureRecognizer = UITapGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// Adds a pan gesture recognizer to the receiver's view.
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addPanGestureRecognizer { location, translation, velocity, state in
    ///     println("panned")
    /// }
    /// - parameter action: A block of code to be executed when the receiver recognizes a pan gesture.
    /// - returns: A UIPanGestureRecognizer that can be customized.
    public func addPanGestureRecognizer(_ action: @escaping PanAction) -> UIPanGestureRecognizer {
        let gestureRecognizer = UIPanGestureRecognizer(view: self.view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// Adds a pinch gesture recognizer to the receiver's view.
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addPinchGestureRecognizer { scale, velocity, state in
    ///     println("pinched")
    /// }
    /// - parameter action: A block of code to be executed when the receiver recognizes a pinch gesture.
    /// - returns: A UIPinchGestureRecognizer that can be customized.
    public func addPinchGestureRecognizer(_ action: @escaping PinchAction) -> UIPinchGestureRecognizer {
        let gestureRecognizer = UIPinchGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// Adds a rotation gesture recognizer to the receiver's view.
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addRotationGestureRecognizer { rotation, velocity, state in
    ///     println("rotated")
    /// }
    /// ````
    /// - parameter action: A block of code to be executed when the receiver recognizes a rotation gesture.
    /// - returns: A UIRotationGestureRecognizer that can be customized.
    public func addRotationGestureRecognizer(_ action: @escaping RotationAction) -> UIRotationGestureRecognizer {
        let gestureRecognizer = UIRotationGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// Adds a longpress gesture recognizer to the receiver's view.
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addLongPressGestureRecognizer { location, state in
    ///     println("longpress")
    /// }
    /// ````
    /// - parameter action: A block of code to be executed when the receiver recognizes a longpress gesture.
    /// - returns: A UILongPressGestureRecognizer that can be customized.
    public func addLongPressGestureRecognizer(_ action: @escaping LongPressAction) -> UILongPressGestureRecognizer {
        let gestureRecognizer = UILongPressGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// Adds a swipe gesture recognizer to the receiver's view.
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// v.addSwipeGestureRecognizer { location, state in
    ///     println("swiped")
    /// }
    /// ````
    /// - parameter action: A block of code to be executed when the receiver recognizes a swipe gesture.
    /// - returns: A UISwipeGestureRecognizer that can be customized.
    public func addSwipeGestureRecognizer(_ action: @escaping SwipeAction) -> UISwipeGestureRecognizer {
        let gestureRecognizer = UISwipeGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    /// Adds a screen edge pan gesture recognizer to the receiver's view.
    /// ````
    /// let v = View(frame: canvas.bounds)
    /// v.addSwipeGestureRecognizer { location, state in
    /// println("edge pan")
    /// }
    /// ````
    /// - parameter action: A block of code to be executed when the receiver recognizes a screen edge pan gesture.
    /// - returns: A UIScreenEdgePanGestureRecognizer that can be customized.
    public func addScreenEdgePanGestureRecognizer(_ action: @escaping ScreenEdgePanAction) -> UIScreenEdgePanGestureRecognizer {
        let gestureRecognizer = UIScreenEdgePanGestureRecognizer(view: view, action: action)
        self.view.addGestureRecognizer(gestureRecognizer)
        return gestureRecognizer
    }

    //MARK: - AddRemoveSubview

    /// Adds a view to the end of the receiver’s list of subviews.
    /// When working with C4, use this method to add views because it handles the addition of both UIView and View.
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv = View(frame: Rect(25,25,50,50))
    /// v.add(subv)
    /// ````
    /// - parameter subview: The view to be added.
    public func add<T>(_ subview: T?) {
        if let v = subview as? UIView {
            view.addSubview(v)
        } else if let v = subview as? View {
            view.addSubview(v.view)
        } else {
            fatalError("Can't add subview of class `\(type(of: subview))`")
        }
    }

    //MARK: - AddRemoveSubview

    /// Adds an array of views to the end of the receiver’s list of subviews.
    /// When working with C4, use this method to add views because it handles the addition of both UIView and View.
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv1 = View(frame: Rect(25,25,50,50))
    /// let subv2 = View(frame: Rect(100,25,50,50))
    /// v.add([subv1,subv2])
    /// ````
    /// - parameter subviews:	An array of UIView or View objects to be added to the receiver.
    public func add<T>(_ subviews: [T?]) {
        for subv in subviews {
            self.add(subv)
        }
    }

    /// Unlinks the view from the receiver and its window, and removes it from the responder chain.
    /// Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the
    /// subtree of the view you are removing.
    /// When working with C4, use this method to add views because it handles the removal of both UIView and View.
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv = View(frame: Rect(25,25,50,50))
    /// v.add(subv)
    /// v.remove(subv)
    /// ````
    /// - parameter subview:	The view to be removed.
    public func remove<T>(_ subview: T?) {
        if let v = subview as? UIView {
            v.removeFromSuperview()
        } else if let v = subview as? View {
            v.view.removeFromSuperview()
        } else {
            fatalError("Can't remove subview of class `\(type(of: subview))`")
        }
    }

    /// Unlinks the view from its superview and its window, and removes it from the responder chain.
    /// If the view’s superview is not nil, the superview releases the view.
    /// Calling this method removes any constraints that refer to the view you are removing, or that refer to any view in the
    /// subtree of the view you are removing.
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv = View(frame: Rect(25,25,50,50))
    /// v.add(subv)
    /// subv.removeFromSuperview()
    /// ````
    public func removeFromSuperview() {
        self.view.removeFromSuperview()
    }


    /// Moves the specified subview so that it appears behind its siblings.
    /// - parameter subview: The subview to move to the back.
    public func sendToBack<T>(_ subview: T?) {
        if let v = subview as? UIView {
            view.sendSubview(toBack: v)
        } else if let v = subview as? View {
            view.sendSubview(toBack: v.view)
        } else {
            fatalError("Can't operate on subview of class `\(type(of: subview))`")
        }
    }

    /// Moves the specified subview so that it appears on top of its siblings.
    /// - parameter subview: The subview to move to the front.
    public func bringToFront<T>(_ subview: T?) {
        if let v = subview as? UIView {
            view.bringSubview(toFront: v)
        } else if let v = subview as? View {
            view.bringSubview(toFront: v.view)
        } else {
            fatalError("Can't operate on subview of class `\(type(of: subview))`")
        }
    }

    //MARK: - HitTest

    /// Checks if a specified point falls within the bounds of the current object.
    /// - note:
    /// Because each view has its own coordinates, if you want to check if a point from anywhere on screen falls within a
    /// specific view you should use `hitTest(point, from: canvas)`.
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// v.hitTest(Point(50,50)) //-> true
    /// v.hitTest(Point(50, 101)) //-> false
    /// ````
    /// - parameter point: A `Point` to examine
    /// - returns: `true` if the point is within the object's frame, otherwise `false`.
    public func hitTest(_ point: Point) -> Bool {
        return CGRect(bounds).contains(CGPoint(point))
    }

    /// Checks if a specified point, from another view, falls within the frame of the receiver.
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// canvas.add(v)
    /// canvas.addTapGestureRecognizer() { location, state in
    ///     if v.hitTest(location, from: self.canvas) {
    ///         println("C4")
    ///     }
    /// }
    /// ````
    /// - parameter point: The point to check
    /// - parameter from: The view whose coordinate system the point is to be converted from
    /// - returns: `true` if the point is within the object's frame, otherwise `false`.
    public func hitTest(_ point: Point, from: View) -> Bool {
        let p = convert(point, from:from)
        return hitTest(p)
    }

    //MARK: – Convert

    /// Converts a specified point from a given view's coordinate system to that of the receiver.
    /// ````
    /// let p = Point()
    /// let cp = aView.convert(p, from:canvas)
    /// ````
    /// - parameter point: The point to convert
    /// - parameter from: The view whose coordinate system the point is to be converted from
    /// - returns: A `Point` whose values have been translated into the receiver's coordinate system.
    public func convert(_ point: Point, from: View) -> Point {
        return Point(view.convert(CGPoint(point), from: from.view))
    }

    //MARK: - Positioning

    /// Moves the receiver so that it appears on top of the specified view.
    /// - parameter view: The view above which the receive will be positioned
    public func positionAbove(_ view: View) {
        zPosition = view.zPosition + 1
    }

    /// Moves the receiver so that it appears on below of the specified view.
    /// - parameter view: The view below which the receive will be positioned
    public func positionBelow(_ view: View) {
        zPosition = view.zPosition - 1
    }
}
