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

///  A structure of 4 8-bit values that represent r, g, b, a values of a single point (i.e. a pixel)
public struct Pixel {
    var r: UInt8 = 0
    var g: UInt8 = 0
    var b: UInt8 = 0
    var a: UInt8 = 255

    ///  Initializes a pixel whose color is a specified gray.
    ///
    /// - parameter gray: the gray color of the pixel
    public init(gray: Int) {
        self.init(gray, gray, gray, 255)
    }

    ///  Initializes a Pixel structure
    ///
    ///  ````
    ///  let p = Pixel(255, 255, 255, 255) // -> white
    ///  ````
    ///
    ///  Values are calculated from 0...255
    ///
    /// - parameter r: the red component
    /// - parameter g: the green component
    /// - parameter b: the blue component
    /// - parameter a: the alpha component
    public init(_ r: Int, _ g: Int, _ b: Int, _ a: Int) {
        self.r = UInt8(r)
        self.g = UInt8(g)
        self.b = UInt8(b)
        self.a = UInt8(a)
    }

    public init(_ color: Color) {
        let rgba: [Int] = color.components.map({ Int($0 * 255.0) })
        self.init(rgba[0], rgba[1], rgba[2], rgba[3])
    }
}
