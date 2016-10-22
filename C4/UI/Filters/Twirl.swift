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

///  Rotates pixels around a point to give a twirling effect.
///
///  ````
///  let logo = Image("logo")
///  logo.apply(Twirl())
///  canvas.add(logo)
///  ````
public struct Twirl: Filter {
    /// The name of the Core Image filter.
    public let filterName = "CITwirlDistortion"
    /// The center of the twirl effet. Defaults to {0,0}
    public var center: Point = Point()
    /// The radius of the twirl effect. Defaults to 100.0
    public var radius: Double = 100.0
    /// The angle of the twirl effect. Defaults to 𝞹
    public var angle: Double = M_PI

    ///Initializes a new filter
    public init() {}

    /// Applies the properties of the receiver to create a new CIFilter object
    ///
    /// - parameter inputImage: The image to use as input to the filter.
    /// - returns: The new CIFilter object.
    public func createCoreImageFilter(_ inputImage: CIImage) -> CIFilter {
        let filter = CIFilter(name: filterName)!
        filter.setDefaults()
        filter.setValue(radius, forKey:"inputRadius")
        filter.setValue(angle, forKey:"inputAngle")
        let filterSize = inputImage.extent.size
        let vector = CIVector(x: CGFloat(center.x) * filterSize.width, y: CGFloat(1.0 - center.y) * filterSize.height)
        filter.setValue(vector, forKey:"inputCenter")
        filter.setValue(inputImage, forKey: "inputImage")
        return filter
    }
}
