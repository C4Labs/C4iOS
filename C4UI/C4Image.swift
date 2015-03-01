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
    /**
    Initializes a new C4Image using the specified filename from the bundle (i.e. your project), it will also grab images from the web if the filename starts with http.

    :param: name	The name of the image included in your project, or a web address.
    */
    convenience public init(_ filename: String) {
        if filename.hasPrefix("http") {
            self.init(url: NSURL(string: filename)!)
            return
        }
        let image = UIImage(named: filename, inBundle: NSBundle.mainBundle(), compatibleWithTraitCollection: nil)
        self.init(uiimage: image!)
    }
    
    /**
    Initializes a new C4Image using an existing C4Image (basically like copying).
    
    :param: image A C4Image.
    */
    convenience public init(image: C4Image) {
        self.init()
        self.view = image.view
    }
    
    /**
    Initializes a new C4Image using a UIImage.
    
    :param: uiimage A UIImage object.
    */
    convenience public init(uiimage: UIImage) {
        self.init()
        self.view = UIImageView(image: uiimage)
        _originalSize = C4Size(view.frame.size)
    }
    
    /**
    Initializes a new C4Image using a CGImageRef.
    
    :param: uiimage A CGImageRef object.
    */
    convenience public init(cgimage: CGImageRef) {
        let image = UIImage(CGImage: cgimage)
        self.init(uiimage: image!)
    }
    
    /**
    Initializes a new C4Image using a CIImage.
    
    :param: uiimage A CIImage object.
    */
    convenience public init(ciimage: CIImage) {
        let image = UIImage(CIImage: ciimage)
        self.init(uiimage: image!)
    }
    
    /**
    Initializes a new C4Image using raw data (for example, if you download an image as data you can pass it here to create an image).
    
    :param: data An NSData object.
    */
    convenience public init(data: NSData) {
        let image = UIImage(data: data)
        self.init(uiimage: image!)
    }
    
    /**
    Initializes a new C4Image from an URL.
    
    :param: url An NSURL object.
    */
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
    
    /**
    Initializes a new C4Image using raw data. This method differs from `C4Image(data:...)` in that you can pass an array of raw data to the initializer. This works if you're creating your own raw images by changing the values of individual pixels. Pixel data should be RGBA.
    
    :param: rawData An array of raw pixel data.
    :param: size The size {w,h} of the image you're creating based on the pixel array.
    */
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
    /**
    Returns the UIImageView of the object.
    :returns: A UIImageView object.
    */
    internal var imageView : UIImageView {
        get {
            return self.view as UIImageView
        }
    }
    
    /**
    Returns a UIImage representation of the receiver.
    :returns:	A UIImage object.
    */
    public var uiimage: UIImage {
        get {
            return imageView.image!
        }
    }
    
    /**
    Returns a CGImageRef representation of the receiver.
    :returns:	A CGImageRef object.
    */
    var cgimage: CGImageRef {
        get {
            return uiimage.CGImage
        }
    }
    
    /**
    Returns a CIImage representation of the receiver. Generally, this would be used to work with filters.
    :returns:	A CIImage object.
    */
    var ciimage: CIImage {
        get {
            return CIImage(CGImage: cgimage)
        }
    }
    
    /**
    An object that provides the contents of the layer. Animatable.
    The default value of this property is nil.
    If you are using the layer to display a static image, you can set this property to the CGImageRef containing the image you want to display. Assigning a value to this property causes the layer to use your image rather than create a separate backing store.
    If the layer object is tied to a view object, you should avoid setting the contents of this property directly. The interplay between views and layers usually results in the view replacing the contents of this property during a subsequent update.
    */
    var contents : CGImageRef {
        get {
            let layer = imageView.layer as CALayer
            return layer.contents as CGImageRef
        } set(val) {
            imageView.layer.contents = val
        }
    }
    
    /**
    A variable that provides access to the width of the receiver. Animatable.
    The default value of this property is defined by the image being created.
    Assigning a value to this property causes the receiver to change the width of its frame. If the receiver's `contrainsProportions` variable is set to `true` the receiver's height will change to match the new width.
    */
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

    /**
    A variable that provides access to the height of the receiver. Animatable.
    The default value of this property is defined by the image being created.
    Assigning a value to this property causes the receiver to change the height of its frame. If the receiver's `contrainsProportions` variable is set to `true` the receiver's width will change to match the new width.
    */
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

    /**
    Assigning a value of true to this property will cause the receiver to scale its entire frame whenever its `width` or `height` variables are set.
    The default value of this property is `false`.
    */
    public var constrainsProportions : Bool = false
    
    /**
    The original size of the receiver when it was initialized.
    */
    internal var _originalSize : C4Size = C4Size()
    public var originalSize : C4Size {
        get {
            return _originalSize
        }
    }

    /**
    The original width/height ratio of the receiver when it was initialized.
    */
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