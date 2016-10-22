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

///  The Filter protocol declares a variable and a method that are required by Filter object so it can properly interface with Core Image.
public protocol Filter {
    /// The name of the Core Image filter (e.g. "CIBloom")
    var filterName: String { get }

    ///  Creates a Core Image filter using specified input image.
    ///
    ///  This method is used internally by Image when applying filters to its layer's contents.
    ///
    ///  ````
    ///  public func createCoreImageFilter(inputImage: CIImage) -> CIFilter {
    ///      let filter = CIFilter(name: filterName)!
    ///      filter.setDefaults()
    ///      filter.setValue(radius, forKey:"inputRadius")
    ///      filter.setValue(intensity, forKey:"inputIntensity")
    ///      filter.setValue(inputImage, forKey:"inputImage")
    ///      return filter
    ///  }
    ///  ````
    ///
    ///  A specific filter will have internal properties whose values are applied to the CIFilter being generated. However, those properties are object / filter specific and so cannot be defined in the protocol.
    ///
    /// - parameter inputImage: A CIImage to be used in generating the filter.
    ///
    /// - returns: A CIFilter whose name is `filterName` and whose contents are based on `inputImage`.
    func createCoreImageFilter(_ inputImage: CIImage) -> CIFilter
}
