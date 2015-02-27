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
import CoreGraphics
import C4Core

public class C4Rectangle: C4Shape {
    
    /**
    Returns the corner size for the receiver.
    
    The shape of a C4Rectangle's corners are specified with width and height.
    
    Automatically updates the shape of the receiver's corners when set.
    */
    public var corner: C4Size = C4Size() {
        didSet {
            updatePath()
        }
    }
    
    /**
    Initializes a new C4Rectangle using the specified frame.
    
    :param: frame A C4Rect whose dimensions are used to construct the C4Rectangle.
    */
    convenience public init(frame: C4Rect) {
        self.init()
        view.frame = CGRect(frame)
        updatePath()
    }
    
    override public func updatePath() {
        let newPath = C4Path()
        newPath.addRoundedRect(bounds, cornerWidth: corner.width, cornerHeight: corner.height)
        path = newPath
    }
}