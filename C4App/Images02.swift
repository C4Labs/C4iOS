//
//  Images02.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Images02 : CanvasController {
    
    override func setup() {
        
        let img = Image("chop")!
        img.width = self.canvas.width
        img.center = self.canvas.center
        self.canvas.add(img)
    }
}