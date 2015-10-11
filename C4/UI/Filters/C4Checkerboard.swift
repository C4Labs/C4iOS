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

///  Generates a checkerboard pattern
///
///  ````
///  let image = C4Image(frame: canvas.frame)
///  image.generate(C4Checkerboard())
///  canvas.add(image)
///  ````
public struct C4Checkerboard : C4Generator {
    ///The name of the Core Image filter.
    public let filterName = "CICheckerboardGenerator"
    ///The colors of the checkerboard. Defaults to: [C4Pink, C4Blue]
    public var colors: [C4Color] = [C4Pink, C4Blue]
    ///The center of the pattern. Defaults to {0,0}
    public var center: C4Point = C4Point()
    ///The sharpness of the pattern's edges. Defaults to 1.0
    public var sharpness: Double = 1
    ///The width of the pattern's segments. Defaults to 5.0
    public var width: Double = 5.0

    ///Initializes a new filter
    public init() {}

    ///Applies the properties of the receiver to create a new CIFilter object
    public func createCoreImageFilter() -> CIFilter {
        let filter = CIFilter(name: filterName)!
        filter.setDefaults()
        filter.setValue(CIColor(colors[0]), forKey:"inputColor0")
        filter.setValue(CIColor(colors[1]), forKey:"inputColor1")
        filter.setValue(width, forKey: "inputWidth")
        filter.setValue(CIVector(CGPoint: CGPoint(center)), forKey:"inputCenter")
        filter.setValue(sharpness, forKey: "inputSharpness")
        return filter
    }
}