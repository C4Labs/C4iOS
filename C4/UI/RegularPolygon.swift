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

///RegularPolygon is a is a concrete subclass of Polygon that defines a shape whose sides are uniform (e.g. pentagon, octagon, etc.).
///
/// This class defines two variables called `sides` and `phase` that represent the number of sides and the initial rotation of the shape (respectively). The default shape is a hexagon.
public class RegularPolygon: Polygon {
    /// Returns the number of sides in the polygon.
    ///
    /// Assigning a value to this property will change the number of sides and cause the receiver to automatically update its
    /// path.
    ///
    /// ````
    /// let f = Rect(100,100,100,100)
    /// var p = RegularPolygon(frame: f)
    /// p.sides = 3
    /// canvas.add(p)
    /// ````
    @IBInspectable
    public var sides: Int = 6 {
        didSet {
            assert(sides > 0)
            updatePath()
        }
    }

    /// Returns the phase (i.e. "rotated" beginning position) of the shape. This is not actual rotation, it simply changes
    /// where the beginning of the shape is.
    ///
    /// Assigning a value to this property will change the starting position of the beginning of the shape. The shape will
    /// still calculate its points based on the frame.
    ///
    /// ````
    /// let f = Rect(100,100,100,100)
    /// var p = RegularPolygon(frame: f)
    /// p.phase = M_PI_2
    /// canvas.add(p)
    /// ````
    @IBInspectable
    public var phase: Double = 0 {
        didSet {
            updatePath()
        }
    }

    /// Initializes a new RegularPolygon.
    ///
    /// Default values are are sides = 6 (i.e. a hexagon), phase = 0.
    convenience public init(center: Point, radius: Double = 50.0, sides: Int = 6, phase: Double = 0.0) {
        let dΘ = 2.0*M_PI / Double(sides)
        var pointArray = [Point]()
        for i in 0..<sides {
            let Θ = phase + dΘ * Double(i)
            pointArray.append(Point(radius*cos(Θ), radius*sin(Θ)))
        }

        self.init(pointArray)
        self.close()
        self.fillColor = C4Blue
        self.center = center
    }

    internal override func updatePath() {
        self.path = RegularPolygon(center: center, radius: width/2.0, sides:self.sides, phase:self.phase).path
    }
}
