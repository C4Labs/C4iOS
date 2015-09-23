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
#if os(iOS)
import UIKit
#elseif os(OSX)
import AppKit
#endif

extension C4Image {
    public func apply(filter: C4Filter) {
        self.apply(filters:[filter])
    }
    
    public func apply(filters filters: [C4Filter]) {
        for filter in filters {
            let cifilter = filter.createCoreImageFilter(output)
            if let outputImage = cifilter.outputImage {
                self.output = outputImage
            } else {
                print("Failed ot generate outputImage: \(__FUNCTION__)")
            }
        }
        self.renderFilteredImage()
    }
    
    public func renderFilteredImage() {
        var extent = self.output.extent
        if CGRectIsInfinite(extent) {
            extent = self.ciimage.extent
        }
        #if os(iOS)
            let filterContext = CIContext(options:nil)
        #elseif os(OSX)
            let cgcontext = NSGraphicsContext().CGContext
            let filterContext = CIContext(CGContext: cgcontext, options: nil)
        #endif

        let filteredImage = filterContext.createCGImage(self.output, fromRect:extent)
        
        dispatch_async(dispatch_get_main_queue()) {
            self.imageView.mainLayer?.contents = filteredImage
        }
    }
    
}