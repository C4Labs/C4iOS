//
//  NewMath03.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-22.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class NewMath03: CanvasController {
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
        var x = -1.0
        repeat {
            let y = asin(x)
            let mappedX = map(x, min: -1, max: 1, toMin: 0, toMax: 1)
            let mappedY = map(y, min: 0, max: M_PI_2, toMin: 0, toMax: 1) * -1.0
            modifiedPoints.append(Point(mappedX,mappedY))
            mainPoints.append(Point(mappedX,mappedY))
            x += 0.002
        } while x < 1
    }
}



