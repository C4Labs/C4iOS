//
//  Shapes18.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-04.
//  Copyright © 2015 Slant. All rights reserved.
//

import UIKit
import C4

class Shapes18: CanvasController {
    
    var theShape:Shape!

    
    var circle : Circle!
    var square : Rectangle!
    var shape : Shape!
    var isCircle = true
    override func setup() {
        circle = Circle(center: canvas.center, radius: 100)
        square = Rectangle(frame: circle.frame)
        shape = Shape(frame: circle.frame)
        shape.path = circle.path
        canvas.add(shape)
        canvas.addTapGestureRecognizer { (center, location, state) -> () in
            if self.isCircle {
                self.shape.path = self.square.path
                self.isCircle = false
            } else {
                self.shape.path = self.circle.path
                self.isCircle = true
            }
        }
    }
}
//
//    override func setup() {
//            //setup up the initial shape
//            theShape = Rectangle(frame: Rect(0,0,240,240))
//            theShape.center = self.canvas.center;
//        
//            //set its animation duration which will be used for all animations
////            theShape.animationDuration = 1.0f;
//        
//            //add it to the canvas
//        self.canvas.add(theShape)
//        
//            //run the -(void)ellipse method 2 seconds later...
//                wait(2.0){
//                self.rect()
//                }
//        }
//        
//        func rect() {
//            theShape = Rectangle(frame: Rect(0,0,240,240))
//            theShape.center = self.canvas.center;
//            wait(2.0){
//                self.ellipse()
//            }
//    }
//        
//        func ellipse() {
//            theShape = Ellipse(frame: theShape.frame)
//            wait(2.0){
//                self.triangle()
//            }
//    }
//        
//        func triangle() {
//            let pts = [
//                Point(self.canvas.center.x-100, self.canvas.center.y),
//                Point(self.canvas.center.x, self.canvas.center.y-100),
//                Point(self.canvas.center.x+100, self.canvas.center.y)
//            ]
//            theShape = Triangle(pts)
//            wait(2.0){
//                self.arc()
//            }
//    }
//        
//        func arc() {
//
//            theShape = Arc(center: self.canvas.center, radius: 100, start: M_PI / 3.0, end: M_PI*2/3.0, clockwise: true)
//    
//            wait(2.0){
//                self.wedge()
//            }
//    }
//        
//        func wedge() {
//            theShape = Wedge(center: self.canvas.center, radius: 100, start: M_PI/3.0, end: M_PI*2/3.0, clockwise: false)
//        
//            wait(2.0){
//                self.bezierCurve()
//            }
//    }
//        
//        func bezierCurve() {
//            let endPoints = [
//                Point(self.canvas.center.x-100, self.canvas.center.y),
//                Point(self.canvas.center.x+100, self.canvas.center.y)
//            ]
//            let ctrlPoints = [
//                Point(random(below: Int(self.canvas.width)), random(below: Int(self.canvas.height))),
//                Point(random(below: Int(self.canvas.width)), random(below: Int(self.canvas.height)))
//            ]
//            theShape = C4Curve(points: endPoints, controls: ctrlPoints)
//            wait(2.0){
//                self.quadCurve()
//            }
//    }
//        
//        func quadCurve() {
//            let endPoints = [
//                Point(self.canvas.center.x-100, self.canvas.center.y),
//                Point(self.canvas.center.x+100, self.canvas.center.y)
//            ]
//            let ctrlPoint = Point(random(below: Int(self.canvas.width)), random(below: Int(self.canvas.height)))
//
//            theShape = C4QuadCurve(points: endPoints, control: ctrlPoint)
//            
//            wait(2.0){
//                self.polygon()
//            }
//    }
//        
//        func polygon() {
//            var pts = [Point]()
//            for _ in 0..<10 {
//                pts.append(Point(Double(random(below: 100))+self.canvas.center.x-100,
//                    Double(random(below: 100))+self.canvas.center.y-100))
//            }
//            theShape = Polygon(pts)
//            wait(2.0){
//                self.text()
//            }
//    }
//        
//        func text(){
//            let f = Font(name: "ArialRoundedMTBold", size: 180)
//            theShape = TextShape(text: "WHAM!", font: f)
//            theShape.center = self.canvas.center
//            wait(2.0){
//                self.rect()
//            }
//    }
//    
//}