//
//  ImageFilters10.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-10.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class ImageFilters10: CanvasController {
    override func setup() {
        
        let image = Image("chop")!
        var filter = Twirl()
        filter.angle = 50
        filter.center = canvas.center
        filter.radius = 100
        image.apply(filter)
        image.center = canvas.center
        canvas.add(image)
        
    }
}