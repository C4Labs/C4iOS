//
//  Interaction07.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-17.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Interaction07: CanvasController {
    
    var s1:Circle!
    var a:UIPanGestureRecognizer!
    
    override func setup() {
        s1 = Circle(center: self.canvas.center, radius: 50)
        canvas.add(s1)
        a = s1.addPanGestureRecognizer({ (center, location, translation, velocity, state) -> () in
            var center = self.s1.center
            center.y += translation.y
            center.x += translation.x
            self.s1.center = center
            self.a.setTranslation(CGPointZero, inView: self.canvas.view)
        })
    }
}
