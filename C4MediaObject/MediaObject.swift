//
//  MediaObject.swift
//  C4iOS
//
//  Created by travis on 2014-11-06.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation
import QuartzCore

public protocol MediaObject: Animatable, EventSource, NSObjectProtocol {
    
}


public protocol Animatable {}

public protocol Styleable {
    class var defaultStyle: Style { get set }
    var style: Style { get set }
}

public struct Border {
    public var color: C4Color
    public var radius: Double
    public var width: Double
    public init() {
        self.color = C4Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)

        self.radius = 0
        self.width = 0
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
    
    public var radius: Double = 5 {
        didSet {
            layer.shadowRadius = CGFloat(radius)
        }
    }
    public var color: C4Color = C4Color(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            layer.shadowColor = color.CGColor
        }
    }
    public var offset: C4Size = C4Size(5,5) {
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