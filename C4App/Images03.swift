//
//  Images03.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Images03 : CanvasController {
    
    override func setup() {
        
        let img = Image("chop")!
        img.height = self.canvas.height
        img.center = self.canvas.center;
        self.canvas.add(img)
    }
}