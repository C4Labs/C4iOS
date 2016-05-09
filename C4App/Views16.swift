//
//  Views16.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views16: CanvasController {
    
    var m:Image!
    var img:Image!
    
    override func setup() {
        
        img = Image("chop")!
        m = Image("chop")!
        
        m.width = img.width
        
        img.layer?.mask = m.layer
        
        img.center = self.canvas.center
        self.canvas.add(img)
    }
}