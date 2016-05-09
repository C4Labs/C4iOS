//
//  Views01.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views01: CanvasController {
    
    var s1:Rectangle!
    var s2:Rectangle!
    var s3:Rectangle!
    
    override func setup() {
        
        setupShapes()
        
        s1.opacity = 1.0
        s2.opacity = 0.6
        s3.opacity = 0.3
    }
    
    func setupShapes() {
        let rect = Rect(0, 0, 150, 150)
        
        s1 = Rectangle(frame: rect)
        s2 = Rectangle(frame: rect)
        s3 = Rectangle(frame: rect)
        
        var currentCenter = self.canvas.center
        
        currentCenter.y -= 200
        s1.center = currentCenter;
        self.canvas.add(s1)
        currentCenter.y += 200;
        s2.center = currentCenter;
        self.canvas.add(s2)
        currentCenter.y += 200;
        s3.center = currentCenter;
        self.canvas.add(s3)
    }
    
}
