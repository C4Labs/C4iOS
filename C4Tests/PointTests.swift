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
import XCTest

class PointTests: XCTestCase {
    func testDistance() {
        let pointA = Point()
        let pointB = Point(1, 1)
        XCTAssertEqualWithAccuracy(distance(pointA, rhs: pointB), sqrt(2), accuracy: DBL_MIN, "Distance between origin and (1,1) should be √2")
    }

    func testTranslate() {
        let original = Point(2, 3)
        let translated = original + Vector(x: 3, y: 2)
        XCTAssertEqual(translated, Point(5, 5), "Point should be translated to (5, 5)")
    }

    func testLerp() {
        let target = Point(10, 10)
        let lerped = lerp(Point(), target, at: 0.2)
        XCTAssertEqual(lerped, Point(2, 2), "Point should be {2,2}")
    }

}
