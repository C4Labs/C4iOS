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

public extension View {
    /// Creates a flattened image of the receiver and its subviews / layers.
    /// - returns: A new Image
    public func render() -> Image? {
        guard let l = layer else {
            print("Could not retrieve layer for current object: \(self)")
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(CGSize(size), false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()!
        l.render(in: context)
        let uiimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Image(uiimage: uiimage!)
    }
}

public extension Shape {
    /// Creates a flattened image of the receiver and its subviews / layers.
    /// This override takes into consideration the lineWidth of the receiver.
    /// - returns: A new Image
    public override func render() -> Image? {
        var s = CGSize(size)
        var inset: CGFloat = 0

        if let alpha = strokeColor?.alpha, alpha > 0.0 && lineWidth > 0 {
            inset = CGFloat(lineWidth/2.0)
            s = CGRect(frame).insetBy(dx: -inset, dy: -inset).size
        }

        let scale = CGFloat(UIScreen.main.scale)
        UIGraphicsBeginImageContextWithOptions(s, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        context.translateBy(x: CGFloat(-bounds.origin.x)+inset, y: CGFloat(-bounds.origin.y)+inset)
        shapeLayer.render(in: context)
        let uiimage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return Image(uiimage: uiimage!)
    }
}
