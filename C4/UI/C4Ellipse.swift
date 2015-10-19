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

///  C4Ellipse is a concrete subclass of C4Shape that has a special initialzer that creates an ellipse whose shape is defined by the object's frame.
public class C4Ellipse: C4Shape {
    
    /// Creates an ellipse.
    ///
    /// ````
    /// let r = C4Rect(0,0,100,200)
    /// let e = C4Ellipse(frame: r)
    /// ````
    ///
    /// - parameter frame: The frame within which to draw an ellipse that touches each of the four sides of the frame.
    convenience public init(frame: C4Rect) {
        self.init()
        view.frame = CGRect(frame)
        updatePath()
    }
    
    override func updatePath() {
        let newPath = C4Path()
        newPath.addEllipse(bounds)
        path = newPath
    }
}