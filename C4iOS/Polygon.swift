//
//  Polygon.swift
//  C4iOS
//
//  Created by travis on 2014-11-03.
//  Copyright (c) 2014 C4. All rights reserved.
//

import Foundation
import CoreGraphics
import C4Core

public class Polygon: Shape {
    lazy internal var linePoints = [C4Point]()
    convenience public init(points: [C4Point]) {
        let count = points.count
        var cgPoints = [CGPoint]()
        for i in 0..<count {
            cgPoints.append(CGPoint(points[i]))
        }
        self.init(frame: CGRectMakeFromPoints(cgPoints))
        for i in 0..<points.count {
            linePoints.append(points[i])
        }
        
        updatePath()
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    internal override func updatePath() {
        if linePoints.count > 1 {
        let path = C4Path()
            path.moveToPoint(linePoints[0])
            
            for i in 1..<linePoints.count {
                path.addLineToPoint(linePoints[i])
            }
            
            shapeLayer.path = path.CGPath
        }
    }
}
