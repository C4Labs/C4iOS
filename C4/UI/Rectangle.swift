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

///  Rectangle is a concrete subclass of Shape that has a special initialzer that creates a rectangle whose shape is determined by its frame.
public class Rectangle: Shape {
    /// Returns the corner size for the receiver.
    ///
    /// The shape of a Rectangle's corners are specified with width and height.
    ///
    /// Automatically updates the shape of the receiver's corners when set.
    ///
    /// ````
    /// let f = Rect(100,100,100,100)
    /// let r = Rectangle(frame: f)
    /// r.corner = Size(10,10)
    /// canvas.add(r)
    /// ````
    public var corner: Size = Size(8, 8) {
        didSet {
            updatePath()
        }
    }

    /// Initializes a new Rectangle using the specified frame.
    ///
    /// ````
    /// let f = Rect(100,100,100,100)
    /// let r = Rectangle(frame: f)
    /// canvas.add(r)
    /// ````
    ///
    /// - parameter frame: A Rect whose dimensions are used to construct the Rectangle.
    public override init(frame: Rect) {
        super.init()
        if frame.size.width <= corner.width * 2.0 || frame.size.height <= corner.width / 2.0 {
            corner = Size()
        }
        view.frame = CGRect(frame)
        updatePath()
    }

    public override init() {
        super.init()
    }

    override func updatePath() {
        let newPath = Path()
        newPath.addRoundedRect(bounds, cornerWidth: corner.width, cornerHeight: corner.height)
        path = newPath
    }
}
