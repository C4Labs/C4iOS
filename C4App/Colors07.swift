//
//  Colors07.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Colors07: CanvasController {
    
    var alpha1:Rectangle!
    var alpha2:Rectangle!
    var alpha3:Rectangle!
    var alpha4:Rectangle!
    
    override func setup() {
        
        setupShapes()
        
        let c = black
        
        
        
        //create transparent colors from the original color
        c.alpha = 0.8
        alpha1.fillColor = c
        c.alpha = 0.6
        alpha2.fillColor = c
        c.alpha = 0.4
        alpha3.fillColor = c
        c.alpha = 0.2
        alpha4.fillColor = c
    }
    
    func setupShapes() {
        let horizontalFrame = Rect(0, 0, 300, 100);
        let verticalFrame = Rect(0, 0, 100, 300);
        
        alpha1 = Rectangle(frame: horizontalFrame)
        alpha2 = Rectangle(frame: verticalFrame)
        alpha3 = Rectangle(frame: horizontalFrame)
        alpha4 = Rectangle(frame: verticalFrame)
        
        
        alpha1.lineWidth = 0.0
        alpha2.lineWidth = 0.0
        alpha3.lineWidth = 0.0
        alpha4.lineWidth = 0.0
        
        var p = self.canvas.center
        
        p.x -= 150
        p.y -= 150
        alpha1.origin = p
        alpha4.origin = p
        
        p.x += 200
        alpha2.origin = p
        
        p.x -= 200
        p.y += 200
        alpha3.origin = p
        
        self.canvas.add(alpha1)
        self.canvas.add(alpha2)
        self.canvas.add(alpha3)
        self.canvas.add(alpha4)
        
    }
}
