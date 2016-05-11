//
//  Images08.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-08.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Images08: CanvasController {
    
    
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
        let s = Circle(center: img.center, radius: img.height/2)
        
        let a = ViewAnimation(duration: 100) {
            s.transform.scale(5, 10)
        }
        a.repeats = true
//        a.curve = .Linear
        a.animate()
        img.center = canvas.center
        img.layer?.mask = s.layer
        canvas.add(img)
        
    }
}