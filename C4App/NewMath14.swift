//
//  NewMath14.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-23.
//  Copyright © 2015 Slant. All rights reserved.
//
import C4
import UIKit

class NewMath14: CanvasController {
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
        var x = 0.0
        repeat {
            let y = clamp(tan(x), min: -M_PI, max: M_PI)
            let mappedX = map(x, min: 0, max: 2*M_PI, toMin: 0, toMax: 1)
            let mappedY = map(y, min: -M_PI, max: M_PI, toMin: -1, toMax: 1) * -1.0
            modifiedPoints.append(Point(mappedX,mappedY))
            mainPoints.append(Point(mappedX,mappedY))
            x += 2 * M_PI/1000.0
        } while x < 2 * M_PI
    }
}