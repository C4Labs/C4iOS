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

import QuartzCore
import UIKit

extension Image {
    ///  Crops the receiver's contents to the specified frame within the receiver's coordinate space.
    ///
    /// - parameter rect: a Rect
    public func crop(_ rect: Rect) {
        let intersection = CGRect(rect).intersection(CGRect(self.bounds))
        if intersection.isNull { return }
        let inputRectangle = CGRect(
            x: intersection.origin.x,
            y: CGFloat(self.height) - intersection.origin.y - intersection.size.height,
            width: intersection.size.width,
            height: intersection.size.height)

        let crop = CIFilter(name: "CICrop")!
        crop.setDefaults()
        crop.setValue(CIVector(cgRect: inputRectangle), forKey: "inputRectangle")
        crop.setValue(ciImage, forKey: "inputImage")

        if let outputImage = crop.outputImage {
            self.output = outputImage
            self.imageView.image = UIImage(ciImage: output)
            self.frame = Rect(intersection)
        } else {
            print("Failed ot generate outputImage: \(#function)")
        }
    }
}
