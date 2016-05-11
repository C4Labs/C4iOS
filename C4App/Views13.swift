//
//  Views13.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views13: CanvasController {
    
    var s1 :Rectangle!
    var s2 :Rectangle!
    var s3 :Rectangle!
    var s4 :Rectangle!
    
    override func setup() {
  
    setupShapes()
    }
    
    func s1remove() {
    //Here's the bit that removes the shape from the canvas
    s1.removeFromSuperview()
        wait(1.0) {
            self.s1add()
        }
    }
    
    func s1add() {
    self.canvas.add(s1)
    }
    
    func s2remove() {
    s2.removeFromSuperview()
        wait(1.0) {
            self.s2add()
        }
    }
    
    func s2add() {
    self.canvas.add(s2)
    }
    
    func s3remove() {
    s3.removeFromSuperview()
        wait(1.0) {
            self.s3add()
        }
    }
    
    func s3add() {
    self.canvas.add(s3)
    }
    func s4remove() {
    s4.removeFromSuperview()
        wait(1.0) {
            self.s4add()
        }    }
    
    func s4add() {
    self.canvas.add(s4)
    }
    
    func setupShapes() {
    let rect = Rect(0, 0, 100, 100)
        
        s1 = Rectangle(frame: rect)
        s2 = Rectangle(frame: rect)
        s3 = Rectangle(frame: rect)
        s4 = Rectangle(frame: rect)
        
        
    var centerPoint = self.canvas.center
    
    centerPoint.x -= 75
    centerPoint.y -= 75
    s1.center = centerPoint
    
    centerPoint.x += 150
    s2.center = centerPoint
    
    centerPoint.y += 150
    s3.center = centerPoint
    
    centerPoint.x -= 150
    s4.center = centerPoint
    
    
    self.canvas.add(s1)
            self.canvas.add(s2)
            self.canvas.add(s3)
            self.canvas.add(s4)
        s1.addTapGestureRecognizer { (center, location, state) -> () in
            self.s1remove()
        }
        s2.addTapGestureRecognizer { (center,location, state) -> () in
            self.s2remove()
        }
        s3.addTapGestureRecognizer { (center,location, state) -> () in
            self.s3remove()
        }
        s4.addTapGestureRecognizer { (center,location, state) -> () in
            self.s4remove()
        }
    }
}
