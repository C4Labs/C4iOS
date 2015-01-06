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

import C4Core

public struct C4LinearGradient : C4Generator {
    public let filterName = "CISmoothLinearGradient"
    public var colors: [C4Color] = [C4Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0),C4Color(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)]
    public var points: [C4Point] = [C4Point(),C4Point(1,1)]
    public init() {}
    public func createCoreImageFilter() -> CIFilter {
        let filter = CIFilter(name: filterName)
        filter.setDefaults()
        filter.setValue(CIColor(colors[0]), forKey:"inputColor0")
        filter.setValue(CIColor(colors[1]), forKey:"inputColor1")
        filter.setValue(CIVector(CGPoint: CGPoint(points[0])), forKey:"inputPoint0")
        filter.setValue(CIVector(CGPoint: CGPoint(points[1])), forKey:"inputPoint1")
        return filter
    }
}