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

import Foundation
import CoreGraphics

public extension Image {
    ///  Initializes and returns a new cgimage from the color at a specified point in the receiver.
    ///  ````
    ///  let image = cgimage(at: CGPoint())
    ///  ````
    /// - parameter at: a CGPoint.
    func cgimage(at point: CGPoint) -> CGImage? {
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

        guard let offscreenContext = CGContext(data: nil, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 0, space: CGColorSpaceCreateDeviceRGB(), bitmapInfo: bitmapInfo.rawValue) else {
            print("Could not create offscreenContext")
            return nil
        }

        offscreenContext.translateBy(x: CGFloat(-point.x), y: CGFloat(-point.y))

        layer?.render(in: offscreenContext)

        guard let image = offscreenContext.makeImage() else {
            print("Could not create pixel image")
            return nil
        }
        return image
    }

    ///  Initializes and returns a new Color from a Point within the receiver.
    ///  ````
    ///  let color = img.color(at: Point())
    ///  ````
    /// - parameter at: a Point.
    public func color(at point: Point) -> Color {

        guard bounds.contains(point) else {
            print("Point is outside the image bounds")
            return clear
        }

        guard let pixelImage = cgimage(at: CGPoint(point)) else {
            print("Could not create pixel Image from CGImage")
            return clear
        }

        let imageProvider = pixelImage.dataProvider
        let imageData = imageProvider?.data
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(imageData)

        return Color(red: Double(data[1])/255.0,
                     green: Double(data[2])/255.0,
                     blue: Double(data[3])/255.0,
                     alpha: Double(data[0])/255.0)
    }
}
