//
//  Math13.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-21.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Math13: CanvasController {
    
    var pathShape:Polygon!
    var backgroundPath:Polygon!
    var slider = UISlider()
    
    
    override func setup() {
        createAndAddSlider()
        createAndAddPathShapes()
    }
    
    func roundedPointFor(x:Double) -> Point {
        let calX = x / self.canvas.width * M_PI  // calibrated to [0 to TWO_PI]
        var y = sin(calX)                // create Y
        y *= 5                                        // zoom in (scale height to 5 points)
        y = round(y)                     // round value
        
        
        y *= 20                   //scale height to 20 points
        y *= -1                    //invert for iOS screen coords
        y += self.canvas.height/2  //move to halfway down the screen
        return Point(x,y)
    }
    
    func normalPointFor(x:Double) -> Point {
        let calX = x / self.canvas.width * M_PI  // calibrated to the screen
        let y = sin(calX) * 100 * -1       // create Y and invert for iOS screen coords
        return Point(x,y)
    }
    
    func createAndAddSlider() {
        slider = UISlider(frame: CGRectMake(0, 0, 300, 44))
        slider.center = self.canvas.view.center
        slider.addTarget(self, action: "adjustPathShape:", forControlEvents: UIControlEvents.ValueChanged)
        //        slider.sendActionsForControlEvents(.ValueChanged)
        self.canvas.add(slider)
    }
    
    func createAndAddPathShapes() {
        let stepWidth = 3
        let steps = Int(self.canvas.width) / stepWidth + 1
        var p = [Point]()
        var b = [Point]()
        
        for i in 0..<steps {
            
            
            let x = Double(i * stepWidth)
            b.append(normalPointFor(x))
            p.append(roundedPointFor(x))
            
        }
        
        pathShape = Polygon(p)
        pathShape.view.userInteractionEnabled = false
        pathShape.fillColor = clear
        pathShape.strokeEnd = Double(slider.value)
        
        
        backgroundPath = Polygon(b)
        backgroundPath.view.userInteractionEnabled = false
        backgroundPath.fillColor = clear
        backgroundPath.strokeColor = C4Blue
        backgroundPath.lineWidth = 2.0
        backgroundPath.center = self.canvas.center
        
        let patternArray = [
            NSNumber(int: 15),
            NSNumber(int: 5)
        ]
        backgroundPath.lineDashPattern = patternArray
        
        self.canvas.add(backgroundPath)
        self.canvas.add(pathShape)
    }
    
    func adjustPathShape(sender:UISlider!) {
        pathShape.strokeEnd = Double(sender.value)
    }
}