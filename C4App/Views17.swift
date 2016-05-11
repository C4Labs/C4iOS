//
//  Views17.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views17: CanvasController {
    
    var img:Image!
    var s:Ellipse!
    
    override func setup() {
        img = Image("chop")
        s = Ellipse(frame: Rect(0, 0, img.height, img.height))
        
        img.center = self.canvas.center
        s.center = Point(img.width/2 ,img.height/2)
        img.layer?.mask = s.layer
        self.canvas.add(img)
    }
}
