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

import CoreImage

///  Generates a gradient that varies along a linear axis between two defined endpoints.
///
///  ````
///  let logo = Image(frame: canvas.frame)
///  var gradient = LinearGradient()
///  gradient.points = [logo.origin,logo.frame.max]
///  logo.generate(gradient)
///  canvas.add(logo)
///  ````
public struct LinearGradient: Generator {
    /// The name of the Core Image filter.
    public let filterName = "CISmoothLinearGradient"
    /// The colors of the filter. Defaults to `[C4Pink, C4Blue]`
    public var colors: [Color] = [C4Pink, C4Blue]
    /// The endpoints of the filter. Defaults to `[Point(), Point(100, 100)]`
    public var points: [Point] = [Point(), Point(100, 100)]

    ///Initializes a new filter
    public init() {}

    /// Applies the properties of the receiver to create a new CIFilter object
    ///
    /// - returns: The new CIFilter object.
    public func createCoreImageFilter() -> CIFilter {
        let filter = CIFilter(name: filterName)!
        filter.setDefaults()
        filter.setValue(CIColor(colors[0]), forKey:"inputColor0")
        filter.setValue(CIColor(colors[1]), forKey:"inputColor1")
        filter.setValue(CIVector(cgPoint: CGPoint(points[0])), forKey:"inputPoint0")
        filter.setValue(CIVector(cgPoint: CGPoint(points[1])), forKey:"inputPoint1")
        return filter
    }
}
