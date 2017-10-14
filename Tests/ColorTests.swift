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

class ColorTests: XCTestCase {
    func testInitWithRedHexValue() {
        let redColor   = Color(0xFF0000)
        XCTAssertEqual(redColor.red, 1.0, "Red value should be 1.0")
        XCTAssertEqual(redColor.green, 0.0, "Green value should be 0.0")
        XCTAssertEqual(redColor.blue, 0.0, "Blue value should be 0.0")
        XCTAssertEqual(redColor.alpha, 1.0, "Alpha value should be 1.0")
    }

    func testInitWithGreenHexValue() {
        let greenColor = Color(0x00FF00)
        XCTAssertEqual(greenColor.red, 0.0, "Red value should be 0.0")
        XCTAssertEqual(greenColor.green, 1.0, "Green value should be 1.0")
        XCTAssertEqual(greenColor.blue, 0.0, "Blue value should be 0.0")
        XCTAssertEqual(greenColor.alpha, 1.0, "Alpha value should be 1.0")
    }

    func testInitWithBlueHexValue() {
        let blueColor  = Color(0x0000FF)
        XCTAssertEqual(blueColor.red, 0.0, "Red value should be 0.0")
        XCTAssertEqual(blueColor.green, 0.0, "Green value should be 0.0")
        XCTAssertEqual(blueColor.blue, 1.0, "Blue value should be 1.0")
        XCTAssertEqual(blueColor.alpha, 1.0, "Alpha value should be 1.0")
    }

    func testHueSaturationBrightnesWithRGBColors() {
        XCTAssertEqual(red.hue, 0.0/360.0, "Red value should be 0.0")
        XCTAssertEqual(red.saturation, 1.0, "Saturation value should be 0.0")
        XCTAssertEqual(red.brightness, 1.0, "Brightness value should be 1.0")
        XCTAssertEqual(red.alpha, 1.0, "Alpha value should be 1.0")

        XCTAssertEqual(green.hue, 120.0/360.0, "Red value should be 0.0")
        XCTAssertEqual(green.saturation, 1.0, "Saturation value should be 1.0")
        XCTAssertEqual(green.brightness, 1.0, "Brightness value should be 1.0")
        XCTAssertEqual(green.alpha, 1.0, "Alpha value should be 1.0")

        XCTAssertEqual(blue.hue, 240.0/360.0, "Red value should be 0.0")
        XCTAssertEqual(blue.saturation, 1.0, "Saturation value should be 1.0")
        XCTAssertEqual(blue.brightness, 1.0, "Brightness value should be 1.0")
        XCTAssertEqual(blue.alpha, 1.0, "Alpha value should be 1.0")
    }
}
