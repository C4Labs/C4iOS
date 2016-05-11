//
//  Shapes13.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-03.
//  Copyright © 2015 Slant. All rights reserved.
//


import UIKit
import C4

class Shapes13: CanvasController {
    
    var line1:Line!
    var line2:Line!
    
    override func setup() {
        //create end points for the first line
        var endPoints = [Point(0, self.canvas.height/3),Point(self.canvas.width, self.canvas.height/3)]
        
        //create the first line
        line1 = Line(endPoints)
        
        //shift the end points for the second line
        endPoints[0].y *= 2;
        endPoints[1].y *= 2;
        
        //create the second line
        line2 = Line(endPoints)
        
        //create a c-array dash pattern and set this for line1
        line1.lineDashPattern = [5,10]
        //create an NSArray of numbers and set this as the dash pattern for line2
        let patternArray = [15, 30];
        line2.lineDashPattern = patternArray;
        
        //thicken the lines
        line1.lineWidth = 5
        line2.lineWidth = 5
        
        //add the lines to the canvas
        self.canvas.add(line1)
        self.canvas.add(line2)
    }
}