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

import C4
import UIKit

class ViewController: C4CanvasController {
    override func setup() {
        let c = C4Circle(center: canvas.center, radius: 25)
        let g = C4Gradient(frame:c.frame, colors: [C4Blue, C4Pink])
        c.gradientFill = g

        let star = C4Star(center: canvas.center, pointCount: 10, innerRadius: 50, outerRadius: 80)
        g.frame = star.frame
        star.gradientFill = g
        canvas.add(star)
        canvas.add(c)

        var b = false
        let a = C4ViewAnimation(duration:1.0) {
            if b {
                star.gradientFill = g
            } else {
                star.fillColor = C4Pink
            }
            b = !b
        }

        canvas.addTapGestureRecognizer { (location, state) -> () in
            a.animate()
        }
    }
}
