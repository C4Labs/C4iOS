//
//  NewMath06.swift
//  C4Examples
//
//  Created by Oliver Andrews on 2015-09-23.
//  Copyright © 2015 Slant. All rights reserved.
//

import C4
import UIKit

class NewMath06: CanvasController {
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
            let y = sin(x * 2 * M_PI) * -1//-1 inverts from iOS coordinates to normal cartesian
            let my = ceil(sin(x * 2 * M_PI)) * -1 //same as above
            modifiedPoints.append(Point(x,my))
            mainPoints.append(Point(x,y))
            x += 0.001
        } while x < 1
    }
}