//
//  Math15.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-21.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Math15: CanvasController {
    
    var pathShape:Polygon!
    var slider = UISlider()
    
    
    override func setup() {
        createAndAddPathShapes()
        createAndAddSlider()
    }
    
    func tanPointsFor(x:Double) -> Point {
        let calX = (x/self.canvas.width) * M_PI   // calibrated to [0 to TWO_PI]
        var y = tan(calX)                    // create Y
        
        y *= 100                   //scale height to 100 points
        y *= -1                    //invert for iOS screen coords
        y += self.canvas.height/2  //move to halfway down the screen
        y = clamp(y, min: 0, max: self.canvas.height)

        
        return Point(x,y)
    }
    
    func createAndAddSlider() {
        slider = UISlider(frame: CGRectMake(0, 0, 300, 44))
        slider.center = self.canvas.view.center
        slider.addTarget(self, action: "adjustPathShape:", forControlEvents: UIControlEvents.ValueChanged)
        //                slider.sendActionsForControlEvents(.ValueChanged)
        self.canvas.add(slider)
    }
    
    func createAndAddPathShapes() {
        let stepWidth = 1
        let steps = Int(self.canvas.width) / stepWidth + 1
        var p = [Point]()
        
        for i in 0..<steps {
            
            
            let x = Double(i * stepWidth)
            p.append(tanPointsFor(x))
            
        }
        
        pathShape = Polygon(p)
        pathShape.view.userInteractionEnabled = false
        pathShape.fillColor = clear
        pathShape.strokeEnd = Double(slider.value)
        
        
        self.canvas.add(pathShape)
    }
    
    func adjustPathShape(sender:UISlider) {
        pathShape.strokeEnd = Double(sender.value)
    }
}