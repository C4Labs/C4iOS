//
//  Shapes15.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-03.
//  Copyright © 2015 Slant. All rights reserved.
//

import UIKit
import C4

class Shapes15: CanvasController {

    var line:Line!
    var patternWidth = Double()
    
    override func setup() {

    //create the end points for a line
    let endPoints = [Point(), Point(self.canvas.width, 0)]
    
    //create the line and center it
    line = Line(endPoints)
    line.center.y = self.canvas.center.y
    
    //create a dash pattern
    //this pattern is [1,1,2,2,3,3,..,768,768];

        
        var dashPattern = [CGFloat]()
        for i in 0..<768 {
            dashPattern.append(CGFloat(i)+1.0)
            dashPattern.append(CGFloat(i)+1.0)
            patternWidth += Double(2*i)

        }
    
    //thicken the line and set its dash pattern
    line.lineWidth = 10.0
    line.lineDashPattern = dashPattern
    
    //add the line to the canvas
        self.canvas.add(line)
    //animate it after a short wait

        let anim = ViewAnimation(duration:300.0) {    //duration = 5 minutes (60s * 5 = 300);

            self.line.strokeColor = C4Blue
            //set the final dash phase to the entire width of the pattern
            self.line.lineDashPhase = self.patternWidth
        }
        
        anim.autoreverses = true
        
        wait(0.1){
            anim.animate()
        }
    }
    


}