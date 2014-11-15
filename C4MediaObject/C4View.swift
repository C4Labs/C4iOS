//
//  C4View.swift
//  C4iOS
//
//  Created by travis on 2014-11-06.
//  Copyright (c) 2014 C4. All rights reserved.
//

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
            let dx = self.width / 2.0
            let dy = self.height / 2.0
            self.center = C4Point(val.x + dx, val.y + dy)
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
            self.border.layer = self.view.layer
        }
    }
    
    public var shadow: Shadow = Shadow() {
        didSet {
            self.shadow.layer = self.view.layer
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
        //would be great to simplify Key Value Observing
    }

    //MARK: - Touchable
    public var interactionEnabled: Bool = true {
        didSet {
            self.view.userInteractionEnabled = interactionEnabled
        }
    }
    
    //MARK: Tap
    lazy public var tap : Tap = Tap(UITapGestureRecognizer())
    internal var tapAction : TapAction?
    internal var tapRecognizer: UITapGestureRecognizer?
    public func onTap(run: TapAction) {
        tapAction = run

        if tapRecognizer == nil {
            tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
            view.addGestureRecognizer(tapRecognizer!)
            tap = Tap(tapRecognizer!)
        }
    }
    internal func handleTap(sender: UITapGestureRecognizer) {
        if let action = tapAction? {
            let l = C4Point(sender.locationInView(self.view))
            action(location: l)
        }
    }
    
    //MARK: Pan
    lazy public var pan : Pan = Pan(UIPanGestureRecognizer())
    
    internal var panAction : PanAction?
    internal var panRecognizer : UIPanGestureRecognizer?
    public func onPan(run: PanAction) {
        panAction = run
        if panRecognizer == nil {
            panRecognizer = UIPanGestureRecognizer(target:self, action:"handlePan:")
            view.addGestureRecognizer(panRecognizer!)
            pan = Pan(panRecognizer!)
        }
    }
    internal func handlePan(sender: UIPanGestureRecognizer) {
        if let action = panAction? {
            let l = C4Point(sender.locationInView(self.view))
            let t = C4Point(sender.translationInView(self.view))
            let v = C4Point(sender.velocityInView(self.view))
            action(location: l, translation: t, velocity: v)
        }
    }
    
    internal var pinchAction: PinchAction?
    internal var pinchRecognizer: UIPinchGestureRecognizer?
    public func onPinch(run: PinchAction) {
        pinchAction = run
        if pinchRecognizer == nil {
            pinchRecognizer = UIPinchGestureRecognizer(target:self, action:"handlePinch:")
            view.addGestureRecognizer(pinchRecognizer!)
        }
    }
    internal func handlePinch(sender: UIPinchGestureRecognizer) {
        if let action = pinchAction? {
            let l = C4Point(sender.locationInView(self.view))
            let s = Double(sender.scale)
            let v = Double(sender.velocity)
            action(location: l, scale: s, velocity: v)
        }
    }
    
    internal var rotationAction: RotationAction?
    internal var rotationGesture: UIRotationGestureRecognizer?
    public func onRotate(run: RotationAction) {
        rotationAction = run
        if rotationGesture == nil {
            rotationGesture = UIRotationGestureRecognizer(target:self, action:"handleRotation:")
            view.addGestureRecognizer(rotationGesture!)
        }
    }
    
    internal func handleRotation(sender: UIRotationGestureRecognizer) {
        if let action = rotationAction {
            let l = C4Point(sender.locationInView(self.view))
            let r = Double(sender.rotation)
            let v = Double(sender.velocity)
            action(location: l, rotation: r, velocity: v)
        }
    }
    
    lazy public var longPress = LongPress(UILongPressGestureRecognizer())
    internal var longPressAction: LongPressAction?
    internal var longPressGesture: UILongPressGestureRecognizer?
    public func onLongPress(run: LongPressAction) {
        longPressAction = run
        if longPressGesture == nil {
            longPressGesture = UILongPressGestureRecognizer(target:self, action:"handleLongPress:")
            view.addGestureRecognizer(longPressGesture!)
            longPress = LongPress(longPressGesture!)
        }
    }
    
    internal func handleLongPress(sender: UILongPressGestureRecognizer) {
        if let action = longPressAction {
            let l = C4Point(sender.locationInView(self.view))
            action(location: l)
        }
    }
    
    lazy public var swipe = Swipe(UISwipeGestureRecognizer())
    internal var swipeAction: SwipeAction?
    internal var swipeGesture: UISwipeGestureRecognizer?
    public func onSwipe(run: SwipeAction) {
        swipeAction = run
        if swipeGesture == nil {
            swipeGesture = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
            view.addGestureRecognizer(swipeGesture!)
            swipe = Swipe(swipeGesture!)
        }
    }
    
    internal func handleSwipe(sender: UISwipeGestureRecognizer) {
        if let action = swipeAction {
            let l = C4Point(sender.locationInView(self.view))
            let d = SwipeDirection(sender.direction)
            action(location: l, direction: d)
        }
    }
    
    lazy public var edgePan = EdgePan(UIScreenEdgePanGestureRecognizer())
    internal var edgePanAction: EdgePanAction?
    internal var edgePanGesture: UIScreenEdgePanGestureRecognizer?
    public func onEdgePan(run: EdgePanAction) {
        edgePanAction = run
        if edgePanGesture == nil {
            edgePanGesture = UIScreenEdgePanGestureRecognizer(target: self, action:"handleEdgePan:")
            view.addGestureRecognizer(edgePanGesture!)
            edgePan = EdgePan(edgePanGesture!)
        }
    }

    internal func handleEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        if let action = edgePanAction {
            let l = C4Point(sender.locationInView(self.view))
            action(location: l)
        }
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
    public var mask: Mask {
        get { return self.view.layer.mask }
        set(val) { }
    }
    
    //MARK: - AddRemoveSubview
    public func add<T: AddRemoveSubview>(subview: T) {
        if subview is UIView {
            if let v = subview as? UIView {
                view.addSubview(v)
            }
        } else {
            if let v = subview as? C4View {
                view.addSubview(v.view)
            }
        }
    }
    public func remove<T: AddRemoveSubview>(subview: T) {
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
    public func removeFromSuperview() {
        self.view.removeFromSuperview()
    }
}

extension UIView : AddRemoveSubview {
    public func add<T: AddRemoveSubview>(subview: T) {
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
    public func remove<T: AddRemoveSubview>(subview: T) {
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