//  Created by Alejandro Isaza on 2014-09-30.
//  Copyright (c) 2014 C4. All rights reserved.

import Foundation

extension Shape {
    var mutablePath: CGMutablePathRef {
        get {
            if path != nil {
                return CGPathCreateMutableCopy(path)
            } else {
                return CGPathCreateMutable()
            }
        }
        set(newPath) {
            path = newPath;
        }
    }

    func addCircle(center: CGPoint, radius: CGFloat) {
        let newPath = mutablePath

        let rect = CGRectMake(center.x - radius, center.y - radius, radius*2, radius*2)
        CGPathAddEllipseInRect(newPath, nil, rect);
        self.path = newPath
    }

    func addPolygon(points: [CGPoint], closed: Bool = true) {
        let newPath = mutablePath

        if !points.isEmpty {
            CGPathMoveToPoint(newPath, nil, points[0].x, points[0].y)
        }
        for point in points {
            CGPathAddLineToPoint(newPath, nil, point.x, point.y)
        }
        if closed {
            CGPathCloseSubpath(newPath)
        }
        self.path = newPath
    }

    func addLine(start: CGPoint, stop: CGPoint) {
        let newPath = mutablePath
        CGPathMoveToPoint(newPath, nil, start.x, start.y)
        CGPathAddLineToPoint(newPath, nil, stop.x, stop.y)
        self.path = newPath
    }
}
