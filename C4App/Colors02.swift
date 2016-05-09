//
//  Colors02.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Colors02: CanvasController {
    
    var pink:Rectangle!
    var blue:Rectangle!
    var grey:Rectangle!
    
    override func setup() {
        
        setupShapes()
        setupLabels()
        
        pink.fillColor  = C4Pink
        blue.fillColor = C4Blue
        grey.fillColor = C4Grey
        grey.strokeColor = lightGray//makes the grey box visible
        
    }
    
    func setupShapes() {
        
        let frame = Rect(0, 0, self.canvas.width*0.9, self.canvas.height/5.0)
        pink =  Rectangle(frame: frame)
        blue =  Rectangle(frame: frame)
        grey =  Rectangle(frame: frame)
        
        pink.lineWidth = 0.0
        blue.lineWidth = 0.0
        grey.lineWidth = 0.5//allows us to see the border of grey
        
        pink.center  = Point(self.canvas.center.x, self.canvas.height/4)
        blue.center = Point(self.canvas.center.x, self.canvas.height*2/4)
        grey.center = Point(self.canvas.center.x, self.canvas.height*3/4)
        
        self.canvas.add(pink)
        self.canvas.add(blue)
        self.canvas.add(grey)
    }
    
    func setupLabels() {
        let f = Font(name: "ArialRoundedMTBold", size: 30.0)!
        var l:TextShape!
        
        l = TextShape(text: "C4Pink", font: f)
        l.fillColor = white
        l.center = pink.center;
        self.canvas.add(l)
        
        l = TextShape(text: "C4Blue", font: f)
        l.fillColor = white
        l.center = blue.center;
        self.canvas.add(l)
        
        l = TextShape(text: "C4Grey", font: f)
        l.fillColor = lightGray
        l.center = grey.center;
        self.canvas.add(l)
    }
}

