//
//  Math04.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-11.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Math04: CanvasController {
    
    var pathShape:Polygon!
    var slider = UISlider()
    
    
    override func setup() {
        createAndAddPathShapes()
        createAndAddSlider()
    }
    
    func tanPointsFor(x:Double) -> Point {
        // for atan we need to change the scope of x to [-1 to 1] (instead of [0 to TWO_PI]).
        let calX = ((x/self.canvas.width)-0.5)*2.0   // calibrated to [-1 to 1]
        var y = atan(calX)                    // create Y
        
        y *= 100                   //scale height to 100 points
        y *= -1                    //invert for iOS screen coords
        y += self.canvas.height/2  //move to halfway down the screen
        
        // keep in mind that a acos graph looks like this:
        // http://www.weizmann.ac.il/matlab/techdoc/ref/acos.gif
        // so it doesn't look "centered" on the screen, but it's because it reaches x = 1 when y = 0
        
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