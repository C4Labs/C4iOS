//
//  Views18.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-10.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views18: CanvasController {
    
    var m:Image!
    var img:Image!
    
    override func setup() {
        
        img = Image("chop")

        m.width = img.width
        img.center = self.canvas.center
        m.center = Point(m.width/2 ,m.height/2)


        
        img.layer?.mask = m.layer
        
        self.canvas.add(img)
        
        let a = ViewAnimation(duration: 1.5) {
            self.m.transform.rotate(M_PI)
            //m.rotation += TWO_PI;

        }
        a.repeats = true
        a.curve = .Linear
        wait(0.1) {
            a.animate()
        }

    }
}
