//
//  Views20.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-10.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views20: CanvasController {
    
    var img:Image!
    var s1:Rectangle!
    var s2:Rectangle!
    
    override func setup() {
        setupShapes()
        
        img.layer?.mask = s1.layer
        s1.add(s2)
        self.canvas.add(img)
    }
    
    func setupShapes() {
        img = Image("chop")
        s1 = Rectangle(frame: Rect(0,0,600,50))
        s2 = Rectangle(frame: Rect(0, 0, 50, 600))
        
        img.center = self.canvas.center
        s1.center = Point(img.width/2 ,img.height/2)
        s2.center = Point(s1.width/2 ,s1.height/2)
        
        let a1 = ViewAnimation(duration: 1.7) {
            self.s1.transform.rotate(-M_PI)
        }
        let a2 = ViewAnimation(duration: 2.3) {
            self.s2.transform.rotate(M_PI_2)
        }
        a1.repeats = true
        a2.repeats = true
        a2.autoreverses = true
//        a1.curve = .Linear
        wait(0.1) {
            a1.animate()
            a2.animate()
        }
    }
}
