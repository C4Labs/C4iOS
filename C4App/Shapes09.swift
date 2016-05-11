//
//  Shapes09.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-02.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
class Shapes09: CanvasController {

    
    override func setup() {
        
        //create a set of default points for all the lines
        let linePoints = [
            Point(canvas.center.x-100, canvas.center.y), Point(canvas.center.x+100, canvas.center.y),
        Point(canvas.center.x+100, canvas.center.y)
    ]
    
        
        
        //create each line and style it, if necessary
        let line1 = Line(linePoints)
        
        let line2 = Line(linePoints)
//        line2.strokeColor = C4Blue
        
        let line3 = Line(linePoints)
//        line3.strokeColor = C4Pink
        
        //add all the lines to the canvas
        self.canvas.add(line1)
        self.canvas.add(line2)
        self.canvas.add(line3)
        
        //animate them after a short wait
        
        let anim = ViewAnimation(duration:1.0) {
            line1.endPoints.1 = Point(line1.endPoints.0.x, line1.endPoints.0.y-100)

            line2.endPoints.0 = Point(line2.endPoints.1.x, line2.endPoints.1.y+100)

        }
        
        anim.repeats = true
        anim.autoreverses = true
        
        wait(1.0){
            anim.animate()
        }
    }
    
}