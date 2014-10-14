//  Created by Alejandro Isaza on 2014-10-13.
//  Copyright (c) 2014 C4. All rights reserved.

import Foundation

public class Rectangle: Shape {
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
    var cornerWidth: CGFloat = 0 {
        didSet {
            updatePath()
        }
    }
    
    @IBInspectable
    var cornerHeight: CGFloat = 0 {
        didSet {
            updatePath()
        }
    }
    
    internal func updatePath() {
        let path = Path()
        let rect = CGRectInset(bounds, lineWidth, lineWidth)
        path.addRoundedRect(rect, cornerWidth: cornerWidth, cornerHeight: cornerHeight)
        shapeLayer.path = path.internalPath
    }
}
