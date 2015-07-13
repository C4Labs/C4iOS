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

class C4VectorTests: XCTestCase {
    func testUnitVector() {
        let vector = C4Vector(x: 8, y: 8, z: 8)
        let unitVector = vector.unitVector()!
        XCTAssertEqualWithAccuracy(unitVector.magnitude, 1, accuracy: 1e-15, "Magnitude of unit vector should be 1")
        XCTAssertEqual(unitVector.heading, vector.heading, "Heading of unit vector should be the same as the original")
    }
    
    func testNilUnitVector() {
        let vector = C4Vector(x: 0, y: 0, z: 0)
        let unitVector = vector.unitVector()
        XCTAssert(unitVector == nil, "Callin unitVector on a zero vector should return nil")
    }
    
    func testDotProduct() {
        let vectorA = C4Vector(x: 1, y: 0)
        let vectorB = C4Vector(x: 0, y: 1)
        XCTAssertEqualWithAccuracy(vectorA ⋅ vectorB, 0, accuracy: 1e-15, "Dot product of perpendicular vectors should be 0")
    }
    
    func testAngleTo() {
        let vectorA = C4Vector(x: 2, y: 0)
        let vectorB = C4Vector(x: 1, y: 1)
        let angle = vectorA.angleTo(vectorB)
        XCTAssertEqualWithAccuracy(angle, Double(M_PI)/4.0, accuracy: 1e-15, "Product should be PI/4")
    }

    func testAngleToBaseOn() {
        let vectorA = C4Vector(x: 2, y: 0)
        let vectorB = C4Vector(x: 1, y: 1)
        let vectorC = C4Vector(x: 1, y: 0)
        let angle = vectorA.angleTo(vectorB, basedOn:vectorC)
        XCTAssertEqualWithAccuracy(angle, Double(M_PI)/2.0, accuracy: 1e-15, "Product should be PI/2")
    }
    
    func testDivideScalar() {
        for i in 10...1000 {
            let v = Double(random(below:i))+1.0
            var vector = C4Vector(x:v,y:v)
            vector /= v
            XCTAssertEqual(vector.x, 1.0, "Vector should equal 1")
        }
    }
    
    func testMultiplyScalar() {
        for i in 10...1000 {
            let val = Double(i)
            var vector = C4Vector(x:val, y:val)
            vector *= 10
            XCTAssertEqual(vector.x, val*10, "Vector should equal 1")
        }
    }

    func testAddition() {
        for i in 10...1000 {
            let val = Double(i)
            var vector = C4Vector(x: val, y: val)
            vector += C4Vector(x: 1, y: 1)
            XCTAssertEqual(vector.x, val+1, "Vectore should be original value + 1")
        }
    }
    
    func testSubtraction() {
        for i in 10...1000 {
            let val = Double(i)
            var vector = C4Vector(x: val, y: val)
            vector -= C4Vector(x: 1, y: 1)
            XCTAssertEqual(vector.x, val-1, "Vectore should be original value - 1")
        }
    }
}
