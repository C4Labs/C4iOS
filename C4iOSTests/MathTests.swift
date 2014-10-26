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
import XCTest

class MathTests: XCTestCase {

    func testLerp() {
        XCTAssert(lerp(0.0, 10.0, 0.2) == 2.0, "Value should be interpolated")
    }

    func testClampLess() {
        var testValue = clamp(-1, 10, 20)
        var correctValue = 10
        XCTAssert(testValue == correctValue, "Value should be clamped to lower bound")
    }

    func testClampNoOp() {
        var testValue = clamp(11, 10, 20)
        var correctValue = 11
        XCTAssert(testValue == correctValue, "Value should not be clamped")
    }

    func testClampGreater() {
        var testValue = clamp(21, 10, 20)
        var correctValue = 20
        XCTAssert(testValue == correctValue, "Value should be clamped to upper bound")
    }


    func testMap() {
        let testValue = map(5, 0, 10, 0, 20)
        let correctValue = 10
        XCTAssert(testValue == correctValue, "Value should be mapped to the target range")
    }

    func testLerpDouble() {
        let testValue = map(5.0, 0.0, 10.0, 0.0, 20.0)
        let correctValue = 10.0
        XCTAssert(testValue == correctValue, "Double value should be mapped to the target range")
    }
}
