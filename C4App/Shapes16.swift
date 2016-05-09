//
//  Shapes16.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//

import UIKit
import C4

class Shapes16: CanvasController {
    
    var circle:Circle!
    var patternWidth = Double()
    
    override func setup() {
        
        //create the circle and center it
        circle = Circle(center: self.canvas.center, radius: 150)
        
        
        //create a dash pattern
        //this pattern is [1,2,3,..,628];
        var dashPattern = [CGFloat]()
        for i in 0..<628 {
            dashPattern.append(CGFloat(i + 1))
            patternWidth += Double(i)
            
        }
        
        //thicken the line and set its dash pattern
        circle.lineWidth = 10.0
        circle.fillColor = Color(UIColor.clearColor())
        circle.lineDashPattern = dashPattern
        //add the line to the canvas
        self.canvas.add(circle)
        //animate it after a short wait
        let anim = ViewAnimation(duration:180.0) {    //duration = 3 minutes (60s * 3 = 180);
            
            self.circle.strokeColor = C4Blue
            //set the final dash phase to the entire width of the pattern
            self.circle.lineDashPhase = self.patternWidth
        }
        
        anim.autoreverses = true
        
        wait(0.1){
            anim.animate()
        }
    }
    
}