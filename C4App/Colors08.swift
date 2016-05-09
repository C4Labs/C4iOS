//
//  Colors08.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Colors08: CanvasController {
    override func setup() {
        
        //create the pattern images
        //you can get the patterns for this example here: http://www.cocoaforartists.org/files/patterns.zip
        let patternLines = Image("pattern1")!
        let patternPyramid = Image("pattern2")!
        
        //create the shapes
        let f = Rect(0,0,200,200)
        let s1 = Rectangle(frame: f)
        let s2 = Ellipse(frame: f)
        
        //set their line widths to be quite thick
        s1.lineWidth = 50.0
        s2.lineWidth = s1.lineWidth
        
        //set their fill colors with pattern images
        s1.fillColor = Color(UIColor(patternImage: patternPyramid.uiimage))
        s2.fillColor = Color(UIColor(patternImage: patternLines.uiimage))
        
        //set their stroke colors with pattern images
        s1.strokeColor = Color(UIColor(patternImage: patternPyramid.uiimage))
        s2.strokeColor = Color(UIColor(patternImage: patternLines.uiimage))
        
        //position them
        s1.center = Point(self.canvas.center.x, self.canvas.height / 3)
        s2.center = Point(self.canvas.center.x, self.canvas.height * 2 / 3)
        
        //add them to the canvas
        self.canvas.add(s1)
        self.canvas.add(s2)
    }
}

