//
//  Shapes08.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-02.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Shapes08: CanvasController {
    
    var circle:Circle!
    
    override func setup() {
        
        
        //create and position the shape with default colors
        circle = Circle(center: self.canvas.center, radius: 50)
        
        //change the line width
        circle.lineWidth = 10
        
        //add the shapes to the canvas
        self.canvas.add(circle)
    }
}

