//
//  Images05.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//


import C4
import UIKit

class Images05 : CanvasController {
    //define 2 invisible images
    var i1:Image!
    var i2:Image!
    //define a visible image
    var visibleImage:Image!
    var isFirstImage:Bool!
    
    
    override func setup() {
        //create two invisible images
        i1 = Image("chop")
        i2 = Image("image1")
        
        //create the visible image from the first invisible image
        visibleImage = Image(c4image: i1)
        isFirstImage = true
        
        //position it and add it to the canvas
        visibleImage.center = self.canvas.center
        self.canvas.add(visibleImage)
        
        canvas.addTapGestureRecognizer { (center, location, state) -> () in
            if self.isFirstImage == true {
                self.visibleImage = Image(c4image: self.i2)
                self.isFirstImage = false
            } else {
                self.visibleImage = Image(c4image: self.i1)//need to change image property of visible image some how....
                self.isFirstImage = true

            }
        }
    }
    
}