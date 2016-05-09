//
//  NewMath04.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-22.
//  Copyright © 2015 Slant. All rights reserved.
//
import C4
import UIKit

class NewMath04: CanvasController {
    var mainPoints = [Point]()
    var modifiedPoints = [Point]()
    var insetFrame = Rect()
    override func setup() {
        let margin = canvas.frame.size.height * 0.1
        insetFrame = inset(canvas.frame, dx: margin, dy: margin)
        createPoints()
        let path = MathComparePaths(frame: canvas.frame, insetFrame: insetFrame, points: mainPoints, modifiedPoints: modifiedPoints)
        canvas.add(path)
    }
    
    func createPoints() {
        var x = -10.0
        repeat {
            let y = atan(x)
            let mappedX = map(x, min: -10, max: 10, toMin: 0, toMax: 1)
            let mappedY = map(y, min: -M_PI_2, max: M_PI_2, toMin: -1, toMax: 1) * -1.0
            modifiedPoints.append(Point(mappedX,mappedY))
            mainPoints.append(Point(mappedX,mappedY))
            x += 0.02
        } while x < 10.0
    }
}



