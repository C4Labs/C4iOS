//
//  Shapes 05.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-02.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Shapes05 : CanvasController {
    
    override func setup() {
        
        //create a font (120 is big enough for an iPad, make it smaller for iPod/iPhone)
        let f = Font(name: "Helvetica", size: 120)!
        
        
        //create a shape using a string and font
        let textShape = TextShape(text:"C4", font: f)!
        textShape.center = self.canvas.center
        
        //add the shape to the canvas
        canvas.add(textShape)
        
    }
}