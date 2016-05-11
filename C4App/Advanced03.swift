//
//  Advanced03.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-14.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Advanced03: CanvasController {
    
    var shapes = [Shape]()
    
    override func setup() {
        
        for i in 0..<100 {
            let s = Rectangle(frame: Rect(0,0,self.canvas.height,20))
            s.fillColor = Color(UIColor(white: 0.0, alpha:CGFloat(Double(i)/40.0)))
            s.strokeColor = Color(UIColor.clearColor())
            s.anchorPoint = Point(0.5,8.0+Double(i))
            var p = self.canvas.center
            p.y += self.canvas.height/2
            s.center = p
            shapes.append(s)
            canvas.add(s)
        }
        wait(0.1) {
            self.setupAnimations()
        }
    }
    
    func setupAnimations() {
        for i in 0..<shapes.count {
            
            let s = shapes[i]
            let a = ViewAnimation(duration: Double(i)*0.01 + 1) {
                s.transform.rotate(M_PI_2)
            }
            a.repeats = true
            a.animate()
            
        }
    }
}

