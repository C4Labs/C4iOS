//  Created by Alejandro Isaza on 2014-09-30.
//  Copyright (c) 2014 C4. All rights reserved.

import Foundation

extension Shape {
    func addCircle(center: CGPoint, radius: CGFloat) {
        if path == nil {
            path = Path()
        }

        let rect = CGRectMake(center.x - radius, center.y - radius, radius*2, radius*2)
        path!.addEllipse(rect)
    }

    func addPolygon(points: [CGPoint], closed: Bool = true) {
        if path == nil {
            path = Path()
        }

        if !points.isEmpty {
            path!.moveToPoint(points[0])
        }
        for point in points {
            path!.addLineToPoint(point)
        }
        if closed {
            path!.closeSubpath()
        }
    }

    func addLine(start: CGPoint, stop: CGPoint) {
        if path == nil {
            path = Path()
        }
        
        path!.moveToPoint(start)
        path!.addLineToPoint(stop)
    }
}
