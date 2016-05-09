//
//  Interaction.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-16.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Interaction02: CanvasController {
    
    var s1:Circle!
    var s2:Circle!
    var s3:Circle!
    
    override func setup() {
        s1 = Circle(center: self.canvas.center, radius: 50)
        s2 = Circle(center: self.canvas.center, radius: 50)
        s3 = Circle(center: self.canvas.center, radius: 50)
        
        s1.addLongPressGestureRecognizer { (center, location, state) -> () in
            if state == .Began {
                self.randomColor(self.s1)
            }
        }
        
        
        s2.addLongPressGestureRecognizer { (center, location, state) -> () in
            if state == .Began {
                self.randomColor(self.s2)
            }
        }
        
        s3.addLongPressGestureRecognizer { (center, location, state) -> () in
            if state == .Began {
                self.randomColor(self.s3)
            }
        }
        
        
        s1.center.y -= 150
        //leave s2 center as-is because it's already canvas.center
        s3.center.y += 150
        
        self.canvas.add(s1)
        self.canvas.add(s2)
        self.canvas.add(s3)
    }
    
    
    func randomColor(shape: Shape) {
        shape.fillColor = Color(red: random01(), green: random01(), blue: random01(), alpha: random01())
    }
}


