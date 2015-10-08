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

private let C4AnimationCompletedEvent = "C4AnimationCompleted"
private let C4AnimationCancelledEvent = "C4AnimationCancelled"

public class C4Animation {
    public enum Curve {
        case Linear
        case EaseOut
        case EaseIn
        case EaseInOut
    }
    
    public var autoreverses = false
    public var repeatCount = 0.0
    public var repeats: Bool {
        get {
            return repeatCount > 0
        }
        set {
            if newValue {
                repeatCount = DBL_MAX
            } else {
                repeatCount = 0
            }
        }
    }
    
    /// The duration of the animation, measured in seconds.
    public var duration: NSTimeInterval = 1
    
    /// The animation curve that the receiver will apply to the changes it is supposed to animate.
    public var curve: Curve = .Linear
    
    private var completionObservers: [AnyObject] = []
    private var cancelObservers: [AnyObject] = []

    static var stack = [C4Animation]()
    static var currentAnimation: C4Animation? {
        return stack.last
    }

    public init() {
        
    }
    
    deinit {
        let nc = NSNotificationCenter.defaultCenter()
        for observer in completionObservers {
            nc.removeObserver(observer)
        }
        for observer in cancelObservers {
            nc.removeObserver(observer)
        }
    }
    
    public func addCompletionObserver(action: () -> Void) -> AnyObject {
        let nc = NSNotificationCenter.defaultCenter()
        let observer = nc.addObserverForName(C4AnimationCompletedEvent, object: self, queue: NSOperationQueue.currentQueue(), usingBlock: { notification in
            action()
        })
        completionObservers.append(observer)
        return observer
    }
    
    public func removeCompletionObserver(observer: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer, name: C4AnimationCompletedEvent, object: self)
    }
    
    public func postCompletedEvent() {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(C4AnimationCompletedEvent, object: self)
        }
    }
    
    public func addCancelObserver(action: () -> Void) -> AnyObject {
        let nc = NSNotificationCenter.defaultCenter()
        let observer = nc.addObserverForName(C4AnimationCancelledEvent, object: self, queue: NSOperationQueue.currentQueue(), usingBlock: { notification in
            action()
        })
        cancelObservers.append(observer)
        return observer
    }
    
    public func removeCancelObserver(observer: AnyObject) {
        let nc = NSNotificationCenter.defaultCenter()
        nc.removeObserver(observer, name: C4AnimationCancelledEvent, object: self)
    }
    
    public func postCancelledEvent() {
        dispatch_async(dispatch_get_main_queue()) {
            NSNotificationCenter.defaultCenter().postNotificationName(C4AnimationCancelledEvent, object: self)
        }
    }
}
