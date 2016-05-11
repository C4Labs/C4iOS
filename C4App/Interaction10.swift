//
//  Interaction10.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-17.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Interaction10: CanvasController {
    
    var s1:Circle!
    var s2:Circle!
    var s3:Circle!
    var shapes = [Circle]()
    var k1 = "swipedRight"
    var k2 = "swipedLeft"
    var k3 = "swipedUp"
    var k4 = "swipedDown"
    
    override func setup() {
        s1 = Circle(center: Point(self.canvas.center.x, self.canvas.center.y-100), radius:50)
        s2 = Circle(center: self.canvas.center, radius:50)
        s3 = Circle(center: Point(self.canvas.center.x, self.canvas.center.y+100), radius:50)
        
        shapes.append(s1)
        shapes.append(s2)
        shapes.append(s3)
        canvas.add(s1)
        canvas.add(s2)
        canvas.add(s3)
        
        for shape in shapes {//for each shape
            for g in 0...3 {//add gesture for each direction
                var str = k1

                let a = shape.addSwipeGestureRecognizer({ (center, location, state, direction) -> () in
                    shape.post(str)
                })
                if g == 0 {
                    canvas.on(event: str, from: shape, run: { (Void) -> Void in
                        print("right")
                        self.changeShapeColorOnEvent(shape, event:str)
                    })
                } else if g == 1 {
                    str = k2
                    a.direction = .Left
                    canvas.on(event: str, from: shape, run: { (Void) -> Void in
                        print("left")
                        self.changeShapeColorOnEvent(shape, event:str)
                    })
                } else if g == 2 {
                    str = k3
                    a.direction = .Up
                    canvas.on(event: str, from: shape, run: { (Void) -> Void in
                        print("up")
                        self.changeShapeColorOnEvent(shape, event:str)
                        
                    })
                } else if g == 3 {
                    str = k4
                    a.direction = .Down
                    canvas.on(event: str, from: shape, run: { (Void) -> Void in
                        print("down")
                        self.changeShapeColorOnEvent(shape, event:str)
                        
                    })
                }
                
            }
        }
    }
    func changeShapeColorOnEvent(shape: Shape, event:String) {
        if event == k1{
            shape.fillColor = red
        } else if event == k2 {
            shape.fillColor = blue
        } else if event == k3 {
            shape.fillColor = green
        } else if event == k4 {
            shape.fillColor = purple
        }
    }
}
