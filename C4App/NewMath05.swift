//
//  Math05.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-21.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class NewMath05: CanvasController {

    var shapes : [Shape] = [Shape]()
    var columns = 5
    var rows = 5

    override func setup() {
        let dx = canvas.width / Double(columns)
        let dy = canvas.height / Double(rows)

        let frame = Rect(0,0,50,16)
        for x in 0..<columns {
            for y in 0..<rows {
                let shape = Rectangle(frame: frame)//height must be greater than 16 or the cornerRadiusHeight * 2
                shape.anchorPoint = Point(0.0,0.5)
                shape.interactionEnabled = false

                let newX = dx * (Double(x) + 0.5)
                let newY = dy * (Double(y) + 0.5)
                shape.center = Point(newX, newY)

                shapes.append(shape)
                canvas.add(shape)
            }
        }

        canvas.addPanGestureRecognizer { (center, location, translation, velocity, state) -> () in
            for i in 0..<self.shapes.count {
                let shape = self.shapes[i]
                let angle = -1 * atan2(location.y-shape.center.y, location.x-shape.center.x)
                let transform = Transform.makeRotation(angle)
                shape.transform = transform
            }
        }
    }
}

