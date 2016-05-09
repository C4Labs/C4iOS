//
//  Advanced06.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-15.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Advanced06: CanvasController {
    
    var img:Image!
    var container = Rectangle()
    
    override func setup() {
        setupShapes()
        img.backgroundColor = C4Blue
        img.layer?.mask = container.layer
        canvas.add(img)
    }
    
    func setupShapes() {
        img = Image("chop")
        img.height = self.canvas.height
        container = Rectangle(frame: Rect(0,0,300, self.canvas.height))
        container.fillColor = Color(UIColor.clearColor())
        self.addVisibleContainer()
        
        img.center = self.canvas.center;
        container.center = Point(img.width/2 ,img.height/2);
        for _ in 0..<30 {
            self.makeStrip()
            
        }
    }
    
    func makeStrip() {
        let h = Double(random(min: Int(container.corner.height*2), max: 300)) // the strips need minimum container cornerRadius*2 or possible assertion failure
        let strip = Rectangle(frame: Rect(0,0,300,h))
        strip.center = Point(container.width/2 ,container.height/2);
        strip.opacity = 0.3
        strip.corner = Size(2,2)
        container.add(strip)
        newPlace(strip)
    }
    func newPlace(sender: Shape) {
        let time = random01()*5 + 1.5
        let a = ViewAnimation(duration:time) {
            sender.center = Point(sender.center.x, random01()*self.container.height)
        }
        a.animate()
        wait(time) {
            self.newPlace(sender)
        }
        
    }
    
    func addVisibleContainer() {
        let visibleContainer = Rectangle(frame: self.container.frame)
        visibleContainer.center = self.canvas.center
        visibleContainer.fillColor = Color(UIColor.clearColor())
        visibleContainer.lineWidth = 2.0
        visibleContainer.strokeColor = C4Blue
        self.canvas.add(visibleContainer)
    }
    
    
}
