//
//  Advanced04.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-14.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Advanced04: CanvasController {
    
    
    var circle:Circle!
    var pink:Double!
    var blue:Double!
    var grey:Double!
    var pc = 0
    var bc = 0
    var gc = 0
    var pl = TextShape(text: "")
    var bl = TextShape(text: "")
    var gl = TextShape(text: "")
    
    override func setup() {
        // percent chance of each color being chosen (total must equal 100)
        pink = 0.3
        blue = 0.55
        grey = 0.15
        
        setupCircle()
        updateLabels()
        wait(1.0) {
            self.changeColors()
        }
        self.canvas.add(circle)
    }
    
    func changeColors() {
        weightedProbability()
        updateLabels()
        circle.strokeEnd = 0.0
        let a = ViewAnimation(duration:1.3) {
        self.circle.strokeEnd = 1.0
        }
        a.animate()
        wait(1.5) {
            self.changeColors()
        }
    }
    
    func weightedProbability() {
        let chance = Double(random01())
        if (chance <= pink) {
            circle.fillColor = C4Pink
            pc++
        }
        if (chance > pink && chance <= pink + blue){
            circle.fillColor = C4Blue
            bc++
        }
        if (chance > pink + blue && chance <= pink + blue + grey){
            circle.fillColor = C4Grey
            gc++
        }
    }
    
    func setupCircle() {
        circle = Circle(center: self.canvas.center, radius: 100)
        let a = ViewAnimation(duration: 1.0) {
        self.circle.strokeColor = Color(UIColor.blackColor())
        self.circle.transform.rotate(-M_PI/2)
        self.circle.lineWidth = 10.0
        self.circle.fillColor = Color(UIColor.clearColor())
        }
        a.animate()
    }
    
    func updateLabels() {
        //we need to remove the old labels and replace with labels reflecting the latest counts
        canvas.remove(pl)
        canvas.remove(bl)
        canvas.remove(gl)
        let ps = "Red has been chosen \(pc) times"
        let bs = "Blue has been chosen \(bc) times"
        let gs = "Grey has been chosen \(gc) times"
        
        pl = TextShape(text: ps, font: Font(name: "Helvetica", size: 14.0)!)!
        bl = TextShape(text: bs, font: Font(name: "Helvetica", size: 14.0)!)!
        gl = TextShape(text: gs, font: Font(name: "Helvetica", size: 14.0)!)!
        
        self.canvas.add(pl)
        self.canvas.add(bl)
        self.canvas.add(gl)
        
        var labelCenter = self.canvas.center
        labelCenter.y += 150
        pl!.center = labelCenter
        labelCenter.y += 30
        bl!.center = labelCenter
        labelCenter.y += 30
        gl!.center = labelCenter
        
    }

}

