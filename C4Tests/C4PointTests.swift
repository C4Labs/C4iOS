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

class C4PointTests: XCTestCase {
    func testDistance() {
        let pointA = C4Point()
        let pointB = C4Point(1, 1)
        XCTAssertEqualWithAccuracy(distance(pointA, rhs: pointB), sqrt(2), accuracy: DBL_MIN, "Distance between origin and (1,1) should be √2")
    }
    
    func testTranslate() {
        let original = C4Point(2, 3)
        let translated = original + C4Vector(x: 3, y: 2)
        XCTAssertEqual(translated, C4Point(5, 5), "Point should be translated to (5, 5)")
    }
    
    func testLerp() {
        let target = C4Point(10,10)
        let lerped = lerp(a: C4Point(), b: target, param: 0.2)
        XCTAssertEqual(lerped, C4Point(2,2), "Point should be {2,2}")
    }
    
}
