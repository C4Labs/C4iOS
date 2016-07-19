// Copyright © 2014 
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
#elseif os(OSX)
import AppKit
#endif

extension NSValue {
    ///  Initializes an NSValue with a Point
    ///
    ///  - parameter point: a Point
    convenience init(Point point: Point) {
        #if os(iOS)
            self.init(CGPoint: CGPoint(point))
        #elseif os(OSX)
            self.init(point: NSPoint(point))
        #endif
    }
}

/// The View class defines a rectangular area on the screen and the interfaces for managing visual content in that area. The View class itself provides basic behavior for filling its rectangular area with a background color. More sophisticated content can be presented by subclassing NativeView and implementing the necessary drawing and event-handling code yourself. The  framework also includes a set of standard subclasses that range from simple shapes to movies and images that can be used as-is.
public class View : NSObject {
    /// A NativeView. Internally, View wraps and provides access to an internal NativeView.
    public var view : NativeView

    ///  Initializes a View.
    public override init() {
        view = LayerView(frame: CGRectMake(0, 0, 200, 200))
        #if os(OSX)
            view.layerContentsRedrawPolicy = .OnSetNeedsDisplay
        #endif
    }
    
    /// Initializes a new View from a NativeView.
    ///
    /// - parameter view: A NativeView.
    public init(view: NativeView) {
        self.view = view;
    }
    
    /// Initializes a new View with the specifed frame.
    ///
    /// ````
    /// let f = Rect(0,0,100,100)
    /// let v = View(frame: f)
    /// canvas.add(v)
    /// ````
    ///
    /// - parameter frame: A Rect, which describes the view’s location and size in its superview’s coordinate system.
    convenience public init(frame: Rect) {
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
            return frame.origin
        }
        set {
            frame = Rect(newValue, self.size)
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
    public var backgroundColor: Color? {
        get {
            if let layerView = view as? LayerView, let color = layerView.backgroundColor {
                return Color(color)
            } else {
                return nil
            }
        }
        set {
            if let layerView = view as? LayerView {
                if let color = newValue {
                    layerView.backgroundColor = NativeColor(color)
                } else {
                    layerView.backgroundColor = nil
                }
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
    public var transform: Transform {
        get {
            if let layer = view.mainLayer {
                return Transform(layer.transform)
            } else {
                return Transform()
            }
        }
        set {
            view.mainLayer?.transform = newValue.transform3D
        }
    }
    
    /// Defines the anchor point of the layer's bounds rect, as a point in
    /// normalized layer coordinates - '(0, 0)' is the bottom left corner of
    /// the bounds rect, '(1, 1)' is the top right corner. Defaults to
    /// '(0.5, 0.5)', i.e. the center of the bounds rect. Animatable.
    public var anchorPoint: Point {
        get {
            if let layer = view.mainLayer {
                return Point(layer.anchorPoint)
            } else {
                return Point(0.5, 0.5)
            }
        }
        set {
            if let layer = view.mainLayer {
                let oldFrame = view.frame
                layer.anchorPoint = CGPoint(newValue)
                view.frame = oldFrame
            }
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

    #if os(iOS)
    /// Returns true if the receiver accepts touch events.
    public var interactionEnabled: Bool = true {
        didSet {
            self.view.userInteractionEnabled = interactionEnabled
        }
    }
    #endif

    //MARK: - AddRemoveSubview
    
    /// Adds a view to the end of the receiver’s list of subviews.
    ///
    /// When working with , use this method to add views because it handles the addition of both NativeView and View.
    ///
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv = View(frame: Rect(25,25,50,50))
    /// v.add(subv)
    /// ````
    /// - parameter view:	The view to be added.
    public func add<T>(subview: T?) {
        if let v = subview as? NativeView {
            view.addSubview(v)
        } else if let v = subview as? View {
            view.addSubview(v.view)
        } else {
            fatalError("Can't add subview of class `\(subview.dynamicType)`")
        }
    }
    
    //MARK: - AddRemoveSubview
    
    /// Adds an array of views to the end of the receiver’s list of subviews.
    ///
    /// When working with , use this method to add views because it handles the addition of both NativeView and View.
    ///
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv1 = View(frame:Rect(25,25,50,50))
    /// let subv2 = View(frame: Rect(100,25,50,50))
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
    /// When working with , use this method to add views because it handles the removal of both NativeView and View.
    ///
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv = View(frame: Rect(25,25,50,50))
    /// v.add(subv)
    /// v.remove(subv)
    /// ````
    ///
    /// - parameter view:	The view to be removed.
    public func remove<T>(subview: T?) {
        if let v = subview as? NativeView {
            v.removeFromSuperview()
        } else if let v = subview as? View {
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
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv = View(frame: Rect(25,25,50,50))
    /// v.add(subv)
    /// subv.removeFromSuperview()
    /// ````
    public func removeFromSuperview() {
        self.view.removeFromSuperview()
    }

    #if os(iOS)
    /// Moves the specified subview so that it appears behind its siblings.
    ///
    /// - parameter view: The subview to move to the back.
    public func sendToBack<T>(subview: T?) {
        if let v = subview as? NativeView {
            view.sendSubviewToBack(v)
        } else if let v = subview as? View {
            view.sendSubviewToBack(v.view)
        } else {
            fatalError("Can't operate on subview of class `\(subview.dynamicType)`")
        }
    }
    #endif

    #if os(iOS)
    /// Moves the specified subview so that it appears on top of its siblings.
    ///
    /// - parameter view: The subview to move to the front.
    public func bringToFront<T>(subview: T?) {
        if let v = subview as? NativeView {
            view.bringSubviewToFront(v)
        } else if let v = subview as? View {
            view.bringSubviewToFront(v.view)
        } else {
            fatalError("Can't operate on subview of class `\(subview.dynamicType)`")
        }
    }
    #endif
    
    //MARK: - HitTest
    
    /// Checks if a specified point falls within the bounds of the current object.
    ///
    /// - note:
    /// Because each view has its own coordinates, if you want to check if a point from anywhere on screen falls within a
    /// specific view you should use `hitTest(point, from: canvas)`.
    ///
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// v.hitTest(Point(50,50)) //-> true
    /// v.hitTest(Point(50, 101)) //-> false
    /// ````
    ///
    /// - parameter point: A `Point` to examine
    ///
    /// - returns: `true` if the point is within the object's frame, otherwise `false`.
    public func hitTest(point: Point) -> Bool {
        return CGRectContainsPoint(CGRect(bounds), CGPoint(point))
    }
    
    /// Checks if a specified point, from another view, falls within the frame of the receiver.
    ///
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// canvas.add(v)
    ///
    /// canvas.addTapGestureRecognizer() { location, state in
    ///     if v.hitTest(location, from: self.canvas) {
    ///         println("")
    ///     }
    /// }
    /// ````
    ///
    /// - returns: `true` if the point is within the object's frame, otherwise `false`.
    public func hitTest(point: Point, from: View) -> Bool {
        let p = convert(point, from:from)
        return hitTest(p)
    }
    
    //MARK: – Convert
    
    /// Converts a specified point from a given view's coordinate system to that of the receiver.
    ///
    /// ````
    /// let p = Point()
    /// let cp = aView.convert(p, from:canvas)
    /// ````
    ///
    /// - returns: A `Point` whose values have been translated into the receiver's coordinate system.
    public func convert(point: Point, from: View) -> Point {
        return Point(view.convertPoint(CGPoint(point), fromView: from.view))
    }
    
}


/// Extension to NativeView that adds handling addition and removal of View objects.
extension NativeView {
    
    /// Adds a view to the end of the receiver’s list of subviews.
    ///
    /// When working with , use this method to add views because it handles the addition of both NativeView and View.
    ///
    /// - parameter view:	The view to be added.
    public func add<T>(subview: T?) {
        if let v = subview as? NativeView {
            self.addSubview(v)
        } else if let v = subview as? View {
            self.addSubview(v.view)
        } else {
            fatalError("Can't add subview of class `\(subview.dynamicType)`")
        }
    }
    
    //MARK: - AddRemoveSubview
    
    /// Adds an array of views to the end of the receiver’s list of subviews.
    ///
    /// When working with , use this method to add views because it handles the addition of both NativeView and View.
    ///
    /// ````
    /// let v = View(frame: Rect(0,0,100,100))
    /// let subv1 = View(frame: Rect(25,25,50,50))
    /// let subv2 = View(frame: Rect(100,25,50,50))
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
    /// When working with , use this method to remove views because it handles the removal of both NativeView and View.
    ///
    /// - parameter view:	The view to be removed.
    public func remove<T>(subview: T?) {
        if let v = subview as? NativeView {
            v.removeFromSuperview()
        } else if let v = subview as? View {
            v.view.removeFromSuperview()
        } else {
            fatalError("Can't remove subview of class `\(subview.dynamicType)`")
        }
    }

    #if os(iOS)
    /// Moves the specified subview so that it appears behind its siblings.
    ///
    /// When working with , use this method because it handles both NativeView and View.
    ///
    /// - parameter view: The subview to move to the back.
    public func sendToBack<T>(subview: T?) {
        if let v = subview as? NativeView {
            self.sendSubviewToBack(v)
        } else if let v = subview as? View {
            self.sendSubviewToBack(v.view)
        } else {
            fatalError("Can't operate on subview of class `\(subview.dynamicType)`")
        }
    }
    #endif

    #if os(iOS)
    /// Moves the specified subview so that it appears on top of its siblings.
    ///
    /// When working with , use this method because it handles both NativeView and View.
    ///
    /// - parameter view: The subview to move to the front.
    public func bringToFront<T>(subview: T?) {
        if let v = subview as? NativeView {
            self.bringSubviewToFront(v)
        } else if let v = subview as? View {
            self.bringSubviewToFront(v.view)
        } else {
            fatalError("Can't operate on subview of class `\(subview.dynamicType)`")
        }
    }
    #endif
}
