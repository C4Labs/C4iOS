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

public class C4TextShape : C4Shape {
    convenience public init(text: String, font: C4Font) {
        var t = CGAffineTransformMakeScale(1,-1)
        let glyphPaths = CGPathCreateMutable()
        let ctfont = font.CTFont
        
        var currentOrigin = CGPointZero
        
        for character in text {
            var glyph = CTFontGetGlyphWithName(ctfont, "\(character)")
            var path = withUnsafePointer(&t) { (pointer: UnsafePointer<CGAffineTransform>) -> (CGPath) in
                return CTFontCreatePathForGlyph(ctfont, glyph, pointer)
            }
            
            var translation = CGAffineTransformMakeTranslation(currentOrigin.x, currentOrigin.y);
            CGPathAddPath(glyphPaths, &translation, path);
            
            
            var advance = withUnsafePointer(&glyph) {(glyphePointer: UnsafePointer<CGGlyph>) -> (Double) in
                return CTFontGetAdvancesForGlyphs(ctfont, .OrientationDefault, &glyph, nil, 1);
            }
            
            currentOrigin.x += CGFloat(advance);
        }
        
        var stringRect = CGPathGetBoundingBox(glyphPaths)
        self.init(frame: C4Rect(stringRect))
        self.path = C4Path(path: glyphPaths)
        adjustToFitPath()
        self.origin = C4Point(0,0)
    }
}