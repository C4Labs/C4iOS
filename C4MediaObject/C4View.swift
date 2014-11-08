//
//  C4View.swift
//  C4iOS
//
//  Created by travis on 2014-11-06.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation
import C4Core
import C4iOS
//import C4Animatable
//import C4MediaObject

public struct Border {
    public init() {
        self.layer = CALayer()
    }
    
    public init(_ layer: CALayer) {
        self.init()
        self.layer = layer
    }
    
    public var layer: CALayer {
        didSet {
            update()
        }
    }
    
    public var color: C4Color = C4Color(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            layer.borderColor = color.CGColor
        }
    }
    
    public var radius: Double = 0 {
        didSet {
            layer.cornerRadius = CGFloat(radius)
        }
    }
    
    public var width: Double = 0 {
        didSet {
            layer.borderWidth = CGFloat(width)
        }
    }

    internal func update() {
        layer.borderColor = color.CGColor
        layer.cornerRadius = CGFloat(radius)
        layer.borderWidth = CGFloat(width)
    }
}

public struct Shadow {
    public init() {
        self.layer = CALayer()
    }
    
    public init(_ layer: CALayer) {
        self.init()
        self.layer = layer
    }

    public var layer: CALayer {
        didSet {
            update()
        }
    }
 
    public var radius: Double = 0 {
        didSet {
           layer.shadowRadius = CGFloat(radius)
        }
    }
    public var color: C4Color = C4Color(red: 0, green: 0, blue: 0, alpha: 0) {
        didSet {
            layer.shadowColor = color.CGColor
        }
    }
    public var offset: C4Size = C4Size() {
        didSet {
            layer.shadowOffset = CGSize(offset)
        }
    }
    public var opacity: Double = 0 {
        didSet {
            layer.shadowOpacity = Float(opacity)
        }
    }
    public var shadowPath: C4Path = C4Path() {
        didSet {
            layer.shadowPath = shadowPath.CGPath
        }
    }

    internal func update() {
        layer.shadowRadius = CGFloat(radius)
        layer.shadowColor = color.CGColor
        layer.shadowOffset = CGSize(offset)
        layer.shadowOpacity = Float(opacity)
    }
}

public struct Rotation {
    public init() {
        self.layer = CALayer()
    }
    
    public init(_ layer: CALayer) {
        self.init()
        self.layer = layer
    }

    public var layer: CALayer {
        didSet {
            update()
        }
    }
    
    public var x: Double = 0 {
        didSet {
            //trigger x rotation for layer
        }
    }

    public var y: Double = 0 {
        didSet {
            //trigger y rotation for layer
        }
    }
    
    public var z: Double = 0 {
        didSet {
            //trigger z rotation for layer
        }
    }

    internal func update() {
        //trigger x rotation for layer
        //trigger y rotation for layer
        //trigger z rotation for layer
    }
}

public class C4View : UIViewController, Visible, EventSource {
    convenience public init(frame: C4Rect) {
        self.init()
        self.view.frame = CGRect(frame)
    }
    
    public override init() {
        super.init()
    }
    

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    //MARK: - Events
    func post(event: String) {
        NSNotificationCenter.defaultCenter().postNotificationName(event, object: self)
    }
    
    func on(event notificationName: String, run executionBlock: Void -> Void) -> AnyObject {
        return self.on(event: notificationName, from: nil, run: executionBlock)
    }

    func on(event notificationName: String, from objectToObserve: AnyObject?, run executionBlock: Void -> Void) -> AnyObject {
        let nc = NSNotificationCenter.defaultCenter()
        return nc.addObserverForName(notificationName, object: objectToObserve, queue: NSOperationQueue.currentQueue(), usingBlock: { (n: NSNotification!) in
            executionBlock()
        });
    }

    func cancel(observer: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer, name: nil, object: nil)
    }
    
    func cancel(event: String, observer: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer, name: event, object: nil)
    }
    
    func cancel(event: String, observer: AnyObject, object: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer, name: event, object: object)
    }

    func watch(property: String, of object: NSObject) {
        //would be great to simplify Key Value Observing
    }

}