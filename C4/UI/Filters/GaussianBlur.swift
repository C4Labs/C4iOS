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

///  Spreads source pixels by an amount specified by a Gaussian distribution.
///
///  ````
///  let logo = Image("logo")
///  logo.apply(GaussianBlur())
///  canvas.add(logo)
///  ````
public struct GaussianBlur: Filter {
    /// The name of the Core Image filter.
    public let filterName = "CIGaussianBlur"

    /// The radius of the blur. Defaults to 10.0
    public var radius: Double

    ///  Initializes a new filter
    /// - parameter radius: a Double value
    public init(radius: Double = 5.0) { self.radius = radius }

    /// Applies the properties of the receiver to create a new CIFilter object
    ///
    /// - parameter inputImage: The image to use as input to the filter.
    /// - returns: The new CIFilter object.
    public func createCoreImageFilter(_ inputImage: CIImage) -> CIFilter {
        let filter = CIFilter(name: filterName)!
        filter.setDefaults()
        filter.setValue(radius, forKey:"inputRadius")
        filter.setValue(inputImage, forKey: "inputImage")
        return filter
    }
}
