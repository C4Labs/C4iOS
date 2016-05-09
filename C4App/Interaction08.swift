//
//  Interaction08.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-17.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Interaction08: CanvasController {
    
    var s1:Circle!
    var s2:Circle!
    var s3:Circle!
    
    var gl1 = TextShape(text: "")!
    var gl2 = TextShape(text: "")!
    var gl3 = TextShape(text: "")!
    
    var g1:UITapGestureRecognizer!
    var g2:UILongPressGestureRecognizer!
    var g3:UIPanGestureRecognizer!
    
    override func setup() {
        s1 = Circle(center: self.canvas.center, radius: 50)
        s2 = Circle(center: self.canvas.center, radius: 50)
        s3 = Circle(center: self.canvas.center, radius: 50)
        
        s1.center.y -= 175
        s3.center.y += 175
        
        canvas.add(s1)
        canvas.add(s2)
        canvas.add(s3)
        
        g1 = s1.addTapGestureRecognizer({ (center, location, state) -> () in
            self.randomColorAndGesture(self.s1,state: state)
            self.updateLabels()
        })
        
        g2 = s2.addLongPressGestureRecognizer({ (center, location, state) -> () in
            self.randomColorAndGesture(self.s2,state: state)
            self.updateLabels()
        })
        
        g3 = s3.addPanGestureRecognizer({ (center, location, translation, velocity, state) -> () in
            self.randomColorAndGesture(self.s3,state: state)
            self.updateLabels()
        })
        
        updateLabels()
        
    }
    
    func updateLabels() {
        gl1.removeFromSuperview()
        gl2.removeFromSuperview()
        gl3.removeFromSuperview()
        
        let gs1 = "Number of taps required: \(g1.numberOfTapsRequired)"
        let gs2 = "Press length required: \(g2.minimumPressDuration)"
        let gs3 = "Number of touches required: \(g3.minimumNumberOfTouches)"
        
        gl1 = TextShape(text: gs1, font: Font(name: "Helvetica", size: 13.0)!)!
        gl2 = TextShape(text: gs2, font: Font(name: "Helvetica", size: 13.0)!)!
        gl3 = TextShape(text: gs3, font: Font(name: "Helvetica", size: 13.0)!)!
        
        var center = s1.center
        center.y += 75
        gl1.center = center
        center.y += 175
        gl2.center = center
        center.y += 175
        gl3.center = center
        
        self.canvas.add(gl1)
        self.canvas.add(gl2)
        self.canvas.add(gl3)
        
    }
    
    func randomColorAndGesture(shape: Shape, state:UIGestureRecognizerState) {
        if shape == s1 {
            self.g1.numberOfTapsRequired = random(min: 1, max: 5)
            self.s1.fillColor = Color(red: random01(), green: random01(), blue: random01(), alpha: random01())
        } else if shape == s2 && state == .Began {
            self.g2.minimumPressDuration = Double(random(min: 1, max: 5))
            self.s2.fillColor = Color(red: random01(), green: random01(), blue: random01(), alpha: random01())
            
        } else if shape == s3 && state == .Began {
            self.g3.minimumNumberOfTouches = (random(min: 1, max: 4))
            self.s3.fillColor = Color(red: random01(), green: random01(), blue: random01(), alpha: random01())
        }
        
    }
}
