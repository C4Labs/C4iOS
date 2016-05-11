//
//  Random01.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-17.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Random01: CanvasController {
    
    var s1:Rectangle!
    
    var g:UIPanGestureRecognizer!
    
    override func setup() {
        s1 = Rectangle(frame: Rect(100, 100, 100, 175))
        canvas.add(s1)
        let a = ViewAnimation(duration:1.0) {
            self.s1.transform.rotate(M_PI * (random01()*4))

        }
        a.autoreverses = true
        g = s1.addPanGestureRecognizer({ (center,location, translation, velocity, state) -> () in
            var center = self.s1.center
            center.x +=  translation.x * Double(random(min: 1, max: 5))
            center.y += translation.y * Double(random(min: 1, max: 5))
            self.s1.center = center
            a.animate()
            self.g.setTranslation(CGPointZero, inView: self.canvas.view)
        })
    }
}
