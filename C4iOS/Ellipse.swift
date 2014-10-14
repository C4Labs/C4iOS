//  Created by Alejandro Isaza on 2014-10-13.
//  Copyright (c) 2014 C4. All rights reserved.

import Foundation

public class Ellipse: Shape {
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
    
    internal func updatePath() {
        let path = Path()
        let rect = CGRectInset(bounds, lineWidth, lineWidth)
        path.addEllipse(rect)
        shapeLayer.path = path.internalPath
    }
}
