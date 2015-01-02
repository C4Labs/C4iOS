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
import C4Core

extension C4Image {
    public class func availableFilters() -> [AnyObject] {
        let categories = [
            kCICategoryDistortionEffect,
            kCICategoryGeometryAdjustment,
            kCICategoryCompositeOperation,
            kCICategoryHalftoneEffect,
            kCICategoryColorAdjustment,
            kCICategoryColorEffect,
            kCICategoryTransition,
            kCICategoryTileEffect,
            kCICategoryGenerator,
            kCICategoryReduction,
            kCICategoryGradient,
            kCICategoryStylize,
            kCICategorySharpen,
            kCICategoryBlur,
            //kCICategoryVideo,
            kCICategoryStillImage,
            //kCICategoryInterlaced,
            kCICategoryNonSquarePixels,
            kCICategoryHighDynamicRange,
            kCICategoryBuiltIn
        ]
        
        var set = NSMutableSet()
        
        for category in categories {
            let filterNames = CIFilter.filterNamesInCategory(category)
            set.addObjectsFromArray(filterNames)
        }
        
        var arr = set.allObjects
        
        let sorted = arr.sorted { (p1, p2) -> Bool in
            (p1 as? String) < (p2 as? String)
        }
        
        return sorted
    }
    
    internal func prepareFilter(name: String) -> CIFilter {
        var filter = CIFilter(name: name)
        filter.setDefaults()
        
        if self.outputReady {
            filter.setValue(self.output, forKey: "inputImage")
        } else {
            filter.setValue(self.ciimage, forKey: "inputImage")
            self.outputReady = true
        }
        return filter
    }
    
    internal func renderImage(filterName: String) {
        dispatch_async(filterQueue) {
            var extent = self.output.extent()
            if CGRectIsInfinite(extent) {
                extent = self.ciimage.extent()
            }
            let filterContext = CIContext(options:nil)
            let filteredImage = filterContext.createCGImage(self.output, fromRect:extent)
            dispatch_async(dispatch_get_main_queue()) {
                self.contents = filteredImage
                self.post(filterName+"Complete")
            }
        }
    }
    
    public func startFiltering() {
        renderImmediately = false
    }
    
    public func endFiltering() {
        renderImmediately = true
        renderImage("MultipleFilters")
    }
}