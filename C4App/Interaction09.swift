//
//  Interaction09.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-17.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Interaction09: CanvasController {
    
    var s:Circle!
    
    override func setup() {
        s = Circle(center: self.canvas.center, radius: 50)
        s.center.y = 50
        canvas.add(s)
        
        wait(1.5) {
            self.changeCenter()
        }
        wait(2.5) {
            self.changeCenter()
        }
        wait(3.5) {
            self.changeCenter()
        }
        wait(4.5) {
            self.changeCenter()
        }
        
    }
    
    func changeCenter() {
        self.s.center.y += 100
        self.s.fillColor = Color(red: random01(), green: random01(), blue: random01(), alpha: random01())
    }
}
