//
//  Rotation.swift
//  C4iOS
//
//  Created by travis on 2014-11-08.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation

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