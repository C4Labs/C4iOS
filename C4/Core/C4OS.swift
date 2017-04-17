// Copyright © 2015 C4
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

// MARK: - UIKit
#if os(iOS)
import UIKit

public typealias NativeColor = UIColor
public typealias NativeFont = UIFont
public typealias NativeGestureRecognizer = UIGestureRecognizer
public typealias NativeImage = UIImage
public typealias NativeView = UIView
public typealias NativeImageView = UIImageView
public typealias NativeViewController = UIViewController

public extension UIView {
    /// Same as `layer` but optional.
    var mainLayer: CALayer? {
        get {
            return layer
        }
    }
}

/// In UIKit all views have layers, but this class is here for consistency with OS X
public class LayerView : NativeView {
}

// MARK: - AppKit
#elseif os(OSX)
import AppKit

public typealias NativeColor = NSColor
public typealias NativeFont = NSFont
public typealias NativeGestureRecognizer = NSGestureRecognizer
public typealias NativeImage = NSImage
public typealias NativeView = NSView
public typealias NativeImageView = NSImageView
public typealias NativeViewController = NSViewController

public extension NSImage {
    convenience init(CIImage ciimage: CIImage) {
        let rep = NSCIImageRep(CIImage: ciimage)
        self.init(size: rep.size)
        addRepresentation(rep)
    }

    convenience init(CGImage cgimage: CGImageRef) {
        self.init(CGImage: cgimage, size: NSZeroSize)
    }

    var CGImage: CoreGraphics.CGImage? {
        return CGImageForProposedRect(nil, context: nil, hints: nil)
    }
}

public extension NSImageView {
    convenience init(image: NSImage) {
        self.init()
        self.image = image
        sizeToFit()
    }
}

/// Extensions for NSView to make it more like an UIView
public extension NSView {
    /// Same as `layer` for NSView. Need to rename it so that the interface is consistent with UIView
    var mainLayer: CALayer? {
        get {
            return layer
        }
        set {
            layer = newValue
        }
    }

    var center: NSPoint {
        get {
            return NSPoint(x: frame.midX, y: frame.midY)
        }
        set {
            setFrameOrigin(NSPoint(x: newValue.x - frame.width/2, y: newValue.y - frame.height/2))
        }
    }

    var alpha: CGFloat {
        get {
            return alphaValue
        }
        set {
            alphaValue = newValue
        }
    }
}

/// Hosted-layer NSView
public class LayerView : NativeView {
    public var backgroundColor: NSColor? {
        didSet {
            needsDisplay = true
        }
    }

    override public var wantsUpdateLayer: Bool {
        return true
    }

    override public func updateLayer() {
        if let layer = self.layer {
            layer.backgroundColor = backgroundColor?.CGColor
        }
    }
}

#endif // os
