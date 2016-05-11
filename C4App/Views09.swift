//
//  Views09.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Views09: CanvasController {
    
    var circle:Circle!
    
    
    override func setup() {
        
        circle = Circle(center: self.canvas.center, radius: 44)
        circle.lineWidth = 40
        self.canvas.add(circle)
        
        canvas.addTapGestureRecognizer { (center, location, state) -> () in
            self.circle.view.clipsToBounds = !self.circle.view.clipsToBounds
        }
    }
}

