//
//  Views02.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views02: CanvasController {
    
    var s1:Circle!

    
    override func setup() {
        s1 = Circle(center: self.canvas.center, radius: 44)
        s1.backgroundColor = C4Pink
        self.canvas.add(s1)
    }
    
}