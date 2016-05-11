//
//  Shapes12.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-03.
//  Copyright © 2015 Slant. All rights reserved.
//

import UIKit
import C4

class Shapes12: CanvasController {
    
    var start:Ellipse!
    var end:Ellipse!
    var both:Ellipse!
    
    override func setup() {
        let shapeFrame = Rect(0, 0, self.canvas.height/6, self.canvas.height/6);
        
        //first shape will animate the start to the end
        start = Ellipse(frame: shapeFrame)
        start.lineWidth = 30.0
        start.fillColor = Color(UIColor.clearColor())
        start.center = Point(self.canvas.width/4, self.canvas.center.y);
        self.canvas.add(start)
        
        //second shape will animate the end to the start
        
        end = Ellipse(frame: shapeFrame)
        end.strokeColor = C4Blue
        end.lineWidth = 30.0
        end.fillColor = Color(UIColor.clearColor())
        end.center = self.canvas.center
        self.canvas.add(end)
        
        
        //third shape will animate the start and end to a mid-point
        both = Ellipse(frame: shapeFrame)
        both.lineWidth = 30.0
        both.strokeColor = C4Pink
        both.fillColor = Color(UIColor.clearColor())
        both.center = Point(self.canvas.width*3/4, self.canvas.center.y);
        self.canvas.add(both)
       
        let anim1 = ViewAnimation(duration:2.0) {
            self.start.strokeStart = 1
        }
        let anim2 = ViewAnimation(duration:2.0) {
            self.end.strokeEnd = 0
        }
        let anim3 = ViewAnimation(duration:2.0) {
            self.both.strokeStart = 0.5
            self.both.strokeEnd = 0.5
        }
        
        let grp = ViewAnimationGroup(animations: [anim1, anim2, anim3])

        anim1.repeats = true
        anim1.autoreverses = true
        anim2.repeats = true
        anim2.autoreverses = true
        anim3.repeats = true
        anim3.autoreverses = true


        
        wait(0.1){
            grp.animate()
        }
    }

}