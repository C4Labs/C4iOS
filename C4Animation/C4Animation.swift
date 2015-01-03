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

import C4Core

private let C4AnimationCompletedEvent = "C4AnimationCompleted"
private let C4AnimationCancelledEvent = "C4AnimationCancelled"


public class C4Animation {
    public enum Curve {
        case Linear
        case EaseOut
        case EaseIn
        case EaseInOut
    }
    
    public var duration: NSTimeInterval = 1
    public var curve: Curve = .Linear
    
    private var completionObservers: [AnyObject] = []
    private var cancelObservers: [AnyObject] = []
    
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

public class C4GenericAnimation : C4Animation {
    public var beginTime: NSTimeInterval = 0
    public var paused: Bool = true
    
    private var startTime: NSTimeInterval = 0
    private var progress: Double = 0
    
    public func finished() -> Bool {
        return progress == 1
    }
    
    public func reset() {
        if startTime == 0 {
            return
        }
        
        postCancelledEvent()
        
        paused = true
        startTime = 0
        progress = 0
    }
    
    internal func animate(time: NSTimeInterval) {
        if finished() {
            return
        }
        
        if startTime == 0 && time >= beginTime {
            startTime = time
            paused = false
            return
        }
        
        let dt = time - startTime
        if duration > 0 {
            progress = clamp(dt / duration, 0.0, 1.0)
        } else {
            progress = 1
        }
        
        if finished() {
            paused = true
            self.postCompletedEvent()
        }
    }
}

extension NSObject {
    public func animationForKey(key: String) -> C4GenericAnimation? {
        return C4Animator.sharedAnimator.animation(object: self, key: key)
    }
    
    public func addAnimation(animation: C4GenericAnimation, key: String) {
        C4Animator.sharedAnimator.addAnimation(animation, object: self, key: key)
    }
    
    public func removeAnimation(#key: String) {
        C4Animator.sharedAnimator.removeAnimation(object: self, key: key)
    }
    
    public func removeAllAnimations() {
        C4Animator.sharedAnimator.removeAnimations(object: self)
    }
}
