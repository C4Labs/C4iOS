//
//  Shapes06.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-02.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Shapes06 : CanvasController {
    
    var defaultColorShape:Ellipse!
    var customColorShape:Ellipse!
    
    override func setup() {
        
        var p:Point = self.canvas.center
        
        //create and position the shape with default colors
        let r = Rect(0,0,200,200)
        defaultColorShape = Ellipse(frame: r)
        p.x = self.canvas.width / 3
        defaultColorShape.center = p
        
        //create and position the shape with custom colors
        customColorShape = Ellipse(frame: r)
        p.x = self.canvas.width * 2 / 3
        customColorShape.center = p
        
        //set the fill and stroke colors for the custom shape
        customColorShape.fillColor = Color.init(UIColor.grayColor())
        customColorShape.strokeColor = Color.init(UIColor.greenColor())
        
        //add the shapes to the canvas
        self.canvas.add(defaultColorShape)
        self.canvas.add(customColorShape)
        
        
    }
}