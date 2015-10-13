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

extension C4Image {
    ///  Crops the receiver's contents to the specified frame within the receiver's coordinate space.
    ///
    ///  - parameter rect: a C4Rect
    public func crop(rect: C4Rect) {
        let intersection = CGRectIntersection(CGRect(rect),CGRect(self.bounds))
        if(CGRectIsNull(intersection)) { return }
        
        
        let inputRectangle = CGRectMake(
            intersection.origin.x,
            CGFloat(self.height) - intersection.origin.y - intersection.size.height,
            intersection.size.width,
            intersection.size.height)

        let crop = CIFilter(name: "CICrop")!
        crop.setDefaults()
        crop.setValue(CIVector(CGRect: inputRectangle), forKey: "inputRectangle")
        crop.setValue(ciimage, forKey: "inputImage")

        if let outputImage = crop.outputImage {
            self.output = outputImage
            self.imageView.image = UIImage(CIImage: output)
            self.frame = C4Rect(intersection)
        } else {
            print("Failed ot generate outputImage: \(__FUNCTION__)")
        }
    }
}