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

class ViewController: CanvasController {
    let recorder = ScreenRecorder()

    override func setup() {
        recorder.controller = self

        recorder.didStop = {
            self.recorder.presentPreview(self)
        }

        recorder.previewFinished = { activities in
            print(activities)
        }

        canvas.backgroundColor = black
        createInner()
        createInnerMask()
        createOuter()
        positionShapes()

        canvas.addLongPressGestureRecognizer { location, state in
            self.recorder.start(5.0)
            self.startDemo()
        }
    }

    func startDemo() {
        initializeDisplayLink()
        animateCanvas()
    }

    var inner: Polygon!
    var innerMask: Polygon!
    var outer: Polygon!

    var pointCount = 90
    var radius = (50.0, 58.0)
    var lineWidths = (2.0, 0.5)
    var primaryColor = C4Blue

    func randomize(var points: [Point], var radius r: Double) -> [Point] {
        for _ in 0..<points.count {
            let index = random(below: points.count)
            if random(below: 10) > 6 {
                r = distance(Point(), rhs: points[index]) * Double(random(min: 95, max: 105)) / 100.0
            }
            let θ = Double(index) / 45.0 * M_PI
            points[index] = Point(r * sin(θ), r * cos(θ))
        }
        return points
    }

    func createInner() {
        inner = createPoly(radius: radius.0)
        inner.lineWidth = lineWidths.0
        inner.fillColor = black
        inner.strokeColor = primaryColor
    }

    func createInnerMask() {
        innerMask = createPoly(radius: radius.1)
        innerMask.fillColor = primaryColor
        inner.mask = innerMask
    }

    func createOuter() {
        outer = Polygon(innerMask.points)
        outer.strokeColor = primaryColor
        let uic = UIColor(primaryColor)?.colorWithAlphaComponent(0.2)
        outer.fillColor = Color(uic!)
        outer.lineWidth = lineWidths.1
        outer.close()
    }

    func positionShapes() {
        let container = View(frame: Rect(0, 0, 1, 1))
        container.add(outer)
        container.add(inner)
        container.center = canvas.center
        canvas.add(container)
    }

    func initializeDisplayLink() {
        let displayLink = CADisplayLink(target: self, selector: "update")
        displayLink.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
    }

    func animateCanvas() {
        let a = ViewAnimation(duration: 1.0) {
            self.canvas.transform.rotate(M_PI)
        }
        a.curve = .Linear
        a.repeats = true
        a.animate()
    }

    func update() {
        ViewAnimation(duration: 0) {
            self.inner.points = self.randomize(self.inner.points, radius: self.radius.1)
            let maskPoints = self.randomize(self.innerMask.points, radius: self.radius.0)
            self.innerMask.points = maskPoints
            self.outer.points = maskPoints
            }.animate()
    }

    func createPoly(radius r: Double) -> Polygon {
        var points = [Point]()
        for i in 0..<pointCount {
            let θ = Double(i) * M_PI * 2.0 / Double(pointCount)
            let pt = Point(r * sin(θ), r * cos(θ))
            points.append(pt)
        }
        let poly = Polygon(points)
        poly.close()
        return poly
    }
}
