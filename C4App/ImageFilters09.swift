//
//  ImageFilters09.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-10.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4

class ImageFilters09: CanvasController {
    override func setup() {
        
        let image = Image("chop")!
        var filter = Sharpen()
        filter.sharpness = 5
        image.apply(filter)
        image.center = canvas.center
        canvas.add(image)
        
    }
}