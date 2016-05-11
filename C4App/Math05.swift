//
//  Math05.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-21.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class Math05: CanvasController {
    
    var p:Point!
    var shapes:[Shape]!
    var numberOfColumns:Double!
    var numberOfRows:Double!
    
    override func setup() {
        
        shapes = [Shape]()
        
        numberOfColumns = 5
        numberOfRows = 5
        
        for i in 0..<Int(numberOfColumns) {
            for j in 0..<Int(numberOfRows) {
                
                let shape = Rectangle(frame: Rect(0,0,50,16))//height must be greater than 16 or the cornerRadiusHeight * 2
                shape.anchorPoint = Point(0.0,0.5)
                let newX = ((self.canvas.width/numberOfColumns) * Double(i)) + ((self.canvas.width/numberOfColumns)/2)
                let newY = ((self.canvas.height/numberOfRows) * Double(j)) + ((self.canvas.height/numberOfRows)/2);
                
                shape.center = Point(newX, newY)
                shape.view.userInteractionEnabled = false
                shape.strokeColor = clear
                shapes.append(shape)
                self.canvas.add(shape)
            }
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first as UITouch!
        let location = touch.locationInView(self.view)
        p = c4pointFromCGPoint(location)
        for i in 0..<Int(numberOfRows*numberOfColumns) {
            let shape = shapes[i]
            let arctangent = atan2(p.y-shape.center.y, p.x-shape.center.x)
            shape.transform.rotate(arctangent)
        }
    }
    func c4pointFromCGPoint(point:CGPoint) -> Point {
        var newPoint = Point()
        newPoint.x = Double(point.x)
        newPoint.y = Double(point.y)
        return newPoint
    }
}

