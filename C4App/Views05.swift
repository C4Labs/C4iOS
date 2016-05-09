//
//  Views05.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views05: CanvasController {
    
    override func setup() {
    
        let c = Circle(center: self.canvas.center, radius: 50)
        self.canvas.add(c)
        c.lineWidth = 0
        c.backgroundColor = C4Pink
        c.border.radius = 25.0
        
    }
}
