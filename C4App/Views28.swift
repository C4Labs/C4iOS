//
//  Views28.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-10.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views28: CanvasController {
    
    var s1:Rectangle!
    var s2:Rectangle!
    
    override func setup() {
        
        setupShapes()
        
        s2.transform.scale(4.0, 0.25)
        

    }
    
    func setupShapes() {
        let frame = Rect(self.canvas.center.x,self.canvas.center.y,50,50)
        s1 = Rectangle(frame: frame)
        s2 = Rectangle(frame: frame)
        
        s2.strokeColor = C4Pink
        
        self.canvas.add(s1)
        
        self.canvas.add(s2)
   
    }
}