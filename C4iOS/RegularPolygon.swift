//  Created by Alejandro Isaza on 2014-10-13.
//  Copyright (c) 2014 C4. All rights reserved.

import Foundation

public class RegularPolygon: Shape {
    override public var bounds: CGRect {
        didSet {
            updatePath();
        }
    }
    
    override public var frame: CGRect {
        didSet {
            updatePath();
        }
    }
    
    @IBInspectable
    override var lineWidth: CGFloat {
        didSet {
            updatePath()
        }
    }
    
    @IBInspectable
    var sides: Int = 3 {
        didSet {
            updatePath()
        }
    }
    
    @IBInspectable
    var phase: CGFloat = 0 {
        didSet {
            updatePath()
        }
    }
    
    internal func updatePath() {
        let rect = CGRectInset(bounds, lineWidth, lineWidth)
        let rx = rect.size.width / 2.0
        let ry = rect.size.height / 2.0
        if sides == 0 || rx <= 0 || ry <= 0 {
            // Don't try to generate invalid polygons, we'll get undefined behaviour
            return
        }
        
        let center = CGPoint(x: CGRectGetMidX(rect), y: CGRectGetMidY(rect))
        let delta = CGFloat(2.0*M_PI) / CGFloat(sides)
        let path = Path()
        
        for i in 0..<sides {
            let angle = phase + delta*CGFloat(i)
            let point = CGPoint(x: center.x + rx*CGFloat(cos(angle)), y: center.y + ry*CGFloat(sin(angle)))
            if i == 0 {
                path.moveToPoint(point)
            } else {
                path.addLineToPoint(point)
            }
        }
        path.closeSubpath()
        shapeLayer.path = path.internalPath
    }
}
