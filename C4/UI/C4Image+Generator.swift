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
    ///  Applies a generator to the receiver's contents.
    ///
    ///  - parameter generator: a C4Generator
    public func generate(generator: C4Generator) {
        let crop = CIFilter(name: "CICrop")!
        crop.setDefaults()
        crop.setValue(CIVector(CGRect:CGRect(self.bounds)), forKey: "inputRectangle")
        let generatorFilter = generator.createCoreImageFilter()
        crop.setValue(generatorFilter.outputImage, forKey: "inputImage")

        if var outputImage = crop.outputImage {
            let scale = CGAffineTransformMakeScale(1, -1)
            let translate = CGAffineTransformTranslate(scale, 0, outputImage.extent.size.height)
            outputImage = outputImage.imageByApplyingTransform(translate)
            self.output = outputImage
            
            let img = UIImage(CIImage: output)
            let orig = self.origin
            self.view = UIImageView(image: img)
            self.origin = orig
            _originalSize = C4Size(view.frame.size)
        } else {
            print("Failed to generate outputImage: \(__FUNCTION__)")
        }
    }
}