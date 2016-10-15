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

///Increases image detail by sharpening.
public struct Sharpen: Filter {
    /// The name of the Core Image filter (e.g. "CIBloom")
    public let filterName = "CISharpenLuminance"
    /// A Double value by which to sharpen the image. Default value: 0.4
    public var sharpness: Double = 0.4

    ///Initializes a new filter
    public init() {}

    /// Applies the properties of the receiver to create a new CIFilter object
    ///
    /// - parameter inputImage: The image to use as input to the filter.
    /// - returns: The new CIFilter object.
    public func createCoreImageFilter(_ inputImage: CIImage) -> CIFilter {
        let filter = CIFilter(name: filterName)!
        filter.setDefaults()
        filter.setValue(sharpness, forKey:"inputSharpness")
        filter.setValue(inputImage, forKey:"inputImage")
        return filter
    }
}
