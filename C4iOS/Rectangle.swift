// Copyright © 2014 C4
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to
// deal in the Software without restriction, including without limitation the
// rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
// sell copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions: The above copyright
// notice and this permission notice shall be included in all copies or
// substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
// IN THE SOFTWARE.

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
