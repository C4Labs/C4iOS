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

class C4TransformTests: XCTestCase {
    func testMultiplyByIndentity() {
        let identity = C4Transform()
        var transform = C4Transform()
        for col in 0...3 {
            for row in 0...3 {
                transform[row, col] = random01()
            }
        }
        XCTAssertEqual(identity * transform, transform, "Multiplying by the identity transform should not change the other transform")
        XCTAssertEqual(transform * identity, transform, "Multiplying by the identity transform should not change the other transform")
    }
    
    func testMultiplyByInverse() {
        let identity = C4Transform()
        var transform = C4Transform()
        transform[0, 0] = 1
        transform[0, 1] = 2
        transform[1, 0] = 2
        transform[1, 1] = 5
        transform[0, 3] = 5
        transform[1, 3] = 6
        
        XCTAssertEqual(transform * inverse(transform)!, identity,
            "A transform multiplied by its inverse should result in the identity transform")
    }
    
    func testTranslationProperty() {
        let translation = C4Vector(x: 10, y: 20)
        let transform = C4Transform.makeTranslation(translation)
        XCTAssertEqual(transform.translation, translation,
            "The transform's translation should match the translation used to create it")
    }
}
