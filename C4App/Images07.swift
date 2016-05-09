//
//  Images07.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//


import C4
import UIKit

class Images07: CanvasController {
    
    
    override func setup() {
        
        
        //define dimensions for the image size
        let width = 320
        let height = 240
        
        //we create an array for our color data
        var rawData = [Pixel]()
        
        //for every row
        for _ in 0..<height {
        
        
            //color each pixel in that row
            for _ in 0..<width {
                //random colored pixels
                rawData.append(Pixel(random(below: 255), random(below: 255), random(below: 255), 255))

            }
        }
        
        let img = Image(pixels: rawData, size: Size(width, height))
        img.center = canvas.center
        canvas.add(img)
        
    }
}
