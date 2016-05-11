//
//  Random02.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-18.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Random02: CanvasController {
    
    var s1:Rectangle!
    
    override func setup() {
        let frame = Rect(0,0,100,150)
        s1 = Rectangle(frame: frame)
        s1.center = self.canvas.center
        canvas.add(s1)
        s1.addTapGestureRecognizer { (center, location, state) -> () in
            self.s1.hidden = true
            let randomInt = random(min: 1, max: 10)
            for i in 1...randomInt {
                let pts = [self.s1.center,Point(self.s1.center.x+35+Double(i), self.s1.center.y),Point(self.s1.center.x+17, self.s1.center.y+35+Double(i))]
                let shape = Triangle(pts)
                let a = ViewAnimation(duration:1.0) {
                    let v = Vector(x: random(min: 1, max: 200), y: random(min: 1, max: 200))
                    let t = Transform.makeTranslation(v)

                    shape.transform = t
                }
                self.canvas.add(shape)
                a.autoreverses = true
                a.repeats = true
                a.animate()
            }
        }
        
    }
}