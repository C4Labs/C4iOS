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

/// Triangle defines a concrete subclass of Polygon whose shape is a closed triangle.
public class Triangle: Polygon {

    /// Initializes a new Triangle using the specified array of points.
    ///
    /// Protects against trying to create a triangle with less than three points.
    ///
    /// - parameter points: An array of Point structs.
    public override init(_ points: [Point]) {
        assert(points.count >= 3, "To create a Triangle you need to specify an array of at least 3 points")
        super.init(points)
        self.fillColor = C4Blue
        self.close()
    }

    /// Initializes a new Polygon from data in a given unarchiver.
    /// - parameter coder: An unarchiver object.
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
