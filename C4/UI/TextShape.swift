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
import Foundation

/// TextShape defines a concrete subclass of Shape that draws a bezier curve whose shape looks like text.
public class TextShape: Shape {
    /// The text used to define the shape's path. Defaults to "C4".
    public var text: String = "C4" {
        didSet {
            updatePath()
        }
    }
    /// The font used to define the shape's path. Defaults to AvenirNext-DemiBold, 80pt.
    public var font = Font(name: "AvenirNext-DemiBold", size: 80)! {
        didSet {
            updatePath()
        }
    }

    ///  Initializes an empty TextShape.
    override init() {
        super.init()

        lineWidth = 0.0
        fillColor = C4Pink
    }

    /// Initializes a new TextShape from a specifed string and a font
    ///
    /// ````
    /// let f = Font(name:"Avenir Next", size: 120)
    /// let t = TextShape(text:"C4", font: f)
    /// t.center = canvas.center
    /// canvas.add(t)
    /// ````
    ///
    /// - parameter text: The string to be rendered as a shape
    /// - parameter font: The font used to define the shape of the text
    public convenience init?(text: String, font: Font) {
        self.init()
        self.text = text
        self.font = font

        updatePath()
        origin = Point()
    }

    /// Initializes a new TextShape from a specifed string, using C4's default font.
    ///
    /// ````
    /// let t = TextShape(text:"C4")
    /// t.center = canvas.center
    /// canvas.add(t)
    /// ````
    ///
    /// - parameter text: text The string to be rendered as a shape
    public convenience init?(text: String) {
        guard let font = Font(name: "AvenirNext-DemiBold", size: 80) else {
            return nil
        }
        self.init(text: text, font: font)
    }

    override func updatePath() {
        path = TextShape.createTextPath(text: text, font: font)
        adjustToFitPath()
    }

    internal class func createTextPath(text: String, font: Font) -> Path? {
        let ctfont = font.ctFont as CTFont?
        if ctfont == nil {
            return nil
        }

        var unichars = [UniChar](text.utf16)
        var glyphs = [CGGlyph](repeating: 0, count: unichars.count)
        if !CTFontGetGlyphsForCharacters(ctfont!, &unichars, &glyphs, unichars.count) {
            // Failed to encode characters into glyphs
            return nil
        }

        var advances = [CGSize](repeating: CGSize(), count: glyphs.count)
        CTFontGetAdvancesForGlyphs(ctfont!, .default, &glyphs, &advances, glyphs.count)
        let textPath = CGMutablePath()
        var invert = CGAffineTransform(scaleX: 1, y: -1)
        var origin = CGPoint()
        for (advance, glyph) in zip(advances, glyphs) {
            if let glyphPath = CTFontCreatePathForGlyph(ctfont!, glyph, &invert) {
                let translation = CGAffineTransform(translationX: origin.x, y: origin.y)
                textPath.addPath(glyphPath, transform: translation)
            }
            origin.x += CGFloat(advance.width)
            origin.y += CGFloat(advance.height)
        }
        return Path(path: textPath)
    }
}
