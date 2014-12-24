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

import Foundation

public protocol VisibleMediaObject: MediaObject, Visible, Mask {
    
}

//MARK: - Visible
public protocol Visible {
    var frame: C4Rect { get set }
    var bounds: C4Rect { get }
    var center: C4Point { get set }
    var size: C4Size { get }
    var constrainsProportions: Bool { get set }
    
    var backgroundColor: C4Color { get set }
    var opacity: Double { get set }
    var hidden: Bool { get set }
    
    var border: Border { get set }
    var shadow: Shadow { get set }
    var rotation: Rotation { get set }

    var perspectiveDistance: Double { get set }
}

public struct Border {
    public var color: C4Color
    public var radius: Double
    public var width: Double
    public init() {
        color = C4Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        radius = 0.0
        width = 0.0
    }
}

public struct Shadow {
    public var radius: Double
    public var color: C4Color
    public var offset: C4Size
    public var opacity: Double
    public var path: C4Path?
    
    public init() {
        radius = 5.0
        color = C4Color(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        offset = C4Size(5,5)
        opacity = 0.0
    }
}

//MARK: - Mask
public protocol Mask {
    var mask: Mask? { get set }
    var layer: CALayer? { get }
}

public struct Pan {
    weak public var gesture: UIPanGestureRecognizer?
    public var minimumNumberOfTouches : Int {
        didSet {
            self.gesture?.minimumNumberOfTouches = minimumNumberOfTouches
        }
    }
    
    public var maximumNumberOfTouches : Int {
        didSet {
            self.gesture?.maximumNumberOfTouches = maximumNumberOfTouches
        }
    }
    
    public init(_ recognizer: UIPanGestureRecognizer) {
        gesture = recognizer
        minimumNumberOfTouches = 1
        maximumNumberOfTouches = 1
    }
}

public enum RectEdges  {
    case None
    case Top
    case Left
    case Bottom
    case Right
    case All
    
    public init() {
        self = Left
    }
    
    public init(_ edges: UIRectEdge) {
        switch edges {
        case UIRectEdge.Top:
            self = Top
        case UIRectEdge.Left:
            self = Left
        case UIRectEdge.Right:
            self = Right
        case UIRectEdge.Bottom:
            self = Bottom
        case UIRectEdge.All:
            self = All
        default:
            self = None
        }
    }
}

public struct EdgePan {
    weak public var gesture: UIScreenEdgePanGestureRecognizer?
    
    public init(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        gesture = recognizer
        
    }
    
}

public struct LongPress {
    weak public var gesture: UILongPressGestureRecognizer?
    public var minimumPressDuration: Double {
        didSet {
            gesture?.minimumPressDuration = minimumPressDuration
        }
    }
    
    public var numberOfTapsRequired : Int {
        didSet {
            self.gesture?.numberOfTapsRequired = numberOfTapsRequired
        }
    }
    
    public var numberOfTouchesRequired : Int {
        didSet {
            self.gesture?.numberOfTouchesRequired = numberOfTouchesRequired
        }
    }
    
    public var allowableMovement : Double {
        didSet {
            self.gesture?.allowableMovement = CGFloat(allowableMovement)
        }
    }
    
    public init(_ recognizer: UILongPressGestureRecognizer) {
        gesture = recognizer
        minimumPressDuration = 0.25
        numberOfTouchesRequired = 1
        numberOfTapsRequired = 0
        allowableMovement = 10.0
    }
}

public enum SwipeDirection {
    case Left
    case Right
    case Up
    case Down
    
    public init() {
        self = Left
    }
    
    public init(_ direction: UISwipeGestureRecognizerDirection) {
        switch direction {
        case UISwipeGestureRecognizerDirection.Left:
            self = Left
        case UISwipeGestureRecognizerDirection.Right:
            self = Right
        case UISwipeGestureRecognizerDirection.Up:
            self = Up
        default:
            self = Down
        }
    }
}

public struct Swipe {
    weak public var gesture: UISwipeGestureRecognizer?
    public var direction : SwipeDirection {
        didSet {
            switch direction {
            case .Left:
                gesture?.direction = .Left
            case .Right:
                gesture?.direction = .Right
            case .Up:
                gesture?.direction = .Up
            case .Down:
                gesture?.direction = .Down
            }
        }
    }
    
    public var numberOfTouchesRequired: Int {
        didSet {
            gesture?.numberOfTouchesRequired = numberOfTouchesRequired
        }
    }
    
    public init(_ recognizer: UISwipeGestureRecognizer) {
        gesture = recognizer
        direction = .Left
        numberOfTouchesRequired = 1
    }
}
