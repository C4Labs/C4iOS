//
//  Colors04.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Colors04: CanvasController {
    
    var red = Shape()
    var green = Shape()
    var blue = Shape()
    
    override func setup() {
        
        setupShapes()
        setupLabels()
        
        red.fillColor  = Color(UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0))
        green.fillColor  = Color(UIColor(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0))
        blue.fillColor  = Color(UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0))
        
    }
    
    func setupShapes() {
        let frame = Rect(0, 0, self.canvas.width*0.9, self.canvas.height/5.0)
        red =  Rectangle(frame: frame)
        green = Rectangle(frame: frame)
        blue = Rectangle(frame: frame)
        
        red.lineWidth = 0.0
        green.lineWidth = 0.0
        blue.lineWidth = 0.0
        
        red.center  = Point(self.canvas.center.x, self.canvas.height/4)
        green.center = Point(self.canvas.center.x, self.canvas.height*2/4)
        blue.center = Point(self.canvas.center.x, self.canvas.height*3/4)
        
        self.canvas.add(red)
        self.canvas.add(green)
        self.canvas.add(blue)
    }
    
    func setupLabels() {
        let f = Font(name: "ArialRoundedMTBold" , size: 30.0)!
        var l:TextShape!
        
        l = TextShape(text: "{RGBA} : {1.0,0,0,1.0}", font: f)
        l.fillColor = white
        l.center = red.center;
        self.canvas.add(l)
        
        l = TextShape(text: "{RGBA} : {0,1.0,0,1.0}", font: f)
        l.fillColor = white
        l.center = green.center;
        self.canvas.add(l)
        
        l = TextShape(text: "{RGBA} : {0,0,1.0,1.0}", font: f)
        l.fillColor = white
        l.center = blue.center;
        self.canvas.add(l)
        
        
    }
}
