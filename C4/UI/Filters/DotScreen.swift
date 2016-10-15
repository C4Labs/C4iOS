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

///  Simulates the dot patterns of a halftone screen.
///
///  ````
///  let logo = Image("logo")
///  logo.apply(DotScreen())
///  canvas.add(logo)
///  ````
public struct DotScreen: Filter {
    /// The name of the Core Image filter.
    public let filterName = "CIDotScreen"
    /// The center of the pattern. Defaults to {0,0}
    public var center: Point = Point()
    /// The width of the dots. Defaults to 2.0
    public var width: Double = 2.0
    /// The angle of the pattern. Defaults to 0.0
    public var angle: Double = 0
    /// The sharpness of the edges of the pattern. Defaults to 0.5
    public var sharpness: Double = 0.5

    ///Initializes a new filter
    public init() {}

    /// Applies the properties of the receiver to create a new CIFilter object
    ///
    /// - parameter inputImage: The image to use as input to the filter.
    /// - returns: The new CIFilter object.
    public func createCoreImageFilter(_ inputImage: CIImage) -> CIFilter {
        let filter = CIFilter(name: filterName)!
        filter.setDefaults()
        filter.setValue(width, forKey:"inputWidth")
        filter.setValue(angle, forKey:"inputAngle")
        filter.setValue(sharpness, forKey:"inputSharpness")
        filter.setValue(CIVector(cgPoint: CGPoint(center)), forKey:"inputCenter")
        filter.setValue(inputImage, forKey: "inputImage")
        return filter
    }
}
