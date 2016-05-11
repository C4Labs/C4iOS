//
//  Shapes20.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//

import UIKit
import C4

class Shapes20: CanvasController {
    
    override func setup() {
        
        //create and array of points to use for lines
        var linePoints = [Point(),Point(self.canvas.width,0.0)]
        
        //figure out the total number of lines to draw
        let totalLineCount = self.canvas.height / 6.0 //default lineWidth (5.0f) + 1.0f gap between each line
        
        //figure out displacement of strokeStart and strokeEnd
        let strokeDisplacement = 0.5 / totalLineCount
        for i in 0..<Int(totalLineCount) {
            linePoints[0].y = Double(i)*6.0 + 2.5
            linePoints[1].y = linePoints[0].y
            
            //create a new line
            let newLine = Line(linePoints)
            
            //determine the current displacement of the ends of the line
            let currentDisplacement = strokeDisplacement*Double(i+1)
            newLine.strokeStart = 0.5 - currentDisplacement
            newLine.strokeEnd = 0.5 + currentDisplacement
            
            //... and add it to the canvas
            self.canvas.add(newLine)
        }

        
        
    }
}