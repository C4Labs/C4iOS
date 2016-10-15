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

import UIKit

/// A Image provides a view-based container for displaying a single image. You can create images from files, from other image objects, or from raw image data you receive.
public class Image: View, NSCopying {
    internal class ImageView: UIImageView {
        var imageLayer: ImageLayer {
            return self.layer as! ImageLayer // swiftlint:disable:this force_cast
        }

        override class var layerClass: AnyClass {
            return ImageLayer.self
        }
    }

    /// Shape's contents are drawn on a ShapeLayer.
    public var imageLayer: ImageLayer {
        get {
            return self.imageView.imageLayer
        }
    }

    //MARK: Initializers

    /// Initializes an empty Image
    public override init() {
        super.init()
        let uiimage = UIImage()
        self.view = ImageView(image: uiimage)
    }

    public override init(frame: Rect) {
        super.init(frame: frame)
        let uiimage = UIImage()
        let imageView = ImageView(image: uiimage)
        imageView.frame = self.view.bounds
        self.view = imageView
    }

    /// Initializes a new Image using the specified filename from the bundle (i.e. your project), it will also grab images
    /// from the web if the filename starts with http.
    /// ````
    /// let img = Image("logo")
    /// canvas.add(img)
    /// ````
    /// - parameter name:	The name of the image included in your project, or a web address.
    convenience public init?(_ name: String) {
        self.init(name, scale: 1.0)
    }

    /// Initializes a new Image using the specified filename from the bundle (i.e. your project), it will also grab images
    /// from the web if the filename starts with http.
    /// ````
    /// let img = Image("http://www.c4ios.com/images/logo@2x.png", scale: 2.0)
    /// canvas.add(img)
    /// ````
    /// - parameter name:	The name of the image included in your project, or a web address.
    convenience public init?(_ name: String, scale: Double) {
        guard let image = UIImage(named: name) else {
            return nil
        }
        self.init(uiimage: image, scale: scale)
    }

    /// Initializes a new Image using an existing Image (basically like copying).
    /// ````
    /// let a = Image("logo")
    /// canvas.add(a)
    /// let b = Image(image: a)
    /// b.center = canvas.center
    /// canvas.add(b)
    /// ````
    /// - parameter image: A Image.
    convenience public init(copy image: Image) {
        self.init()
        let uiimage = image.uiimage
        self.view = ImageView(image: uiimage)
        copyViewStyle(image)
    }

    /// Initializes a new Image using a UIImage.
    /// ````
    /// if let uii = UIImage(named:"logo") {
    ///     let img = Image(uiimage: uii)
    ///     canvas.add(img)
    /// }
    /// ````
    /// - parameter uiimage: A UIImage object.
    convenience public init(uiimage: UIImage) {
        self.init(uiimage: uiimage, scale: 1.0)
    }

    /// Initializes a new Image using a UIImage, with option for specifying the scale of the image.
    /// ````
    /// if let uii = UIImage(named:"logo") {
    ///     let img = Image(uiimage: uii, scale: 2.0)
    ///     canvas.add(img)
    /// }
    /// ````
    /// - parameter uiimage: A UIImage object.
    /// - parameter scale: A `Double` should be larger than 0.0
    convenience public init(uiimage: UIImage, scale: Double) {
        self.init()

        if scale != 1.0 {
            let scaledImage = UIImage(cgImage: uiimage.cgImage!, scale: CGFloat(scale), orientation: uiimage.imageOrientation)
            self.view = ImageView(image: scaledImage)
        } else {
            self.view = ImageView(image: uiimage)
        }
        _originalSize = Size(view.frame.size)
    }

    /// Initializes a new Image using a CGImageRef.
    /// ````
    /// let cgi = CGImageCreate()
    /// let img = Image(cgimage: cgi)
    /// canvas.add(img)
    /// ````
    /// [Example](https://gist.github.com/C4Framework/06319d420426cb0f1cb3)
    /// - parameter cgimage: A CGImageRef object.
    convenience public init(cgimage: CGImage) {
        let image = UIImage(cgImage: cgimage)
        self.init(uiimage: image, scale: 1.0)
    }

    /// Initializes a new Image using a CGImageRef, with option for specifying the scale of the image.
    /// ````
    /// let cgi = CGImageCreate()
    /// let img = Image(cgimage: cgi, scale: 2.0)
    /// canvas.add(img)
    /// ````
    /// - parameter cgimage: A CGImageRef object.
    /// - parameter scale: The scale of the image.
    convenience public init(cgimage: CGImage, scale: Double) {
        let image = UIImage(cgImage: cgimage)
        self.init(uiimage: image, scale: scale)
    }

    /// Initializes a new Image using a CIImage.
    /// Use this method if you're working with the output of a CIFilter.
    /// - parameter ciimage: A CIImage object.
    convenience public init(ciimage: CIImage) {
        self.init(ciimage: ciimage, scale: 1.0)
    }

    /// Initializes a new Image using a CIImage, with option for specifying the scale of the image.
    /// Use this method if you're working with the output of a CIFilter.
    /// - parameter ciimage: A CIImage object.
    /// - parameter scale: The scale of the image.
    convenience public init(ciimage: CIImage, scale: Double) {
        let image = UIImage(ciImage: ciimage)
        self.init(uiimage: image, scale: scale)
    }

    /// Initializes a new Image using raw data.
    /// Use this if you download an image as data you can pass it here to create an image.
    /// See the body of init(url:) to see how to download an image as data.
    /// - parameter data: An NSData object.
    convenience public init(data: Data) {
        self.init(data: data, scale: 1.0)
    }

    /// Initializes a new Image using raw data, with option for specifying the scale of the image.
    /// Use this if you download an image as data you can pass it here to create an image.
    /// See the body of init(url:) to see how to download an image as data.
    /// - parameter data: An NSData object.
    /// - parameter scale: The scale of the image.
    convenience public init(data: Data, scale: Double) {
        let image = UIImage(data: data)
        self.init(uiimage: image!, scale: scale)
    }

    /// Initializes a new Image from an URL.
    /// ````
    ///  if let url = NSURL(string: "http://www.c4ios.com/images/logo@2x.png") {
    ///      let img = Image(url: url)
    ///      canvas.add(img)
    /// }
    /// ````
    /// - parameter url: An NSURL object.
    convenience public init(url: URL) {
        self.init(url: url, scale: 1.0)
    }

    /// Initializes a new Image from an URL, with option for specifying the scale of the image.
    /// ````
    /// if let url = NSURL(string: "http://www.c4ios.com/images/logo@2x.png") {
    ///     let img = Image(url: url, scale: 2.0)
    ///     canvas.add(img)
    /// }
    /// ````
    /// - parameter url: An NSURL object.
    /// - parameter scale: The scale of the image.
    convenience public init(url: URL, scale: Double) {
        var error: NSError?
        var data: Data?
        do {
            data = try Data(contentsOf: url, options: NSData.ReadingOptions.mappedIfSafe)
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

    /// Initializes a new Image using raw data. This method differs from `Image(data:...)` in that you can pass an array of
    /// raw data to the initializer. This works if you're creating your own raw images by changing the values of individual
    /// pixels. Pixel data should be RGBA.
    /// - parameter pixels: An array of raw pixel data.
    /// - parameter size: The size {w, h} of the image you're creating based on the pixel array.
    convenience public init(pixels: [Pixel], size: Size) {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let bitsPerComponent: Int = 8
        let bitsPerPixel: Int = 32
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)

        assert(pixels.count == Int(width * height))

        var provider: CGDataProvider? = nil
        pixels.withUnsafeBufferPointer { p in
            if let address = p.baseAddress {
                let data = Data(bytes: UnsafePointer(address), count: pixels.count * MemoryLayout<Pixel>.size)
                provider = CGDataProvider(data: data as CFData)
            }
        }

        let cgim = CGImage(
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bitsPerPixel: bitsPerPixel,
            bytesPerRow: width * Int(MemoryLayout<Pixel>.size),
            space: rgbColorSpace,
            bitmapInfo: bitmapInfo,
            provider: provider!,
            decode: nil,
            shouldInterpolate: true,
            intent: CGColorRenderingIntent.defaultIntent
        )

        self.init(cgimage: cgim!)
    }

    /// Initializes a new Image using another image.
    /// - parameter c4image: An Image around which the new image is created.
    convenience public init(c4image: Image) {
        let cgim = c4image.cgImage
        self.init(cgimage: cgim, scale: c4image.scale)
    }

    /// Initializes a new copy of the receiver.
    /// - parameter zone: This parameter is ignored. Memory zones are no longer used by Objective-C.
    /// - returns: a new instance that’s a copy of the receiver.
    public func copy(with zone: NSZone? = nil) -> Any {
        let uiimage = UIImage(cgImage: self.contents)
        let img = Image(uiimage: uiimage, scale: scale)
        img.frame = self.frame
        img.constrainsProportions = self.constrainsProportions
        img._originalSize = _originalSize
        return img
    }

    //MARK: Properties

    /// Returns the UIImageView of the object.
    /// - returns: A UIImageView object.
    internal var imageView: ImageView {
        return self.view as! ImageView // swiftlint:disable:this force_cast
    }

    /// Returns a UIImage representation of the receiver.
    /// - returns:	A UIImage object.
    public var uiimage: UIImage {
        get {
            let layer = imageView.layer as CALayer
            let contents = layer.contents as! CGImage // swiftlint:disable:this force_cast
            return UIImage(cgImage: contents, scale: CGFloat(scale), orientation: imageView.image!.imageOrientation)
        }
    }

    /// Returns a CGImageRef representation of the receiver.
    /// - returns:	A CGImageRef object.
    public var cgImage: CGImage {
        get {
            return uiimage.cgImage!
        }
    }

    /// Returns a CIImage representation of the receiver. Generally, this would be used to work with filters.
    /// - returns:	A CIImage object.
    public var ciImage: CIImage {
        get {
            return CIImage(cgImage: cgImage)
        }
    }

    /// An object that provides the contents of the layer. Animatable.
    /// The default value of this property is nil.
    /// If you are using the layer to display a static image, you can set this property to the CGImageRef containing the image
    /// you want to display. Assigning a value to this property causes the layer to use your image rather than create a
    /// separate backing store.
    public var contents: CGImage {
        get {
            let layer = imageView.layer as CALayer
            return layer.contents as! CGImage // swiftlint:disable:this force_cast
        } set(val) {
            imageView.layer.contents = val
        }
    }

    /// The current rotation value of the view. Animatable.
    /// - returns: A Double value representing the cumulative rotation of the view, measured in Radians.
    public override var rotation: Double {
        get {
            if let number = imageLayer.value(forKeyPath: Layer.rotationKey) as? NSNumber {
                return number.doubleValue
            }
            return  0.0
        }
        set {
            imageLayer.setValue(newValue, forKeyPath: Layer.rotationKey)
        }
    }


    /// The scale factor of the image. (read-only)
    var scale: Double {
        return Double(imageView.image!.scale)
    }

    /// A variable that provides access to the width of the receiver. Animatable.
    /// The default value of this property is defined by the image being created.
    /// Assigning a value to this property causes the receiver to change the width of its frame. If the receiver's
    /// `contrainsProportions` variable is set to `true` the receiver's height will change to match the new width.
    public override var width: Double {
        get {
            return Double(view.frame.size.width)
        } set(val) {
            var newSize = Size(val, Double(view.frame.size.height))
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
    public override var height: Double {
        get {
            return Double(view.frame.size.height)
        } set(val) {
            var newSize = Size(Double(view.frame.size.width), val)
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
    public var constrainsProportions: Bool = false

    internal var _originalSize: Size = Size()
    /// The original size of the receiver when it was initialized.
    public var originalSize: Size {
        get {
            return _originalSize
        }
    }

    /// The original width/height ratio of the receiver when it was initialized.
    public var originalRatio: Double {
        get {
            return _originalSize.width / _originalSize.height
        }
    }

    //MARK: Filters
    lazy internal var output: CIImage = self.ciImage
    lazy internal var filterQueue: DispatchQueue = {
        return DispatchQueue.global(qos: .background)
        }()
    lazy internal var renderImmediately = true
}
