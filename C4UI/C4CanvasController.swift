//
//  C4CanvasController.swift
//  C4iOS
//
//  Created by travis on 2015-06-17.
//  Copyright (c) 2015 C4. All rights reserved.
//

import Foundation
import C4Core

public class C4CanvasController : UIViewController {
    public override func viewDidLoad() {
        C4ShapeLayer.disableActions = true
        self.setup()
        C4ShapeLayer.disableActions = false
    }

    public func setup() {
        //work your magic here
    }
}