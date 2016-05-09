//
//  Shapes19.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//

import UIKit
import C4

class Shapes19: CanvasController {
    
    override func setup() {
    
        //create an x position, 1% of the width of the canvas
        let x1 = Double(self.canvas.width*0.01)
        
        //create a second x position, equally distant from the right edge of the canvas
        let x2 = Double(self.canvas.width-x1)
        
        //create and array of points to use for lines
        var linePoints = [Point(x1, 1),Point(x2, 1)]
        
        //create the first line, at the default width
        let line = Line(linePoints)
        self.canvas.add(line)
        //shift the line points
        linePoints[0].y *= 2
        linePoints[1].y *= 2
        
        //loop until the screen is full
        var step = 0.0
        repeat {
            let currentLineWidth = pow(1.15, step)
            //shift the line points based on the current line width (with a little gap)
            linePoints[0].y += currentLineWidth+1.0
            linePoints[1].y += currentLineWidth+1.0
            //create a new line and add it to the canvas
            let newLine = Line(linePoints)
            newLine.lineWidth = currentLineWidth
            self.canvas.add(newLine)
            step += 1.0
        } while linePoints[0].y < canvas.height

    
    }
    
}