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

public class C4Curve : C4Shape {
    public override init() {
        self.points = [C4Point]()
        self.controls = [C4Point]()
        super.init()
    }
    /**
    Creates a bezier curve.
    
        let p1 = C4Point()
        let p2 = C4Point(100,0)
        let c1 = C4Point(0,50)
        let c2 = C4Point(100,50)
        let crv = C4Curve(points: [p1,p2], controls: [c1,c2])

    - parameter points: The beginning and end points	of the curve.
    - parameter controls: The control points used to define the shape of the curve.
    */
    
    convenience public init(points: [C4Point], controls: [C4Point]) {
        self.init()
        self.points = points
        self.controls = controls

        let p0 = CGPoint(points[0])
        let p1 = CGPoint(points[1])
        let c0 = CGPoint(controls[0])
        let c1 = CGPoint(controls[1])
        
        let curve = CGPathCreateMutable()
        CGPathMoveToPoint(curve, nil, p0.x, p0.y)
        CGPathAddCurveToPoint(curve, nil, c0.x,c0.y,c1.x,c1.y,p1.x,p1.y)
        let curveRect = CGPathGetBoundingBox(curve)
        
        self.frame = C4Rect(curveRect)
        self.path = C4Path(path:curve)
        adjustToFitPath()
    }
    
    public var points : [C4Point] {
        didSet {
            if points.count > 2 {
                updatePath()
            }
        }
    }
    
    public var controls : [C4Point] {
        didSet {
            if controls.count > 2 {
                updatePath()
            }
        }
    }
    
    var shouldUpdate = true

    override func updatePath() {
        if shouldUpdate {
            let p0 = CGPoint(points[0])
            let p1 = CGPoint(points[1])
            let c0 = CGPoint(controls[0])
            let c1 = CGPoint(controls[1])
            
            let curve = CGPathCreateMutable()
            CGPathMoveToPoint(curve, nil, p0.x, p0.y)
            CGPathAddCurveToPoint(curve, nil, c0.x,c0.y,c1.x,c1.y,p1.x,p1.y)
            let curveRect = CGPathGetBoundingBox(curve)
            
            self.frame = C4Rect(curveRect)
            self.path = C4Path(path:curve)
            adjustToFitPath()
        }
    }
    
    /**
    The beginning point of the receiver. Animatable.
    Assigning a new value to this variable will cause the head of the line to move to a new position.
    
    var l = C4Line([C4Point(), C4Point(100,100)])
    l.a = C4Point(0,100)
    */
    public var a: C4Point {
        get {
            return points[0]
        } set(val) {
            points[0] = val
            updatePath()
        }
    }
    
    /**
    The end point of the receiver. Animatable.
    Assigning a new value to this variable will cause the end of the line to move to a new position.
    
    var l = C4Line([C4Point(), C4Point(100,100)])
    l.b = C4Point(100,200)
    */
    public var b: C4Point {
        get {
            return points[1]
        } set(val) {
            points[1] = val
            updatePath()
        }
    }

    /**
    The beginning point of the receiver. Animatable.
    Assigning a new value to this variable will cause the head of the line to move to a new position.
    
    var l = C4Line([C4Point(), C4Point(100,100)])
    l.a = C4Point(0,100)
    */
    public var c: C4Point {
        get {
            return controls[0]
        } set(val) {
            controls[0] = val
            updatePath()
        }
    }
    
    /**
    The end point of the receiver. Animatable.
    Assigning a new value to this variable will cause the end of the line to move to a new position.
    
    var l = C4Line([C4Point(), C4Point(100,100)])
    l.b = C4Point(100,200)
    */
    public var d: C4Point {
        get {
            return controls[1]
        } set(val) {
            controls[1] = val
            updatePath()
        }
    }
}