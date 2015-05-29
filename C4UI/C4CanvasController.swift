//
//  C4CanvasController.swift
//  C4iOS
//
//  Created by travis on 2015-05-29.
//  Copyright (c) 2015 C4. All rights reserved.
//

import Foundation
import UIKit
import C4Core

var disableActions = true

public class C4CanvasController: UIViewController {
    public override func viewDidLoad() {
        self.setup()
        disableActions = false
    }
    
    public func setup() {
        
    }
}