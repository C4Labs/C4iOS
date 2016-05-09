//
//  Images06.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Images06: CanvasController {
    
    override func setup() {
        let img1 = Image("chop")!
        img1.center = Point(self.canvas.center.x, self.canvas.height / 3)
        
        let img2 = Image(c4image: img1)
        img2.center = Point(self.canvas.center.x, self.canvas.height * 2 / 3)
        
        self.canvas.add(img1)
        self.canvas.add(img2)
    }
    
}