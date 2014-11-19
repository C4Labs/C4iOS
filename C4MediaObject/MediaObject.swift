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