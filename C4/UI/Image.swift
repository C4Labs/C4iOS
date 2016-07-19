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

///  A structure of 4 8-bit values that represent r,g,b,a values of a single point (i.e. a pixel)
public struct Pixel {
    var r : UInt8 = 0
    var g : UInt8 = 0
    var b : UInt8 = 0
    var a : UInt8 = 255

    ///  Initializes a pixel whose color is a specified gray.
    ///
    ///  - parameter gray: the gray color of the pixel
    public init(gray: Int) {
        self.init(gray,gray,gray,255)
    }

    ///  Initializes a Pixel structure
    ///
    ///  ````
    ///  let p = Pixel(255,255,255,255) // -> white
    ///  ````
    ///
    ///  Values are calculated from 0...255
    ///
    ///  - parameter r: the red component
    ///  - parameter g: the green component
    ///  - parameter b: the blue component
    ///  - parameter a: the alpha component
    public init(_ r : Int, _ g: Int, _ b: Int, _ a: UInt8) {
        self.r = UInt8(r)
        self.g = UInt8(g)
        self.b = UInt8(b)
        self.a = UInt8(a)
    }
}

/// A Image provides a view-based container for displaying a single image. You can create images from files, from other image objects, or from raw image data you receive.
public class Image: View {

    //MARK: Initializers
    
    /// Initializes a new Image using the specified filename from the bundle (i.e. your project), it will also grab images
    /// from the web if the filename starts with http.
    ///
    /// ````
    /// let img = Image("logo")
    /// canvas.add(img)
    /// ````
    ///
    /// - parameter name:	The name of the image included in your project, or a web address.
    convenience public init?(_ name: String) {
        guard let image = NativeImage(named: name) else {
            return nil
        }
        self.init(nativeImage: image)
    }

    #if os(iOS)
    /// Initializes a new Image using the specified filename from the bundle (i.e. your project), it will also grab images
    /// from the web if the filename starts with http.
    ///
    /// ````
    /// let img = Image("http://www.c4ios.com/images/logo@2x.png", scale: 2.0)
    /// canvas.add(img)
    /// ````
    ///
    /// - parameter name:	The name of the image included in your project, or a web address.
    convenience public init?(_ name: String, scale: Double) {
        guard let image = NativeImage(named: name) else {
            return nil
        }
        self.init(nativeImage: image, scale: scale)
    }
    #endif
    
    /// Initializes a new Image using an existing Image (basically like copying).
    ///
    /// ````
    /// let a = Image("logo")
    /// canvas.add(a)
    /// let b = Image(image: a)
    /// b.center = canvas.center
    /// canvas.add(b)
    /// ````
    ///
    /// - parameter image: A Image.
    convenience public init(image: Image) {
        self.init()
        let nativeImage = image.nativeImage
        self.view = NativeImageView(image: nativeImage)
    }

    /// Initializes a new Image using a NativeImage.
    ///
    /// ````
    /// if let uii = UIImage(named:"logo") {
    ///     let img = Image(nativeImage: uii)
    ///     canvas.add(img)
    /// }
    /// ````
    ///
    /// - parameter nativeImage: A NativeImage object.
    convenience public init(nativeImage: NativeImage) {
        self.init()
        self.view = NativeImageView(image: nativeImage)
        _originalSize = Size(view.frame.size)
    }

    #if os(iOS)
    /// Initializes a new Image using a NativeImage, with option for specifying the scale of the image.
    ///
    /// ````
    /// if let uii = UIImage(named:"logo") {
    ///     let img = Image(nativeImage: uii, scale: 2.0)
    ///     canvas.add(img)
    /// }
    /// ````
    ///
    /// - parameter nativeImage: A NativeImage object.
    /// - parameter scale: A `Double` should be larger than 0.0
    convenience public init(nativeImage: NativeImage, let scale: Double) {
        self.init()
        
        if scale != 1.0 {
            let scaledImage = NativeImage(CGImage: nativeImage.CGImage!, scale: CGFloat(scale), orientation: nativeImage.imageOrientation)

            self.view = NativeImageView(image: scaledImage)
        } else {
            self.view = NativeImageView(image: nativeImage)
        }
        _originalSize = Size(view.frame.size)
    }
    #endif

    /// Initializes a new Image using a CGImageRef.
    ///
    /// ````
    /// let cgi = CGImageCreate()
    /// let img = Image(cgimage: cgi)
    /// canvas.add(img)
    /// ````
    ///
    /// [Example](https://gist.github.com/Framework/06319d420426cb0f1cb3)
    ///
    /// - parameter cgimage: A CGImageRef object.
    convenience public init(cgimage: CGImageRef) {
        let image = NativeImage(CGImage: cgimage)
        self.init(nativeImage: image)
    }

    #if os(iOS)
    /// Initializes a new Image using a CGImageRef, with option for specifying the scale of the image.
    ///
    /// ````
    /// let cgi = CGImageCreate()
    /// let img = Image(cgimage: cgi, scale: 2.0)
    /// canvas.add(img)
    /// ````
    ///
    /// - parameter nativeImage: A CGImageRef object.
    convenience public init(cgimage: CGImageRef, scale: Double) {
        let image = NativeImage(CGImage: cgimage)
        self.init(nativeImage: image, scale: scale)
    }
    #endif

    /// Initializes a new Image using a CIImage.
    ///
    /// Use this method if you're working with the output of a CIFilter.
    ///
    /// - parameter ciimage: A CIImage object.
    convenience public init(ciimage: CIImage) {
        let image = NativeImage(CIImage: ciimage)
        self.init(nativeImage: image)
    }

    #if os(iOS)
    /// Initializes a new Image using a CIImage, with option for specifying the scale of the image.
    ///
    /// Use this method if you're working with the output of a CIFilter.
    ///
    /// - parameter ciimage: A CIImage object.
    convenience public init(ciimage: CIImage, scale: Double) {
        let image = NativeImage(CIImage: ciimage)
        self.init(nativeImage: image, scale: scale)
    }
    #endif

    /// Initializes a new Image using raw data.
    ///
    /// Use this if you download an image as data you can pass it here to create an image.
    ///
    /// See the body of init(url:) to see how to download an image as data.
    ///
    /// - parameter data: An NSData object.
    convenience public init(data: NSData) {
        let image = NativeImage(data: data)
        self.init(nativeImage: image!)
    }

    #if os(iOS)
    /// Initializes a new Image using raw data, with option for specifying the scale of the image.
    ///
    /// Use this if you download an image as data you can pass it here to create an image.
    ///
    /// See the body of init(url:) to see how to download an image as data.
    ///
    /// - parameter data: An NSData object.
    convenience public init(data: NSData, scale: Double) {
        let image = NativeImage(data: data)
        self.init(nativeImage: image!, scale: scale)
    }
    #endif

    /// Initializes a new Image from an URL.
    ///
    /// ````
    ///  if let url = NSURL(string: "http://www.c4ios.com/images/logo@2x.png") {
    ///      let img = Image(url: url)
    ///      canvas.add(img)
    /// }
    /// ````
    ///
    /// - parameter url: An NSURL object.
    convenience public init(url: NSURL) {
        var error: NSError?
        var data: NSData?
        do {
            data = try NSData(contentsOfURL: url, options:.DataReadingMappedIfSafe)
        } catch let error1 as NSError {
            error = error1
            data = nil
        }
        if let d = data {
            self.init(data: d)
            return
        }
        if let e = error {
            C4Log("There was an error loading image data from url:\n ERROR: \(e.localizedDescription)\n URL:\(url)")
        }
        self.init()
    }

    #if os(iOS)
    /// Initializes a new Image from an URL, with option for specifying the scale of the image.
    ///
    /// ````
    /// if let url = NSURL(string: "http://www.c4ios.com/images/logo@2x.png") {
    ///     let img = Image(url: url, scale: 2.0)
    ///     canvas.add(img)
    /// }
    /// ````
    ///
    /// - parameter url: An NSURL object.
    convenience public init(url: NSURL, scale: Double) {
        var error: NSError?
        var data: NSData?
        do {
            data = try NSData(contentsOfURL: url, options:.DataReadingMappedIfSafe)
        } catch let error1 as NSError {
            error = error1
            data = nil
        }
        if let d = data {
            self.init(data: d, scale: scale)
            return
        }
        if let e = error {
            C4Log("There was an error loading image data from url:\n ERROR: \(e.localizedDescription)\n URL:\(url)")
        }
        self.init()
    }
    #endif

    /// Initializes a new Image using raw data. This method differs from `Image(data:...)` in that you can pass an array of
    /// raw data to the initializer. This works if you're creating your own raw images by changing the values of individual
    /// pixels. Pixel data should be RGBA.
    ///
    /// - parameter rawData: An array of raw pixel data.
    /// - parameter size: The size {w,h} of the image you're creating based on the pixel array.
    convenience public init(pixels: [Pixel], size: Size) {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo:CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        let bitsPerComponent:Int = 8
        let bitsPerPixel:Int = 32
        let width : Int = Int(size.width)
        let height : Int = Int(size.height)
        
        assert(pixels.count == Int(width * height))
        
        var data = pixels // Copy to mutable []
        let providerRef = CGDataProviderCreateWithCFData(
            NSData(bytes: &data, length: data.count * sizeof(Pixel))
        )
        
        let cgim = CGImageCreate(
            width,
            height,
            bitsPerComponent,
            bitsPerPixel,
            width * Int(sizeof(Pixel)),
            rgbColorSpace,
            bitmapInfo,
            providerRef,
            nil,
            true,
            CGColorRenderingIntent.RenderingIntentDefault
        )
        
        self.init(cgimage: cgim!)
    }
    
    //MARK: Properties
    
    /// Returns the NativeImageView of the object.
    ///
    /// - returns: A NativeImageView object.
    internal var imageView : NativeImageView {
        get {
            return self.view as! NativeImageView
        }
    }
    
    /// Returns a NativeImage representation of the receiver.
    ///
    /// - returns:	A NativeImage object.
    public var nativeImage: NativeImage {
        get {
            return imageView.image!
        }
    }
    
    /// Returns a CGImageRef representation of the receiver.
    ///
    /// - returns:	A CGImageRef object.
    public var cgimage: CGImageRef {
        get {
            return nativeImage.CGImage!
        }
    }
    
    /// Returns a CIImage representation of the receiver. Generally, this would be used to work with filters.
    ///
    /// - returns:	A CIImage object.
    public var ciimage: CIImage {
        get {
            return CIImage(CGImage: cgimage)
        }
    }
    
    /// An object that provides the contents of the layer. Animatable.
    /// The default value of this property is nil.
    /// If you are using the layer to display a static image, you can set this property to the CGImageRef containing the image
    /// you want to display. Assigning a value to this property causes the layer to use your image rather than create a
    /// separate backing store.
    /// If the layer object is tied to a view object, you should avoid setting the contents of this property directly. The
    /// interplay between views and layers usually results in the view replacing the contents of this property during a
    /// subsequent update.
    public var contents : CGImageRef? {
        get {
            let layer = imageView.mainLayer
            return layer?.contents as! CGImageRef?
        }
        set {
            imageView.mainLayer?.contents = newValue
        }
    }
    
    /// A variable that provides access to the width of the receiver. Animatable.
    /// The default value of this property is defined by the image being created.
    /// Assigning a value to this property causes the receiver to change the width of its frame. If the receiver's
    /// `contrainsProportions` variable is set to `true` the receiver's height will change to match the new width.
    public override var width : Double {
        get {
            return Double(view.frame.size.width)
        } set(val) {
            var newSize = Size(val,Double(view.frame.size.height))
            if constrainsProportions {
                let ratio = Double(self.size.height / self.size.width)
                newSize.height = val * ratio
            }
            var rect = self.frame
            rect.size = newSize
            self.frame = rect
        }
    }
    
    /// A variable that provides access to the height of the receiver. Animatable.
    /// The default value of this property is defined by the image being created.
    /// Assigning a value to this property causes the receiver to change the height of its frame. If the receiver's
    /// `contrainsProportions` variable is set to `true` the receiver's width will change to match the new width.
    public override var height : Double {
        get {
            return Double(view.frame.size.height)
        } set(val) {
            var newSize = Size(Double(view.frame.size.width),val)
            if constrainsProportions {
                let ratio = Double(self.size.width / self.size.height)
                newSize.width = val * ratio
            }
            var rect = self.frame
            rect.size = newSize
            self.frame = rect
        }
    }
    
    
    /// Assigning a value of true to this property will cause the receiver to scale its entire frame whenever its `width` or
    /// `height` variables are set.
    /// The default value of this property is `false`.
    public var constrainsProportions : Bool = false
    
    internal var _originalSize : Size = Size()
    /// The original size of the receiver when it was initialized.
    public var originalSize : Size {
        get {
            return _originalSize
        }
    }
    
    /// The original width/height ratio of the receiver when it was initialized.
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