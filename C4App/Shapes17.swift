//
//  Shapes17.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//

import UIKit
import C4

class Shapes17: CanvasController {
    
    var rect:Rectangle!
    var star:Star!
    var patternWidth = Double()
    
    override func setup() {
        //create the square and center it
        let f = Rect(0,0,250,250)
        rect = Rectangle(frame: f)
        rect.corner = Size(10,10)
        rect.center = self.canvas.center
        
        patternWidth = 4*rect.width;
        var dashPattern = [5,20]
        
        //thicken the line and set its dash pattern
        rect.lineWidth = 10.0
        rect.fillColor = Color(UIColor.clearColor())
        rect.lineCap = .Round
        rect.lineDashPattern = dashPattern
        //add the line to the canvas
        canvas.add(rect)
        
        //change the dash pattern
        dashPattern[0] = 1
        dashPattern[1] = 10
        
        //create a font for the text shape
        //    f = [Font fontWithName:@"ArialRoundedMTBold" size:320];
        
        //create the text shape and center it
        
        star = Star(
            center: canvas.center,
            pointCount: 5,
            innerRadius: 50,
            outerRadius: 100)
        
        
        //style the text shape and set its dash pattern
        star.fillColor = Color(UIColor.clearColor())
        star.lineWidth = 5.0
        star.lineCap = .Round
        star.lineDashPattern = dashPattern
        //add the text shape to the canvas
        canvas.add(star)
        
        //animate it after a short wait
        let anim = ViewAnimation(duration:10.0) {    //duration = 3 minutes (60s * 3 = 180);
            
            self.rect.strokeColor = C4Blue
            self.star.strokeColor = C4Grey
            
            //set the final dash phase to the entire width of the pattern
            self.rect.lineDashPhase = self.patternWidth
            self.star.lineDashPhase = self.patternWidth
            
        }
        
        anim.autoreverses = true
        anim.repeats = true
        
        wait(0.1){
            anim.animate()
        }
        
    }
}