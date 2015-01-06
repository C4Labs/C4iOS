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

public class C4Image: C4View {
//MARK: Initializers
    convenience public init(_ filename: String) {
        if filename.hasPrefix("http") {
            self.init(url: NSURL(string: filename)!)
            return
        }
        let image = UIImage(named: filename, inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
        self.init(uiimage: image!)
    }
    
    convenience public init(image: C4Image) {
        self.init()
        self.view = image.view
    }
    
    convenience public init(uiimage: UIImage) {
        self.init()
        self.view = UIImageView(image: uiimage)
        _originalSize = C4Size(view.frame.size)
    }
    
    convenience public init(cgimage: CGImageRef) {
        let image = UIImage(CGImage: cgimage)
        self.init(uiimage: image!)
    }
    
    convenience public init(ciimage: CIImage) {
        let image = UIImage(CIImage: ciimage)
        self.init(uiimage: image!)
    }
    
    convenience public init(data: NSData) {
        let image = UIImage(data: data)
        self.init(uiimage: image!)
    }
    
    convenience public init(url: NSURL) {
        var error: NSError?
        var data = NSData(contentsOfURL: url, options:.DataReadingMappedIfSafe, error: &error)
        if let d = data {
            self.init(data: d)
            return
        }
        if let e = error {
            C4Log("There was an error loading image data from url:\n ERROR: \(e.localizedDescription)\n URL:\(url)")
        }
        self.init()
    }
    
    convenience public init(rawData: Void, size: C4Size) {
        let colorspace = CGColorSpaceCreateDeviceRGB()
        let bitsPerComponent = 8
        
        var data: Void = rawData
        var context = withUnsafeMutablePointer(&data) { (pointer: UnsafeMutablePointer<Void>) -> (CGContext) in
            
            let alphaInfo = CGBitmapInfo(CGImageAlphaInfo.PremultipliedLast.rawValue)
            let orderInfo = CGBitmapInfo.ByteOrder32Big
            let info = alphaInfo | orderInfo
            return CGBitmapContextCreate(pointer, UInt(size.width), UInt(size.height), 8, UInt(4*size.width), colorspace, info)
        }
        
        let image = CGBitmapContextCreateImage(context)
        self.init(cgimage: image)
    }
    
//MARK: Properties
    internal var imageView : UIImageView {
        get {
            return self.view as UIImageView
        }
    }
    
    public var uiimage: UIImage {
        get {
            return imageView.image!
        }
    }
    
    //creates CGImage when accessed
    var cgimage: CGImageRef {
        get {
            return uiimage.CGImage
        }
    }
    
    //creates CIImage when accessed
    var ciimage: CIImage {
        get {
            return CIImage(CGImage: cgimage)
        }
    }
    
    //returns current image view layer's contents
    var contents : CGImageRef {
        get {
            let layer = imageView.layer as CALayer
            return layer.contents as CGImageRef
        } set(val) {
            imageView.layer.contents = val
        }
    }
    
    public override var width : Double {
        get {
            return Double(view.frame.size.width)
        } set(val) {
            var newSize = C4Size(val,Double(view.frame.size.height))
            if constrainsProportions {
                let ratio = Double(self.size.height / self.size.width)
                newSize.height = val * ratio
            }
            var rect = self.frame
            rect.size = newSize
            self.frame = rect
        }
    }

    public override var height : Double {
        get {
            return Double(view.frame.size.height)
        } set(val) {
            var newSize = C4Size(Double(view.frame.size.width),val)
            if constrainsProportions {
                let ratio = Double(self.size.width / self.size.height)
                newSize.width = val * ratio
            }
            var rect = self.frame
            rect.size = newSize
            self.frame = rect
        }
    }

    public var constrainsProportions : Bool = false
    
    internal var _originalSize : C4Size = C4Size()
    public var originalSize : C4Size {
        get {
            return _originalSize
        }
    }

    public var originalRatio : Double {
        get {
            return _originalSize.width / _originalSize.height
        }
    }
    
    //MARK: Filters
    lazy internal var output: CIImage = self.ciimage
    lazy internal var filterQueue: dispatch_queue_t = {
        return dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)
    }()
    lazy internal var renderImmediately = true

}