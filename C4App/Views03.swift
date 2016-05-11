//
//  Views03.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-09.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class Views03: CanvasController {
    override func setup() {
        let img = Image("chop")!
        img.center = self.canvas.center
        img.border.width = 10.0
        img.border.color = C4Pink
        self.canvas.add(img)
    }
}
