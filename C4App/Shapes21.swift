//
//  Shapes21.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//

import UIKit
import C4

class Shapes21: CanvasController {
    
    var bezierCurve:Curve!
    var quadraticCurve:QuadCurve!
    var controlA:Circle!
    var controlB:Circle!
    var controlC:Ellipse!
    var bezierEndPoints:[Point]!
    var quadEndPoints:[Point]!
    var a:UIPanGestureRecognizer!
    var b:UIPanGestureRecognizer!
    var c:UIPanGestureRecognizer!

    
    override func setup() {
        //create the end points for the bezier curve
        bezierEndPoints = [
            Point(0.3*self.canvas.width,self.canvas.height/3),
            Point(0.7*self.canvas.width,self.canvas.height/3)
        ]
        
        //create the control points for the bezier curve
        let bezierControlPoints = [Point(32,32), Point(self.canvas.width-32,32)]
        
        //create the bezier curve
        bezierCurve = Curve(begin: bezierEndPoints[0], control0: bezierControlPoints[0], control1: bezierControlPoints[1], end: bezierEndPoints[1])
        self.canvas.add(bezierCurve)
        //create the end points for the quadratic curve
        quadEndPoints = [
            Point(0.3*self.canvas.width,self.canvas.height*2/3),
            Point(0.7*self.canvas.width,self.canvas.height*2/3)
        ]
        
        //create the control point for the quadratic curve
        var quadControlPoint = self.canvas.center;
        quadControlPoint.y = self.canvas.height - 32;
        
        //create the quadratic curve
        quadraticCurve = QuadCurve(begin: quadEndPoints[0], control: quadControlPoint, end: quadEndPoints[1])
        
        self.canvas.add(quadraticCurve)
        //create 3 control shapes
        controlA = Circle(center: Point(32,32), radius: 25)
        controlB = Circle(center: Point(self.canvas.width-32,32), radius: 25)
        controlC = Circle(center: quadControlPoint, radius: 25)
        
        
        //style the control shapes
        controlA.lineWidth = 0.0
        controlB.lineWidth = 0.0
        controlC.lineWidth = 0.0
        controlB.fillColor = C4Pink
        controlC.fillColor = C4Blue
        
        self.canvas.add(controlA)
        self.canvas.add(controlB)
        self.canvas.add(controlC)
        
        
        
        //add drag gestures to the control shapes
        a = controlA.addPanGestureRecognizer { (center, location, translation, velocity, state) -> () in
            var center = self.controlA.center
            center.x += translation.x
            center.y += translation.y
            self.controlA.center = center
            self.a.setTranslation(CGPointZero, inView: self.canvas.view)
            
            self.bezierCurve.controlPoints = (self.controlA.center, self.controlB.center)

        }
        b = controlB.addPanGestureRecognizer { (center, location, translation, velocity, state) -> () in
            var center = self.controlB.center
            center.x += translation.x
            center.y += translation.y
            self.controlB.center = center
            self.b.setTranslation(CGPointZero, inView: self.canvas.view)
            
            self.bezierCurve.controlPoints = (self.controlA.center, self.controlB.center)
        }
        c = controlC.addPanGestureRecognizer { (center, location, translation, velocity, state) -> () in
            var center = self.controlC.center
            center.x += translation.x
            center.y += translation.y
            self.controlC.center = center
            self.c.setTranslation(CGPointZero, inView: self.canvas.view)
            
            self.quadraticCurve.controlPoints = (self.controlC.center,self.controlC.center)
        }

    }
}