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

class C4RectTests: XCTestCase {
    func testIntersects() {
        let a = C4Rect(0,0,100,100)
        let b = C4Rect(50,50,100,100)
        let c = C4Rect(100,100,100,100)
        XCTAssertTrue(a.intersects(b),"a and b intersect")
        XCTAssertFalse(a.intersects(c),"a and c do not intersect")
    }
    
    func testCenter() {
        for _ in 1...10 {
            let val = Double(random(below:100))
            let rect = C4Rect(0,0,val,val)
            XCTAssertEqual(rect.center, C4Point(val/2.0,val/2.0),"Center point should be half the width and height of the C4Rect")
        }
    }
    
    func testMax() {
        for _ in 1...10 {
            let x = Double(random(below:100))
            let y = Double(random(below:100))
            let rect = C4Rect(x,y,100,100)
            XCTAssertEqual(rect.max, C4Point(x+100,y+100),"Max point should equal the origin plus the size of the C4Rect")
        }
    }
    
    func testIsZero() {
        XCTAssertTrue(C4Point().isZero(), "A point created with no arguments should be {0,0}")
    }
    
    func testContainsRect() {
        let a = C4Rect(0,0,100,100)
        let b = C4Rect(50,50,50,50)
        let c = C4Rect(50,50,100,100)
        XCTAssertTrue(a.contains(b),"A should contain B")
        XCTAssertTrue(c.contains(b),"C should contain B")
        XCTAssertFalse(a.contains(c),"A should not contain C")
    }
    
    func testContainsPoint() {
        let a = C4Rect(0,0,100,100)
        let b = C4Rect(25,25,50,50)
        let c = C4Rect(50,50,100,100)
        XCTAssertTrue(a.contains(b.center),"A should contain the center of B")
        XCTAssertTrue(b.contains(c.origin),"B should contain the origin of C")
        XCTAssertFalse(c.contains(b.origin),"C should not contain the center of A")
    }
    
    func testEquals() {
        let a = C4Rect(10,10,10,10)
        var b = C4Rect(0,0,10,10)
        b.center = C4Point(15,15)
        XCTAssertEqual(a,b,"A should be equal to B")
    }
    
    func testIntersection() {
        func r() -> Double {
            return Double(random(below: 90) + 10)
        }
        
        let a = C4Rect(0,0,r(),r())
        let b = C4Rect(10,10,r(),r())
        let c = intersection(a,rect2: b)
        let x = (b.max.x - a.max.x < 0) ? b.max.x : a.max.x
        let y = (b.max.y - a.max.y < 0) ? b.max.y : a.max.y
        let d = C4Rect(b.origin.x,b.origin.y,x-b.origin.x,y-b.origin.y)
        XCTAssertEqual(c,d,"C should be equal to D")
    }
    
    func testUnion() {
        func r() -> Double {
            return Double(random(below: 100))
        }
        
        let a = C4Rect(r(),r(),r()+1,r()+1)
        let b = C4Rect(r(),r(),r()+1,r()+1)
        let c = union(a,rect2: b)
        let o = C4Point(min(a.origin.x,b.origin.x),min(a.origin.y,b.origin.y))
        let s = C4Size(max(a.max.x,b.max.x)-o.x,max(a.max.y,b.max.y)-o.y)
        let d = C4Rect(o,s)
        XCTAssertEqual(c,d,"C should be equal to D")
    }

    func testIntegral() {
        //couldn't figure out how to build a dynamic test for this
    }
    
    func testStandardize() {
        func r() -> Double {
            return Double(random(below: 100))
        }
        let a = C4Point(r(),r())
        let b = C4Size(-r(),-r())
        let c = C4Rect(a.x+b.width,a.y+b.height,-b.width,-b.height)
        let d = standardize(C4Rect(a,b))
        XCTAssertEqual(c,d,"C should equal D")
    }
    
    func testInset() {
        func r() -> Double {
            return Double(random(below: 100))
        }
        let a = C4Rect(r(),r(),r()+1,r()+1)
        let x = r()
        let y = r()
        _ = inset(a,dx: x,dy: y)
        _ = C4Rect(a.origin,C4Size(a.size.width-x,a.size.height-y))
    }
}